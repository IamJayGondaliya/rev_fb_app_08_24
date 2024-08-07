import 'package:flutter/material.dart';
import 'package:rev_fb_app/helpers/firestore_helper.dart';
import 'package:rev_fb_app/models/user_model.dart';

class UserController extends ChangeNotifier {
  List<UserModel> users = [];
  List<FbUserModel> allUsers = [];
  List<FbUserModel> myFriends = [];

  UserController() {
    init();
  }

  Future<void> init() async {
    allUsers = await FireStoreHelper.instance.getAllUsers();
    myFriends = await FireStoreHelper.instance.getMyFriends();
    notifyListeners();
  }

  Future<void> addFriend({required FbUserModel friend}) async {
    await FireStoreHelper.instance.addFriend(friend: friend);
    await init();
    notifyListeners();
  }

  Future<void> addUser({required UserModel userModel}) async {
    await FireStoreHelper.instance.addUser(userModel: userModel);
    await init();
    notifyListeners();
  }

  Future<void> editUser({required UserModel userModel}) async {
    await FireStoreHelper.instance.editUser(userModel: userModel);
    await init();
    notifyListeners();
  }

  Future<void> deleteUser({required UserModel userModel}) async {
    await FireStoreHelper.instance.deleteUser(userModel: userModel);
    await init();
    notifyListeners();
  }
}
