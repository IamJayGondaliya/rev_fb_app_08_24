import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rev_fb_app/controllers/user_controller.dart';
import 'package:rev_fb_app/models/user_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserController mutable = Provider.of<UserController>(context);
    UserController immutable = Provider.of<UserController>(
      context,
      listen: false,
    );
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(
                  FirebaseAuth.instance.currentUser?.photoURL ??
                      "https://media.istockphoto.com/id/1327592506/vector/default-avatar-photo-placeholder-icon-grey-profile-picture-business-man.jpg?s=612x612&w=0&k=20&c=BpR0FVaEa5F24GIw7K8nMWiiGmbb8qmhfkpXcp1dhQg=",
                ),
              ),
              accountName: Text(
                  FirebaseAuth.instance.currentUser?.displayName ?? "Guest"),
              accountEmail: Text(
                  FirebaseAuth.instance.currentUser?.email ?? "guest-account"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.pushReplacementNamed(context, '/'),
                  );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: mutable.users.length,
          itemBuilder: (c, i) {
            UserModel user = mutable.users[i];

            return Card(
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Edit User !!"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  initialValue: user.id,
                                  onChanged: (val) => user.id = val,
                                ),
                                TextFormField(
                                  initialValue: user.name,
                                  onChanged: (val) => user.name = val,
                                ),
                                TextFormField(
                                  initialValue: user.age,
                                  onChanged: (val) => user.age = val,
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  immutable.editUser(userModel: user).then(
                                        (value) => Navigator.pop(context),
                                      );
                                },
                                child: const Text("UPDATE"),
                              ),
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icons.edit,
                      foregroundColor: Colors.blue,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        immutable.deleteUser(userModel: user);
                      },
                      icon: Icons.delete,
                      foregroundColor: Colors.red,
                    ),
                  ],
                ),
                child: ListTile(
                  onLongPress: () {},
                  leading: Text(user.id),
                  title: Text(user.name),
                  trailing: Text(user.age),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserModel user = UserModel("000", "DEMO", "00");

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add User !!"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (val) => user.name = val,
                  ),
                  TextField(
                    onChanged: (val) => user.age = val,
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    immutable.addUser(userModel: user).then(
                          (value) => Navigator.pop(context),
                        );
                  },
                  child: const Text("Add"),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
