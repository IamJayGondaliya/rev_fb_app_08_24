import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rev_fb_app/models/chat_model.dart';
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

  //==========================================================================
  //===============================CHAT METHODS===============================
  //==========================================================================

  Future<void> addCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    await fireStore.collection('allUsers').doc(user!.uid).set({
      'uid': user.uid,
      'displayName': user.displayName ?? "NOT ADDED",
      'photoUrl': user.photoURL ??
          "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
      'email': user.email ?? "NOT ADDED",
      'phoneNumber': user.phoneNumber ?? "NOT ADDED",
    });
  }

  Future<List<FbUserModel>> getAllUsers() async {
    QuerySnapshot snapshot = await fireStore.collection('allUsers').get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    return docs.map((e) => FbUserModel.fromMap(e.data() as Map)).toList();
  }

  Future<void> addFriend({required FbUserModel friend}) async {
    await fireStore
        .collection('allUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .doc(friend.uid)
        .set(friend.toMap);

    await fireStore
        .collection('allUsers')
        .doc(friend.uid)
        .collection('friends')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'displayName':
          FirebaseAuth.instance.currentUser!.displayName ?? "NOT ADDED",
      'photoUrl': FirebaseAuth.instance.currentUser!.photoURL ??
          "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg",
      'email': FirebaseAuth.instance.currentUser!.email ?? "NOT ADDED",
      'phoneNumber':
          FirebaseAuth.instance.currentUser!.phoneNumber ?? "NOT ADDED",
    });
  }

  Future<List<FbUserModel>> getMyFriends() async {
    QuerySnapshot snapshot = await fireStore
        .collection('allUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('friends')
        .get();
    return snapshot.docs
        .map((e) => FbUserModel.fromMap(e.data() as Map))
        .toList();
  }

  Future<void> sendMsg({
    required ChatModel chat,
    required FbUserModel friend,
  }) async {
    User user = FirebaseAuth.instance.currentUser!;

    await fireStore
        .collection('allUsers')
        .doc(user.uid)
        .collection('friends')
        .doc(friend.uid)
        .collection('chats')
        .doc(chat.time)
        .set(chat.toJson);

    Map<String, dynamic> data = chat.toJson;
    data['type'] = "received";

    await fireStore
        .collection('allUsers')
        .doc(friend.uid)
        .collection('friends')
        .doc(user.uid)
        .collection('chats')
        .doc(chat.time)
        .set(data);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMsg(
      {required FbUserModel friend}) {
    User user = FirebaseAuth.instance.currentUser!;
    return fireStore
        .collection('allUsers')
        .doc(user.uid)
        .collection('friends')
        .doc(friend.uid)
        .collection('chats')
        .snapshots();
  }
}
