import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verimadenciligi/auth/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("isLogin", true);
  }

  @override
  void initState() {
    saveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[600],
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Veri Madenciliği"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(130),
            ),
          ),
          backgroundColor: Colors.blueGrey.shade900,

        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    var services = AuthServices();
                    services.logout();
                    SystemNavigator.pop();
                  },
                  child: Text("Çıkış")),
              ElevatedButton(
                  onPressed: () async {
                    var sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.remove("isLogin");
                  },
                  child: Text("Sil Shared")),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
                child: Text(
              "Veriler Kaydedildi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w400),
            )),
          ],
        ));
  }
}
