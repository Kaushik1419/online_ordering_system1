
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:online_ordering_system1/GetX/get_login_api.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey1 = GlobalKey<FormState>();
  bool _obsecuretext = true;
LoginGetX loginController = Get.put(LoginGetX());
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
                    "assets/image2.png",
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: 200,
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome Back!",
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
                      controller: loginController.emailController.value,
                      validator: (String? value) {
                        if (value!.isEmpty && !EmailValidator.validate(value)) {
                          return "Enter your password";
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
                    height: 40,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: loginController.passwordController.value,

                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Enter your password';
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
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed("/forgotpassword");
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 125,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Obx(() =>
                         loginController.isLoading.value ? Center(child: CircularProgressIndicator()) : ElevatedButton(
                          onPressed: () {
                            if (_formkey1.currentState!.validate()) {
                              print("test");
                              loginController.login(
                                  loginController.emailController.value.text, loginController.passwordController.value.text);

                            }
                          },
                          child: const Text("Login"),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/singuppage');
                            },
                            child: const Text(
                              "Sign In!",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.redAccent),
                            ))
                      ],
                    ),
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
