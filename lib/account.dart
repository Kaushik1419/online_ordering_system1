import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? name;
  String? mobileNo;
  String? emailId;
  late SharedPreferences preferences;
  bool? StatusCode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedPrefs();
  }

  Future sharedPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String jwtToken = preferences.getString('jwtToken') ?? '';
    name = preferences.getString('name') ?? '';
    mobileNo = preferences.getString('mobileNo') ?? '';
    emailId = preferences.getString('email') ?? '';
    StatusCode = (preferences.getBool('statusCode') ?? '') as bool?;
    print(StatusCode.toString());

   print(jwtToken);
    print(name);
    print(mobileNo);
    print(emailId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 8.0, top: 50),
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: CircleAvatar(
                        radius: 150,
                        backgroundImage:
                            AssetImage('assets/image27.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),
                FutureBuilder(
                  future: sharedPrefs(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return Center(
                        child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(CupertinoIcons.profile_circled),Text('${emailId.toString()}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)]),
                        SizedBox(
                          height: 4,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.phone),Text('${mobileNo.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)]),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Icon(Icons.email),
                                Text(" ${name.toString()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                              ],
                            ))
                    ],
                  ),
                      );
                    } else{
                    return Center(child: CircularProgressIndicator(),);
                    }}
                ),
                SizedBox(height: 15,),
                Divider(thickness: 2,),
                SizedBox(
                  height: 70,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      child: const Text("About Us", style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/changeThePassword');
                      },
                      child: const Text("Change The Password", style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: () async{
                        StatusCode = false;
                        SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                        preferences.setBool('statusCode', StatusCode!);
                        Navigator.of(context).pushNamedAndRemoveUntil('/loginpage', (Route route) => route.settings.name == '/loginpage');
                      },
                      child: const Text("Sign Out", style: TextStyle(fontSize: 18),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
