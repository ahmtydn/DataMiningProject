import 'package:flutter/material.dart';

class QuestionPage extends StatefulWidget {
  String questionText;

  QuestionPage({required this.questionText});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 60,
      height: size.height / 3.5,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
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
             height: 60,
           )
           /* Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Image.asset("asset/images/clip.png"),
                  Spacer(),
                 // Image.asset("asset/images/clip.png"),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
