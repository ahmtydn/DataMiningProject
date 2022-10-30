import 'package:flutter/services.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String errorMsg;
  final bool isAppController;

  ErrorPage({required this.errorMsg,required this.isAppController});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "asset/errorPage.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.10,
            left: MediaQuery.of(context).size.width * 0.065,
            right: MediaQuery.of(context).size.width * 0.065,
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 13),
                      blurRadius: 25,
                      color: Color(0xFF5666C2).withOpacity(0.17),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.errorMsg}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        )),
                    SizedBox(height: 20,),
                    widget.isAppController?GestureDetector(
                      onTap: () {
                        LaunchReview.launch(androidAppId: "com.google.android.apps.fitness");
                        SystemNavigator.pop();
                      },
                      child: Container(
                        height: size.height / 15,
                        width: size.width / 1.1,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue,
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(4, 4),
                            ), // BoxShadow
                            BoxShadow(
                              color: Colors.redAccent,
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(-4, -4),
                            )
                          ],
                        ),
                        child: Center(
                            child: Text("Yüklemek İçin Tıklayınız",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18))),
                      ),
                    ):Container()
                  ],
                )),
          )
        ],
      ),
    );
  }
}
