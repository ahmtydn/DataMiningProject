import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart'as http;

class GoogleSignInProvider extends ChangeNotifier{

  String gender="";
  final googleSignIn=GoogleSignIn(scopes: [
        "https://www.googleapis.com/auth/user.gender.read"
  ]);
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user=>_user!;
  Future<void> getGender() async {
    final r = await http.get(Uri.parse("https://people.googleapis.com/v1/people/me?personFields=genders&key="),
      headers: await user.authHeaders,
    );
    final response = json.decode(r.body);
    gender=response["genders"][0]["formattedValue"];
  }


  Future googleLogin() async {
    try{
      final googleUser=await googleSignIn.signIn();
      if(googleUser==null)return;
      _user=googleUser;
      final googleAuth=await googleUser.authentication;

      final credential=GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await getGender();
      await FirebaseAuth.instance.signInWithCredential(credential);

    }catch (e){
      print(e.toString());
    }
    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}