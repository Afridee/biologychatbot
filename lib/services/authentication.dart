import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart' as client;
import 'package:package_info_plus/package_info_plus.dart';

class AuthService extends GetxController {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile'
    ],
  );
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  bool isSignedIn(){
    return firebaseAuth.currentUser!=null;
  }

  signIn() async{

    isLoading = true;
    update();

    GoogleSignInAccount? account = await _googleSignIn.signIn().catchError((onError){
      print(onError);
    });

    if(account!=null){
      final GoogleSignInAuthentication googleSignInAuthentication = await
      account!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken
      );

      await firebaseAuth.signInWithCredential(credential);

      if (kDebugMode) {
        print(account!.displayName);
        print(account!.photoUrl);
      }
    }

    isLoading = false;
    update();
  }

  signOut() async{
    isLoading = true;
    update();
   await  firebaseAuth.signOut();
    isLoading = false;
    update();
  }
}