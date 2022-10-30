import 'package:flutter/material.dart';

class AnswerPage extends StatelessWidget {
  String answerText;
  AnswerPage({required this.answerText});


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 50,
      height: size.height / 15,
      child: Container(
        decoration:  BoxDecoration(
            color: Colors.white ,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
                Text(answerText,style:const TextStyle(
                color: Colors.black, fontSize: 27, fontWeight: FontWeight.w400),),
              ],
        ),
      ),
    );
  }
}
