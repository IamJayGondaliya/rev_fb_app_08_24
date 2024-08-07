class UserModel {
  String id, name, age;

  UserModel(this.id, this.name, this.age);

  factory UserModel.fromMap(Map data) => UserModel(
        data['id'],
        data['name'],
        data['age'],
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        'age': age,
      };
}

class FbUserModel {
  String uid, displayName, photoUrl, email, phoneNumber;

  FbUserModel(
      this.uid, this.displayName, this.photoUrl, this.email, this.phoneNumber);

  factory FbUserModel.fromMap(Map data) => FbUserModel(
        data['uid'],
        data['displayName'],
        data['photoUrl'],
        data['email'],
        data['phoneNumber'],
      );

  Map<String, dynamic> get toMap => {
        'uid': uid,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'email': email,
        'phoneNumber': phoneNumber,
      };
}
