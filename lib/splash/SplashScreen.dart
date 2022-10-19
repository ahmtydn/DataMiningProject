import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:verimadenciligi/auth/authCheck.dart';
import 'package:verimadenciligi/pages/HomePage.dart';
import 'package:verimadenciligi/pages/errorPage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  Future<bool> isAppInstalled() {
    return DeviceApps.getInstalledApplications().then((value) =>
        value.any((element) => element.packageName == 'com.google.android.apps.fitness')); // Your app package id to check.
  }
  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
        splash: Lottie.asset("asset/splashVeri.json"),
        backgroundColor: Colors.white,
        splashIconSize: 250,
        duration: 3000,
        splashTransition: SplashTransition.sizeTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
        animationDuration: const Duration(seconds: 1),
        nextScreen:  FutureBuilder<bool>(
            future: isAppInstalled(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                // App is installed
                return AuthCheck();
              } else {
                // App is not installed
                return  ErrorPage();
              }
            }));
  }
}
