import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:verimadenciligi/auth/auth_check.dart';
import 'package:verimadenciligi/pages/error_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? hasInternet;
  bool isLoading = true;
  var errorMsg2 =
      "İnternet bağlantınız bulunmuyor.Lütfen önce internet bağlantınızın olduğundan emin olunuz!";

  Future<bool> isAppInstalled() {
    return DeviceApps.getInstalledApplications().then((value) => value.any(
        (element) =>
            element.packageName ==
            'com.google.android.apps.fitness')); // Your app package id to check.
  }

  Future<void> checkInternet() async {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet2 = status == InternetConnectionStatus.connected;
      setState(() {
        hasInternet = hasInternet2;
      });
    });
  }

  void check() async {
    await checkInternet();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var msg = "Google Fit Uygulamasının Yüklü Olmadığı Tespit Edildi!";
    return isLoading || hasInternet == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : hasInternet == false
            ? ErrorPage(errorMsg: errorMsg2, isAppController: false)
            : AnimatedSplashScreen(
                splash: Lottie.asset("asset/splashVeri.json"),
                backgroundColor: Colors.white,
                splashIconSize: 250,
                duration: 3000,
                splashTransition: SplashTransition.sizeTransition,
                pageTransitionType: PageTransitionType.leftToRightWithFade,
                animationDuration: const Duration(seconds: 0),
                nextScreen: FutureBuilder<bool>(
                    future: isAppInstalled(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData && snapshot.data!) {
                        // App is installed
                        return AuthCheck();
                      } else {
                        // App is not installed
                        return ErrorPage(
                          errorMsg: msg,
                          isAppController: true,
                        );
                      }
                    }));
  }
}
