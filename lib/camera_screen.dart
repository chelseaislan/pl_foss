import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pl_foss/result.dart';
import 'package:pl_foss/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? controller;
  bool _isCameraInitialized = false;
  final TextEditingController? _nameController = TextEditingController();
  final TextEditingController? _idController = TextEditingController();
  final TextEditingController? _placeController = TextEditingController();
  SharedPreferences? preferences;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() => _isCameraInitialized = controller!.value.isInitialized);
    }
  }

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);
    super.initState();
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _nameController?.dispose();
    _idController?.dispose();
    _placeController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: "Account",
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, 10, 20, MediaQuery.of(context).viewInsets.bottom),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                              icon: Icon(Icons.person_outlined),
                            ),
                          ),
                          TextFormField(
                            controller: _idController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "ID Number",
                              icon: Icon(Icons.numbers_outlined),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  _nameController?.text != null
                                      ? preferences?.setString(
                                          "name", "${_nameController?.text}")
                                      : null;
                                  _idController?.text != null
                                      ? preferences?.setString(
                                          "id", "${_idController?.text}")
                                      : null;
                                });
                              },
                              child: const Text("Save Account"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          title: Image.asset(
            'assets/images/plwhite.png',
            fit: BoxFit.contain,
            height: 100,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.location_on_outlined),
              tooltip: "Location",
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, 10, 20, MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _placeController,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: "Current Location",
                                icon: Icon(Icons.location_city_outlined),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    _placeController?.text != null
                                        ? preferences?.setString("place",
                                            "${_placeController?.text}")
                                        : null;
                                  });
                                },
                                child: const Text("Save Value"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Center(
            child: _isCameraInitialized
                ? AspectRatio(
                    aspectRatio: 1 / controller!.value.aspectRatio,
                    child: controller!.buildPreview(),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.72,
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.qr_code_2_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ResultPage(
                      date: DateFormat("dd MMMM yyyy, kk:mm:ss", "id_ID")
                          .format(DateTime.now()));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
