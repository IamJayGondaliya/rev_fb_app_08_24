import 'package:flutter/material.dart';
import 'package:rev_fb_app/helpers/firestore_helper.dart';
import 'package:rev_fb_app/models/user_model.dart';

class UserController extends ChangeNotifier {
  List<UserModel> users = [];

  UserController() {
    init();
  }

  Future<void> init() async {
    users = await FireStoreHelper.instance.getData();
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
