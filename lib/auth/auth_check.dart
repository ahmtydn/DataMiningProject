import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verimadenciligi/auth/login_screen.dart';
import 'package:verimadenciligi/fetching/fetch_use_fake.dart';

class AuthCheck extends StatefulWidget {
  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return FetchUseFake();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Bir hata oluştu"),
              );
            } else {
              return LoginScreen();
            }
          },
        ));
  }
}
