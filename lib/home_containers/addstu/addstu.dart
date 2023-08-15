import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../login/mob_log.dart';
import '../../model.dart';

class addstu extends StatefulWidget {
  const addstu({super.key});

  static String routename = 'addstu';

  @override
  State<addstu> createState() => _addstuState();
}

class _addstuState extends State<addstu> {
  _addstuState();

  

int calculateAgeofperson(String dob){

final dobdate = DateFormat('yyyy-MM-dd').parse(dob);
DateTime now= DateTime.now();

final age = now.year-dobdate.year-((now.month>dobdate.month|| (now.month==dobdate.month && now.day>= dobdate.day))?0:1);

return age;

}


  final TextEditingController confirmpassController = TextEditingController();

  var dob ;
// depart ment
 

  final TextEditingController emailController = TextEditingController();
  final TextEditingController regnumcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
    final TextEditingController lastnamecontroller = TextEditingController();
    final TextEditingController gendercontroller = TextEditingController();
    final TextEditingController dobcontroller = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  var gender ;
  // File? file;



  //role
  List roleOptions = ['Male', 'Female', 'Others'];

  bool showProgress = false;
  bool visible = false;
  bool _isupload = false;

  int _age=0;

  void _calculateAge() {
    String dob = dobcontroller.text;
    if (dob.isNotEmpty) {
      setState(() {
        _age = calculateAgeofperson(dob);
      });
    }
  }

  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  bool _isObscure = true;
  //  final bool _isObscure2 = true;

// back end


 void signUp(
    String email,
    String password,
    String gender,
    String dob,
    String name,
    String lastname,
    String mobile,
  ) async {
    setState(() {
      _isupload = true;
    });

if(await checkMobileExists(regnumcontroller.text)){
showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Mobile number alredy exist'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => const moblog(),));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
}else{
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(email, gender, dob, name, password, mobile,lastname)
              })
          // ignore: body_might_complete_normally_catch_error
          .catchError((e) {
            if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('User with this email already exists.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
      _isupload = false;
    });
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
          });
    }
}
  
    setState(() {
      _isupload = false;
    });
  }

  postDetailsToFirestore(String email, String gender, String dob, String name,
      String password, String mobile,String lastname) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();
    userModel.email = email;
    userModel.uid = user!.uid;
    userModel.gender = gender;
    userModel.dob = dob;
    userModel.name = name;
    userModel.lstname=lastname;
    userModel.mobile = mobile;
    userModel.password = password;
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    setState(() {
      _isupload = false;
    });
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('User created successfully'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => const moblog(),));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
 

  
  
  Future<bool> checkMobileExists(String mobile) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection("users")
        .where('mobile', isEqualTo: mobile)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body:  Form(
              key: _formkey,
              child: ListView(children: [
                const SizedBox(
                  height: 100,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        "Create User 👇",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2661FA),
                            fontSize: 36),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Container(
                        padding: const EdgeInsets.only(left: 17),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 222, 222, 222)
                          
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: namecontroller,
                          decoration:
                              const InputDecoration(enabled: true, labelText: "First Name",border: InputBorder.none),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "First Name cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {},
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                   
                     Container(
padding: const EdgeInsets.only(left: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 222, 222, 222)
                        
                      ),                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: lastnamecontroller,
                        decoration:
                            const InputDecoration(enabled: true, labelText: "Last Name",border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Last Name cannot be empty";
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.name,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.only(left: 37,right: 37),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.only(left: 17,right: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 222, 222, 222)
                          
                        ),
                        child: DropdownButton(items: roleOptions.map((valueItem){
                          return DropdownMenuItem(value: valueItem,
                            child: Text(valueItem));
                        }).toList(),
                        
                         onChanged: (newValue){
                          setState(() {
                            
                            gender=newValue;
                          });
                        },value: gender,hint: const Text("Gender"),isExpanded: true,icon: const Icon(Icons.arrow_drop_down_circle_outlined,),iconSize: 25,),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),


                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 222, 222, 222)
                        
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: regnumcontroller,
                        decoration: const InputDecoration(
                            enabled: true, labelText: "Phone Number",border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Phone Number ";
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                                        SizedBox(height: size.height * 0.03),


                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 222, 222, 222)
                        
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(labelText: "Email",border: InputBorder.none),
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
                        onChanged: (value) {},
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 222, 222, 222)
                        
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                            labelText: "Password",border: InputBorder.none),
                        obscureText: _isObscure,
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
                        onChanged: (value) {},
                      ),
                    ),


                    SizedBox(height: size.height * 0.05),

                    Container(
                      padding: const EdgeInsets.only(left: 17),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 222, 222, 222)
                        
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: dobcontroller,
                        decoration: const InputDecoration(
                            enabled: true, labelText: "Date of Birth",border: InputBorder.none),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Date of birth ";
                          }
                          return null;
                        },
                        onChanged: (value) {},
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          onTap: _calculateAge,
                          child:  Container(
                            height: 25,
                            width: 100,
                            decoration:  BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child:  const Center(child: Text("Calculate",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),)),
                          ),
                        ),
                        const Spacer(),
                         Text("Age :  $_age",style: const TextStyle(fontSize: 15,color: Colors.black),),
                        const SizedBox(
                          width: 35,
                        )
                      ],
                    ),
                    
                    // Container(
                    //   // height: 30,
                    //   // width: 150,
                    //   alignment: Alignment.center,
                    //   margin: const EdgeInsets.symmetric(horizontal: 40),
                    //   child: DropdownButton<String>(
                    //     hint: const Text(
                    //       'Gender',
                    //       selectionColor: Colors.black,
                    //     ),
                    //     dropdownColor: Colors.white,
                    //     isDense: true,
                    //     isExpanded: false,
                    //     iconEnabledColor: Colors.black,
                    //     focusColor: Colors.blue,
                    //     items: roleOptions.map((String dropDownStringItem) {
                    //       return DropdownMenuItem<String>(
                    //         value: dropDownStringItem,
                    //         child: Center(
                    //           child: Text(
                    //             dropDownStringItem,
                    //             style: const TextStyle(
                    //               color: Colors.black,
                    //               fontSize: 20,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (newValueSelected) {
                    //       setState(() {
                    //         _currentRoleSelected = newValueSelected!;
                    //         gender = newValueSelected;
                    //       });
                    //     },
                    //     value: _currentRoleSelected,
                    //   ),
                    // ),
                    SizedBox(height: size.height * 0.05),
                    _isupload
                        ? const CircularProgressIndicator()
                        : Container(
                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  showProgress = true;
                                });
                                // if (showProgress = true) {
                                //   Center(child: CircularProgressIndicator());
                                // }
                                signUp(
                                    emailController.text,
                                    passwordController.text,
                                    gender,
                                    dobcontroller.text,
                                    namecontroller.text,
                                    lastnamecontroller.text,
                                    regnumcontroller.text);
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
                                  "Create",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder:(context) =>const moblog(),));
                          }, child: const Text("Existing User"))

                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    //   child: GestureDetector(
                    //     onTap: () => {
                    //       Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()))
                    //     },
                    //     child: Text(
                    //       "Already Have an Account? Sign in",
                    //       style: TextStyle(
                    //         fontSize: 12,
                    //         fontWeight: FontWeight.bold,
                    //         color: Color(0xFF2661FA)
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ]),
            ),
          ),
        );
  }
}
