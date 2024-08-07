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
          itemCount: mutable.myFriends.length,
          itemBuilder: (c, i) => ListTile(
            leading: CircleAvatar(
              foregroundImage: NetworkImage(
                mutable.myFriends[i].photoUrl,
              ),
            ),
            title: Text(mutable.myFriends[i].displayName),
            subtitle: Text(mutable.myFriends[i].email),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add Friend !!"),
              content: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: mutable.allUsers
                        .where((element) =>
                            element.uid !=
                            (FirebaseAuth.instance.currentUser?.uid ?? ""))
                        .map(
                          (e) => ListTile(
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(e.photoUrl),
                            ),
                            title: Text(e.displayName),
                            trailing: IconButton(
                              onPressed: () {
                                immutable
                                    .addFriend(friend: e)
                                    .then((value) => Navigator.pop(context));
                              },
                              icon: const Icon(Icons.person_add_alt),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {},
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
