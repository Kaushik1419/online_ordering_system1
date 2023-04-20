import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:online_ordering_system1/GetX/getx_register_api.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  SignUpGetx signUpGetx = Get.put(SignUpGetx());
  String nameInputValue = "";
  String emailIdInputValue = "";
  String mobileInputValue = "";
  String passwordInputValue = "";

  final _formkey = GlobalKey<FormState>();
  bool _obsecuretext = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  String _confirmpass = '';

  String? userId;
  void register(
      String name, String emailId, String mobileNo, String password) async {
    try {
      var response = await post(
          Uri.parse(
              'https://shopping-app-backend-t4ay.onrender.com/user/registerUser'),
          body: {
            'name': nameInputValue,
            'emailId': emailIdInputValue,
            'mobileNo': mobileInputValue,
            'password': passwordInputValue,
          });

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body.toString());
        print(data);
        print(data['token']);

        print('Go to the OTP page');
        userId = data['data']['_id'];
        print('$userId');
        Navigator.pushNamed(context, '/verificationpage', arguments: userId);
        Fluttertoast.showToast(
            msg: "Otp has been send to your Email",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16);
      } else if (response.statusCode == 400) {
        print("User already exist");
        Fluttertoast.showToast(
            msg: "User already exist!",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 2,
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
          key: _formkey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/image1.png",
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Text(
                    "Create an Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 40,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      onChanged: (value1) {
                        setState(() {
                          emailIdInputValue = value1;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty && !EmailValidator.validate(value)) {
                          return "Enter your emailId id";
                        }
                        return null;
                      },
                      controller: signUpGetx.emailIdController.value,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_rounded),
                        hintText: "Enter your Gmail",
                        labelText: "emailId Id",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          nameInputValue = value;
                        });
                      },
                      controller: signUpGetx.nameController.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Name";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_rounded),
                        hintText: "Enter your name",
                        labelText: "Username",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          mobileInputValue = value;
                        });
                      },
                      controller: signUpGetx.mobileNoController.value,
                      validator: (value) {
                        if (value!.isEmpty && value == 10) {
                          return "Enter your contact number";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone_android_rounded),
                        hintText: "Enter your Contact number",
                        labelText: "Phone number",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      onChanged: (value) {
                        passwordInputValue = value;
                      },
                      controller: signUpGetx.passController.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is not Empty";
                        }
                        return null;
                      },
                      obscureText: _obsecuretext,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_rounded),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obsecuretext = !_obsecuretext;
                            });
                          },
                          child: Icon(_obsecuretext
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                        ),
                        hintText: "Enter your password",
                        labelText: "Password",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      onChanged: (value) {
                        _confirmpass = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your Confirm Password";
                        }
                        if (_confirmpass != passwordInputValue) {
                          return "Does not match to the Password";
                        }
                        return null;
                      },
                      obscureText: _obsecuretext,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_rounded),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obsecuretext = !_obsecuretext;
                            });
                          },
                          child: Icon(_obsecuretext
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded),
                        ),
                        hintText: "Enter your Confirm Password",
                        labelText: "Confirm Password",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    child: Obx(() =>
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:signUpGetx.isLoaded.value ? Center(child: CircularProgressIndicator(),): ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              signUpGetx.register(
                                signUpGetx.nameController.value.toString(),
                                signUpGetx.emailIdController.value.toString(),
                                signUpGetx.mobileNoController.value.toString(),
                                signUpGetx.passController.value.toString(),
                              );
                            }
                          },
                          child: const Text("Verify"),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/loginpage');
                          },
                          child: const Text(
                            "Login!",
                            style: TextStyle(
                                fontSize: 14, color: Colors.redAccent),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
