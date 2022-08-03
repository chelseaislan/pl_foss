import 'package:flutter/material.dart';
import 'package:pl_foss/text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  final String date;
  const ResultPage({Key? key, required this.date}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  SharedPreferences? preferences;
  String? checkInDate;

  Future<void> initializePreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    checkInDate = widget.date;
    super.initState();
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(seconds: 0);
    initializePreference().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_outlined)),
            title: const Text("Result"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/check.png',
                    width: size.width * 0.3,
                  ),
                  const SizedBox(height: 10),
                  const HeaderTwoText(
                    color: Colors.teal,
                    text: "Check-In Berhasil",
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ChatText(
                            text: "Nama Lengkap", color: Colors.black),
                        HeaderThreeText(
                            text: "${preferences?.getString("name")}",
                            color: Colors.black),
                        const SizedBox(height: 10),
                        const ChatText(
                            text: "Nomor Identitas", color: Colors.black),
                        HeaderThreeText(
                            text: "${preferences?.getString("id")}",
                            color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black26)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ChatText(
                            text: "Lokasi Check-In", color: Colors.black),
                        HeaderThreeText(
                            text: "${preferences?.getString("place")}",
                            color: Colors.black),
                        const SizedBox(height: 10),
                        const ChatText(
                            text: "Tanggal & Waktu Check In",
                            color: Colors.black),
                        HeaderThreeText(
                            text: "$checkInDate", color: Colors.black),
                        const SizedBox(height: 10),
                        const ChatText(
                            text: "Kategori Aktivitas", color: Colors.black),
                        const HeaderThreeText(
                            text: "Aktivitas Dalam Ruangan",
                            color: Colors.black),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        transitionAnimationController: _animationController,
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
                            padding: const EdgeInsets.all(60),
                            child: Image.asset(
                              "assets/images/vaccine.png",
                              width: size.width * 0.5,
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: size.width,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 45, 129, 67),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/images/qr.jpg'),
                          Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 88, 151, 103),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const DescText(
                                  text: "Lihat Kode QR", color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Image.asset(
                    "assets/images/pl.png",
                    width: size.width * 0.4,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
