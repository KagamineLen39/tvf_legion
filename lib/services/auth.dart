import 'package:firebase_auth/firebase_auth.dart';
import 'package:tvf_legion/modal/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future emailSignIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    }catch (e) {
      print("Unable to find user");
      print(e.toString());
      return null;
    }
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password,

      );

      FirebaseUser firebaseUser = result.user;

      try{
        firebaseUser.sendEmailVerification();
        return firebaseUser.uid;
      }catch(e){
        print("Error occur sending verification email");
        print(e.toString());
      }

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      print("Email Not existing");
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
