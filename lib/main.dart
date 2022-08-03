import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pl_foss/camera_screen.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    await initializeDateFormatting('id_ID', null);
  } on CameraException catch (e) {
    debugPrint('Error in fetching the cameras: $e');
  }
  runApp(const PeduliApp());
}

class PeduliApp extends StatelessWidget {
  const PeduliApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "TTCommons",
      ),
      debugShowCheckedModeBanner: false,
      home: const CameraScreen(),
    );
  }
}
