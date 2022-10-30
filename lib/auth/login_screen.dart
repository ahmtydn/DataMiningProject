import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:verimadenciligi/auth/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  openBrowserTab() async {
    await FlutterWebBrowser.openWebPage(
      url: "https://www.ahmetaydin.dev",
    );
  }

  AppBar appBar = AppBar(
    centerTitle: true,
    title: const Text("Veri Madenciliği"),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(130),
      ),
    ),
    backgroundColor: Colors.blueGrey.shade900,
  );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double heightAppBar = appBar.preferredSize.height;
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Scaffold(
            appBar: appBar,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      width: size.width,
                      height: size.height - heightAppBar - 24,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                              top: 0,
                              bottom: 330,
                              child: Container(
                                width: size.width,
                                height: size.height,
                                child:
                                    Image.asset("asset/images/loginback.png"),
                              )),
                          Positioned(
                              top: 370,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade900,
                                    borderRadius: BorderRadius.all(
                                      Radius.elliptical(800, 290),
                                    )),
                                width: size.width,
                                height: size.height,
                              )),
                          Positioned(
                            top: 380,
                            child: Container(
                              width: size.width - 50,
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Flexible(
                                        child: Text(
                                      "Merhaba",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25),
                                    )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Flexible(
                                        child: Center(
                                      child: Text(
                                        "Uygulamayı kullanarak bana destek olduğun için teşekkür ederim :)",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 19,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 550,
                            left: 3,
                            right: 25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isLoading = true;
                                          AuthServices().googleLogin();
                                        });
                                      },
                                      child: Container(
                                        height: size.height / 15,
                                        width: size.width / 1.3,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                                "asset/images/google.png"),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              "oogle ile",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(width: 15,),
                                            Text(
                                              "Giriş",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 560,
                            child: GestureDetector(
                              onTap: () {
                                openBrowserTab();
                              },
                              child: Container(
                                width: size.width - 50,
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 50.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Flexible(
                                          child: Center(
                                        child: Text(
                                          "İletişim için tıkla",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 19,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
