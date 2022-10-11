import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class AuthImplementation{
// ignore: non_constant_identifier_names
Future<void>SignIn(String email, String password);
// ignore: non_constant_identifier_names
Future<String>SignUp(String email, String password);
Future<String>getCurrentUser();
Future<User>isSignedIn();
Future<void>signOut();
}


class Auth implements AuthImplementation{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  // sign in user
  // ignore: non_constant_identifier_names
  Future<void> SignIn(String email, String password) async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password:password);
  }
  //sign up user
  // ignore: non_constant_identifier_names
  Future<String>SignUp(String email, String password) async{
   await _firebaseAuth.createUserWithEmailAndPassword(email: email, password:password);
   User? user = _firebaseAuth.currentUser;
    return user!.uid;
  }
    //return auth user id
   Future<String>getCurrentUser() async{
    User? user =  _firebaseAuth.currentUser;
    return user!.uid;
  }
  //check if user auth is still valid
   Future<User>isSignedIn() async{
    User? user =  _firebaseAuth.currentUser;
    return user!;
  }

  Future<void>signOut() async{
    //check if user used facebook or google to login
    // bool isGoogle = await  _googleSignIn.isSignedIn();

    //  if(isGoogle){
    //    _googleSignIn.signOut();
    //  }
     
     //log user out
     _firebaseAuth.signOut();
  }

}