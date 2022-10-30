import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  String gender = "";
  int age = 0;

  final googleSignIn = GoogleSignIn(scopes: [   "https://www.googleapis.com/auth/user.gender.read",
    "https://www.googleapis.com/auth/user.birthday.read"
  ]);

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;
  Future<void> getGender() async {
    final r = await http.get(
      Uri.parse(
          "https://people.googleapis.com/v1/people/me?personFields=genders&key="),
      headers: await user.authHeaders,
    );
    final response = json.decode(r.body);
    var gen = response["genders"][0]["formattedValue"];
    if (gen == "Male") {
      gender = "Erkek";
    } else if (gen == "Female") {
      gender = "Kadın";
    }
  }

  Future<void> getBirthday() async {
    final r = await http.get(
      Uri.parse(
          "https://people.googleapis.com/v1/people/me?personFields=birthdays&key="),
      headers: await user.authHeaders,
    );
    final response = json.decode(r.body);
    print(response);
    int dateNowYear = DateTime.now().year;

    int year = response["birthdays"][0]["date"]["year"];
    age = dateNowYear - year;
  }

  void googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await getGender();
      await getBirthday();
      await saveData();
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("age", age.toString());
    sharedPreferences.setString("gender", gender.toString());
  }

  Future<void> logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
