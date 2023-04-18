import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? statusCode;

  Future<void> getEmail() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    statusCode = preferences.getBool('statusCode');
    print(statusCode);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getEmail().whenComplete(() {
      Timer(
        const Duration(milliseconds: 4000),
            () {
          if (statusCode == true && mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/navbar',
                  (Route<dynamic> route) => route.settings.name == '/navbar',
            );
          } else if (statusCode == false && mounted) {
            Navigator.of(context).pushNamed('/loginpage');
            startTimer();
          }
        },
      );
    });
  }

  void startTimer() async {
    const duration = Duration(milliseconds: 3800);
    Timer(duration, navigationPage);
  }

  void navigationPage() {
    if (mounted) {
      Navigator.of(context).pushNamed('/loginpage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(),
              child: Lottie.asset('assets/lottie/lottie7.json'),
            ),
          ),
        ],
      ),
    );
  }
}
