import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lerereeeen/login/mob_log.dart';

import '../model.dart';

class mobprof extends StatefulWidget {
  const mobprof({Key? key}) : super(key: key);
  static String routeName = 'mobprof';

  @override
  State<mobprof> createState() => _mobprofState();
}

class _mobprofState extends State<mobprof> {
  final _auth = FirebaseAuth.instance;
  User? user;
  UserModel loggedInUser = UserModel();
  String rooll = '';
  var emaill;
  String id = '';
  String namee = '';
  String dob = '';
  String mobile = '';
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
      }).whenComplete(() {
        const CircularProgressIndicator();
        setState(() {
          emaill = loggedInUser.email.toString();
          rooll = loggedInUser.gender.toString();
          id = loggedInUser.uid.toString();
          namee = loggedInUser.name.toString();
          dob = loggedInUser.dob.toString();
          mobile = loggedInUser.mobile.toString();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 211, 243),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: InkWell(
            onTap: () {
              
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Home Page ',
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          _getHeader(),
          const SizedBox(
            height: 10,
          ),
          _profileName(namee),
          const SizedBox(
            height: 14,
          ),
          _heading(
            "Personal Details",
          ),
          const SizedBox(
            height: 10,
          ),
          _detailsCard(),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          // _counsellorCard(),
          const Spacer(),
          logoutButton()
        ],
      )),
    );
  }

  Widget _getHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Container(
        //     height: 100,
        //     width: 100,
        //     decoration: const BoxDecoration(
        //         //borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //         shape: BoxShape.circle,
        //         image: DecorationImage(
        //             fit: BoxFit.fill,
        //             image: AssetImage('assets/image/profileava.png'))
        //         // color: Colors.orange[100],
        //         ),
        //   ),
        // ),
      ],
    );
  }

  Widget _profileName(String name) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Center(
        child: Text(
          name,
          style: const TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _heading(String heading) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.80, //80% of width,
      child: Text(
        heading,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget _detailsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            //row for each details
            ListTile(
              leading: const Icon(Icons.email),
              title: Text("$emaill"),
            ),
            const Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: const Icon(Icons.numbers_outlined),
              title: Text(mobile),
            ),
            const Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: const Icon(Icons.person_2_rounded),
              title: Text(rooll),
            ),
            const Divider(
              height: 0.6,
              color: Colors.black87,
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: Text("DOB : $dob"),
            ),
            const Divider(
              height: 0.6,
              color: Colors.black87,
            ),
           
            const Divider(
              color: Colors.black87,
              height: 0.6,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  // Widget _counsellorCard() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Card(
  //       elevation: 4,
  //       child: Column(
  //         children: [
  //           //row for each details
  //           ListTile(
  //             leading: Icon(Icons.topic),
  //             title: Text("Name: XYZ"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.email),
  //             title: Text("faculty@gmail.com"),
  //           ),
  //           Divider(
  //             height: 0.6,
  //             color: Colors.black87,
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.phone),
  //             title: Text("123456789"),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget logoutButton() {
    return InkWell(
      onTap: () {
        _auth.signOut().then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const moblog(),)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            width: 170,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.red),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
