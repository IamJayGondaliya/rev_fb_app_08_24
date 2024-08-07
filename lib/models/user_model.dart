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
