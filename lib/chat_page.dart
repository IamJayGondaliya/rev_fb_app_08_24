import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rev_fb_app/extensions.dart';
import 'package:rev_fb_app/helpers/firestore_helper.dart';
import 'package:rev_fb_app/models/chat_model.dart';
import 'package:rev_fb_app/models/user_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FbUserModel friend =
        ModalRoute.of(context)!.settings.arguments as FbUserModel;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(friend.photoUrl),
            ),
            20.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.displayName),
                Text(friend.email),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireStoreHelper.instance.getMsg(friend: friend),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    List<ChatModel> allChats = snapShot.data!.docs
                        .map(
                          (e) => ChatModel.fromJson(
                            e.data(),
                          ),
                        )
                        .toList();

                    return ListView.builder(
                      itemCount: allChats.length,
                      itemBuilder: (c, i) => Text(allChats[i].msg),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (val) {
                      FireStoreHelper.instance
                          .sendMsg(
                            chat: ChatModel.fromJson({
                              "msg": msgController.text,
                              "time": DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString(),
                              "status": "unseen",
                              "type": "sent",
                            }),
                            friend: friend,
                          )
                          .then(
                            (value) => msgController.clear(),
                          );
                    },
                    controller: msgController,
                    decoration: InputDecoration(
                      hintText: "Enter message here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    FireStoreHelper.instance
                        .sendMsg(
                          chat: ChatModel.fromJson({
                            "msg": msgController.text,
                            "time": DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
                            "status": "unseen",
                            "type": "sent",
                          }),
                          friend: friend,
                        )
                        .then(
                          (value) => msgController.clear(),
                        );
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
