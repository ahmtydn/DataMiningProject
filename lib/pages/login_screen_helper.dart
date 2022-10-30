import 'package:flutter/material.dart';

class LoginHelper extends StatefulWidget {
  String questionText;
  Color color;
  final height;
  LoginHelper({required this.color,required this.questionText, this.height});

  @override
  State<LoginHelper> createState() => _LoginHelperState();
}

class _LoginHelperState extends State<LoginHelper> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 60,
      height: widget.height,
      child: Container(
        decoration:  BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Spacer(),
                  Image.asset("asset/images/clip.png"),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 35,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.questionText,
                      style:const TextStyle(
                          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
