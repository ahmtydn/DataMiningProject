import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';
import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verimadenciligi/auth/google_sign_in.dart';
import 'package:verimadenciligi/model/data_model.dart';
import 'package:verimadenciligi/pages/fit_data.dart';

class HomePage extends StatefulWidget {

 final DataModel data;

  @override
  State<HomePage> createState() => _HomePageState();

 const HomePage({super.key, required this.data});
}

class _HomePageState extends State<HomePage> {
  Future<void> saveData() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setBool("isLogin", true);
  }

  StreamSubscription? sub;

  Future<void> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    sub = linkStream.listen((String? link) {
      // Parse the link and warn the user, if it is not correct
      if (link != null) {
        if (kDebugMode) {
          print("listener is working");
        }
        var uri = Uri.parse(link);
        if (uri.queryParameters['id'] != null) {
          if (kDebugMode) {
            print(uri.queryParameters['id'].toString());
          }
        }
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  @override
  void initState() {
    saveData();
    super.initState();
    initUniLinks();
  }

  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: "https://www.ahmetaydin.dev",
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.amber[600],
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.blueGrey.shade900,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                    right: -120,
                    top: -50,
                    child: Container(
                      width: size.width - 10,
                      height: size.height / 2,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    )),
                Positioned(
                  right: 10,
                  top: 40,
                  child: Row(
                    children: [
                      SizedBox(
                          height: 30,
                          child: Image.asset("asset/images/database2.png")),
                      const Text(
                        "Veri Madenciliği",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    top: 130,
                    left: 20,
                    right: 30,
                    child: SizedBox(
                      height: size.height / 2.3,
                      width: size.width - 50,
                      child: const AvatarView(
                        radius: 350,
                        avatarType: AvatarType.CIRCLE,
                        imagePath: "asset/images/avatar2.jpg",
                      ),
                    )),
                Positioned(
                    top: 470,
                    child: SizedBox(
                        width: size.width,
                        child: Image.asset(
                          "asset/images/player2.png",
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 510,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            height: 30,
                            child: Image.asset(
                              "asset/images/repaet.png",
                              color: Colors.white,
                            )),
                        Column(
                          children: const [
                            Text(
                              "Ahmet Aydın",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Mobil Geliştirici",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 30,
                            child: Image.asset(
                              "asset/images/noaudio.png",
                              color: Colors.white,
                            )),
                      ],
                    )),
                Positioned(
                    top: 660,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(65),
                          )),
                      width: size.width,
                      height: size.height,
                    )),
                Positioned(
                    bottom: 105,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Veriler Kaydedildi.",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, color: Colors.amber),
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          openBrowserTab();
                        },
                        icon: const Icon(Icons.phone),
                        color: Colors.blueGrey.shade900,
                        iconSize: 50,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> GoogleFitDataView(data: widget.data,)));
                        },
                        icon: const Icon(Icons.data_usage_rounded),
                        color: Colors.blueGrey.shade900,
                        iconSize: 50,
                      ),
                      IconButton(
                        onPressed: () {
                          var services = AuthServices();
                          services.logout(context);
                        },
                        icon: const Icon(Icons.exit_to_app),
                        color: Colors.blueGrey.shade900,
                        iconSize: 50,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
