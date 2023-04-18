import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Edit Your Profile",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Enter your Name",
                    labelText: "UserName",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
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
              SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android_rounded),
                    hintText: "Enter your Phone Number",
                    labelText: "Phone Number",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
               SizedBox(
                 width: MediaQuery.of(context).size.width / 1.2,
                 height: 50,
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.of(context).pushNamedAndRemoveUntil(
                           '/account', (route) => false);
                     },
                     child: Text("Save"),
                   ),
                 ),
               ),
               SizedBox(
                 height: 15,
               ),
               SizedBox(
                 width: MediaQuery.of(context).size.width / 1.2,
                 height: 50,
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: ElevatedButton(
                       onPressed: () {
                         Navigator.of(context).pushNamedAndRemoveUntil(
                             '/account', (route) => false);
                       },
                       child: Text("Discard")),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
