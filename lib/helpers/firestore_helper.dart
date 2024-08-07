import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rev_fb_app/models/user_model.dart';

class FireStoreHelper {
  FireStoreHelper._pc();
  static final FireStoreHelper instance = FireStoreHelper._pc();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List<UserModel>> getData() async {
    List<UserModel> users = [];

    QuerySnapshot snapshot = await fireStore.collection("allUsers").get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;

    users = docs
        .map(
          (e) => UserModel.fromMap(e.data() as Map),
        )
        .toList();

    return users;
  }

  Future<String> getId() async {
    DocumentSnapshot snapshot =
        await fireStore.collection('idCounter').doc('counter').get();
    Map data = snapshot.data() as Map;

    return data['last_id'];
  }

  Future<void> increaseId() async {
    int id = int.parse(await getId());
    id++;
    await fireStore.collection('idCounter').doc('counter').update({
      'last_id': id.toString(),
    });
  }

  Future<void> addUser({required UserModel userModel}) async {
    userModel.id = await getId();

    await fireStore
        .collection('allUsers')
        .doc(userModel.id)
        .set(userModel.toMap);

    await increaseId();
  }

  Future<void> editUser({required UserModel userModel}) async {
    await fireStore
        .collection('allUsers')
        .doc(userModel.id)
        .update(userModel.toMap);
  }

  Future<void> deleteUser({required UserModel userModel}) async {
    await fireStore.collection('allUsers').doc(userModel.id).delete();
  }
}
