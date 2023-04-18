import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class Verification extends StatefulWidget {
  const Verification({Key? key}) : super(key: key);

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String digitInputValue = "";
  bool isLoading = true;

  late String id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      access(context);
    });
  }

  access(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments.toString();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void digit(String otp, String userId) async {
    try {
      var response = await post(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/user/verifyOtpOnRegister'),
          body: {
            'userId': id,
            'otp': digitInputValue,
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('data');
        print(data['token']);
        print("OTP verified!");
        Navigator.pushNamedAndRemoveUntil(
            context, '/loginpage', (Route<dynamic> route) => false);
        Fluttertoast.showToast(
            msg: "OTP verified!!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);
      } else if (response.statusCode == 400) {
        print("User not Registered");
        Fluttertoast.showToast(
            msg: "Enter the valid OTP!!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  late Timer _timer;
  int _start = 60;

  void resend(String userId) async {
    try {
      var response1 = await post(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/user/resendOtp'),
          body: {'userId': userId});
      if (response1.statusCode == 200) {
        var data = jsonDecode(response1.body.toString());
        print(data);
        print("OTP send again");
        setState(() {
          _isResendAgain = true;
        });

        const oneSec = Duration(seconds: 1);
        _timer = Timer.periodic(oneSec, (timer) {
          setState(() {
            if (_start == 0) {
              _start = 60;
              _isResendAgain = false;
              timer.cancel();
            } else {
              _start--;
            }
          });
        });
      } else if (response1.statusCode == 400) {
        var data = jsonDecode(response1.body.toString());
        print(data);
        print("Something went wrong!!!!");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  verify() {
    setState(() {
      _isLoading = true;
    });

    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: isLoading == true
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/image6.jpg"),
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      "Verification",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Please enter the 4 digit code sent to you number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          height: 1.5),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    VerificationCode(
                      length: 4,
                      textStyle: const TextStyle(fontSize: 20),
                      underlineColor: Colors.blueAccent,
                      keyboardType: TextInputType.number,
                      onCompleted: (value) {
                        digitInputValue = value;
                      },
                      onEditing: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't recieve the OTP?",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade500),
                        ),
                        TextButton(
                            onPressed: () {
                              print("id");
                              if (_isResendAgain) return;
                              resend(id);
                            },
                            child: Text(
                              _isResendAgain
                                  ? "Try again in  $_start"
                                  : "Resend",
                              style: const TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MaterialButton(
                      disabledColor: Colors.grey.shade300,
                      onPressed: () {
                        verify();

                        digit(digitInputValue.toString(), id);
                      },
                      color: Colors.blueAccent,
                      minWidth: MediaQuery.of(context).size.width / 3,
                      height: 50,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 3,
                                color: Colors.blue,
                              ),
                            )
                          : _isVerified
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 30,
                                )
                              : const Text(
                                  "Verify",
                                  style: TextStyle(color: Colors.white),
                                ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
