import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  Stream<User?> get authStateChange => _auth.authStateChanges();
late User user;
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email,
          password: password
      );
    } on FirebaseAuthException catch (e) {

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error Occured'),
            content: Text(e.code.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          ),
        );


    }

  }




  //  SignIn the user Google
  Future<void> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;


    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (cxt) => AlertDialog(
          title: const Text('Error Occurred'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(cxt).pop();
                },
                child: const Text("OK"))
          ],
        ),
      );
    }
  }


  Future<void> signOut() async {

    await googleSignIn.signOut();
    await  FirebaseAuth.instance.signOut();
   // await _auth.signOut();
  }
}
