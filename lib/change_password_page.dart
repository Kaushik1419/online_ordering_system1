import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool StatusCode = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final String emailIdInput = "";
  final String passwordInput = "";
  final String ConfirmPasswordInput = "";
  final _formkey1 = GlobalKey<FormState>();
  bool _obsecuretext = true;

  void changePassword(String newPass, String confirmPass) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';
    StatusCode = ((preferences.getBool('statusCode') ?? '') as bool?)!;
    print(jwtToken);
    String url =
        'https://shopping-app-backend-t4ay.onrender.com/user/changePassword';
    var body = {"newPass" : newPass, 'confirmPass' : confirmPass};
    print(newPass);
    print(confirmPass);
    final header = {
      "Authorization": 'Bearer $jwtToken',
      'Accept': 'application/json',
      'Charset': 'utf-8'
      
    };
    var response = await http.post(Uri.parse(url), headers: header, body: body);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body.toString());
      print(parsed);
      StatusCode = false;
      SharedPreferences preferences =
      await SharedPreferences.getInstance();
      preferences.setBool('statusCode', StatusCode!);
      Navigator.of(context).pushNamedAndRemoveUntil('/loginpage', (Route route) => route.settings.name == '/loginpage');

    }  else if(response.statusCode == 400) {
      var parsed = jsonDecode(response.body.toString());
      print(parsed);
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
                children: [
                  Container(
                      child: Image.asset(
                        "assets/image58.jpg",
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: 200,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Change Your Password",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 35,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: passwordController,
                      onChanged: (value) {
                        value = passwordInput;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return "Enter your Password";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
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
                        hintText: "Enter your Password",
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
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: ConfirmPasswordController,
                      onChanged: (value) {
                        value = ConfirmPasswordInput;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter your ConfirmPassword';
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
                            changePassword(passwordController.text, ConfirmPasswordController.text);
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
