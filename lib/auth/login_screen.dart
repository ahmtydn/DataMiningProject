import 'package:flutter/material.dart';
import 'package:verimadenciligi/auth/google_sign_in.dart';
import 'package:verimadenciligi/pages/login_screen_helper.dart';
import 'package:verimadenciligi/pages/question_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
    var size = MediaQuery.of(context).size;
    double heightAppBar = appBar.preferredSize.height;
    return isLoading
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Scaffold(
            backgroundColor: Colors.amber[600],
            appBar: appBar,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber[600],
                      ),
                      width: size.width,
                      height: size.height - heightAppBar - 24,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                              top: 590,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade900,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(70),
                                    )),
                                width: size.width,
                                height: size.height,
                              )),
                          Positioned(
                            top: 25,
                            right: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LoginHelper(
                                    height: size.height / 3,
                                    color: Colors.tealAccent,
                                    questionText:
                                        "Merhaba!\nUygulamayı kullanarak bana destek olduğun için teşekkür ederim :)"),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 310,
                            left: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LoginHelper(
                                    height: size.height / 3,
                                    color: Colors.lightGreenAccent,
                                    questionText:
                                        "İletişim için:\n\nwww.ahmetaydin.dev"),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 608,
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
                                        width: size.width / 2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.indigo,
                                              spreadRadius: 1,
                                              blurRadius: 8,
                                              offset: Offset(-4, -4),
                                            ), // BoxShadow
                                            BoxShadow(
                                              color: Colors.amber[600]!,
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: Offset(4, 4),
                                            ),
                                          ],
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
                                              " ile Giriş",
                                              style: TextStyle(
                                                  fontSize: 27,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
