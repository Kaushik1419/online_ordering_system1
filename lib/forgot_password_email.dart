import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final String emailIdInput = "";
  final _formkey1 = GlobalKey<FormState>();
  String code = "";
  String? userId;


  void login( String emailId) async {

    try {

      var uri = Uri.parse('https://shopping-app-backend-t4ay.onrender.com/user/forgotPassword');
      var response = await http.post(
          uri ,
          body: {
            "emailId": emailId,

          });
      if (response.statusCode == 200) {

        var data = jsonDecode(response.body.toString());
        print(data);
        userId = data['data']['_id'];
        print('$userId');
        print('Send the OTP!!!!!!!');
        Future.delayed(Duration(seconds: 2),(){
          print('$userId');
          Navigator.of(context).pushNamed('/forgotOTP', arguments: userId);
        });
        Fluttertoast.showToast(
            msg: "OTP has been sent to your email address!!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);

      } else if (response.statusCode == 400) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print("Enter the valid value");
        Fluttertoast.showToast(
            msg: "Something went wrong!!",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey1,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      child: Image.asset(
                        "assets/image91.jpg",
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 200,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter your EmailId!!",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 40,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller:  emailController,
                      onChanged: (value) {
                        value = emailIdInput;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Enter your Email id";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_rounded),
                        hintText: "Enter your Gmail",
                        labelText: "Email Id",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey1.currentState!.validate()) {
                            print("test");
                            print("test111111");

                            login(emailController.text);
                          }
                        },
                        child: const Text("Next"),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
