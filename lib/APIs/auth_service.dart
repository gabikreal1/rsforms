import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: gAuth.idToken,
        accessToken: gAuth.accessToken,
      );
      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  signUserInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return "success";
  }
}
