import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:rev_fb_app/extensions.dart';
import 'package:rev_fb_app/helpers/firestore_helper.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController psw = TextEditingController();

  void navigate(BuildContext context) {
    FireStoreHelper.instance.addCurrentUser().then(
          (value) => Navigator.pushReplacementNamed(context, 'home_page'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: email,
              ),
              TextField(
                controller: psw,
              ),
              5.hm(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                            email: email.text,
                            password: psw.text,
                          )
                          .then(
                            (value) => Logger().i("REGISTERED"),
                          )
                          .onError(
                            (error, stackTrace) => Logger().e("ERROR: $error"),
                          );
                    },
                    child: const Text("REGISTER"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                            email: email.text,
                            password: psw.text,
                          )
                          .then(
                            (value) => navigate(context),
                          )
                          .onError(
                            (error, stackTrace) => Logger().e("ERROR: $error"),
                          );
                    },
                    child: const Text("SIGN IN"),
                  ),
                ],
              ),
              5.hm(context),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signInAnonymously().then((value) {
                    Logger()
                        .i("LOG IN: ${FirebaseAuth.instance.currentUser?.uid}");
                    navigate(context);
                  }).onError(
                    (error, stackTrace) {
                      Logger().e("ERROR: $error");
                    },
                  );
                },
                child: const Text("GUEST"),
              ),
              5.hm(context),
              ElevatedButton(
                onPressed: () async {
                  // Trigger the authentication flow
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser?.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Logger()
                        .i("LOG IN: ${FirebaseAuth.instance.currentUser?.uid}");
                    navigate(context);
                  }).onError(
                    (error, stackTrace) {
                      Logger().e("ERROR: $error");
                    },
                  );
                },
                child: const Text("Google"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
