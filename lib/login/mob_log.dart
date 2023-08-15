
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_containers/addstu/addstu.dart';
import '../profile/mob_profile.dart';



class moblog extends StatefulWidget {
  // final VoidCallback onLoginSuccess;

  const moblog({
    Key? key,
  }) : super(key: key);
  static String routeName = 'moblog';

  @override
  State<moblog> createState() => _moblogState();
}

class _moblogState extends State<moblog> {
  bool _isObscure3 = true;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();

  final _emailcontroller = TextEditingController();
  final _passcontroller = TextEditingController();
  bool _isupload = false;

  String _emailError = '';
  String _passwordError = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body:  Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _emailcontroller,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email cannot be empty";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please enter a valid email");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _emailcontroller.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Text(
                  _emailError,
                  style: const TextStyle(color: Colors.red),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    controller: _passcontroller,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(_isObscure3
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isObscure3 = !_isObscure3;
                              });
                            }),
                        labelText: "Password"),
                    obscureText: _isObscure3,
                    validator: (value) {
                      RegExp regex = RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("please enter valid password min. 6 character");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _passcontroller.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Text(
                  _passwordError,
                  style: const TextStyle(color: Colors.red),
                ),
                SizedBox(height: size.height * 0.05),
                _isupload
                    ? const CircularProgressIndicator()
                    : Container(
                        alignment: Alignment.centerRight,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              visible = true;
                              _isupload = true;
                            });
                            signIn(_emailcontroller.text, _passcontroller.text);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50.0,
                            width: size.width * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80.0),
                                gradient: const LinearGradient(colors: [
                                  Color.fromARGB(255, 255, 136, 34),
                                  Color.fromARGB(255, 255, 177, 41)
                                ])),
                            padding: const EdgeInsets.all(0),
                            child: const Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const addstu(),
                          ));
                    },
                    child: const Text("New User")),
              ],
            ),
          ),
        ),
      
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const mobprof()),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _emailError = 'No user found for that email.';
            _passwordError = '';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _emailError = '';
            _passwordError = 'Wrong password provided for that user.';
          });
        }
      }
    }
    setState(() {
      _isupload = false;
    });
  }
}
