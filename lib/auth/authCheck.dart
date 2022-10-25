import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:verimadenciligi/auth/login_screen.dart';
import 'package:verimadenciligi/pages/HomePage.dart';
import 'package:verimadenciligi/pages/errorPage.dart';

class AuthCheck extends StatefulWidget {

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  var errorMsg2="İnternet bağlantınız bulunmuyor.Lütfen önce internet bağlantınızın olduğundan emin olunuz!";
  bool hasInternet=false;
  bool isLoading=true;

  void check() async {
    await checkInternet();
  }

  Future<void>checkInternet() async {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() => this.hasInternet = hasInternet);
    });
    isLoading=false;
  }
  @override
  void initState() {
    check();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoading?Center(child: CircularProgressIndicator(),):hasInternet==false?ErrorPage(errorMsg: errorMsg2, isAppController: false):StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasData){
            return HomePage();
          }
          else if(snapshot.hasError){
            return Center(child: Text("Bir hata oluştu"),);
          }
          else{
            return LoginScreen();
          }
        },
      )
    );
}}
