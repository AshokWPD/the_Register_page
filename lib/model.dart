
class UserModel {
  String? email;
  String? gender;
  String? uid;
  String? dob;
  String? name;
  String? mobile;
  String? password;
  String? lstname;

// receiving data
  UserModel(
      {this.uid,
      this.email,
      this.gender,
      this.dob,
      this.name,
      this.mobile,
      this.password,
      this.lstname});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      gender: map['gender'],
      dob: map['dob'],
      name: map['name'],
      mobile: map['mobile'],
      password: map['password'],
            lstname: map['lstname'],

    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'gender': gender,
      'dob': dob,
      'name': name,
      'mobile': mobile,
      'password': password,
      'lstname': lstname,


    };
  }

  // Convert UserModel to Firestore document data
  Map<String, dynamic> toDocument() {
    return {
      'email': email,
      'gender': gender,
      'dob': dob,
      'name': name,
      'mobile': mobile,
      'password': password,
            'lstname': lstname,

    };
  }
}

class Modal {
  String link, name;
  Modal(this.link, this.name);
}


