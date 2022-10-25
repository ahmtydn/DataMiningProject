import 'package:flutter/material.dart';
import 'package:verimadenciligi/model/sorularModel.dart';

class QuestionPage extends StatefulWidget {
  List<SoruDatum> listData;

  QuestionPage({required this.listData});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double rating = 0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  widget.listData[0].soru.toString(),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            SizedBox(
                width: size.width-20,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("0",style: TextStyle(fontSize: 20,color: Colors.white),),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0),
                          child: const Text("10",style: TextStyle(fontSize: 20,color: Colors.white),),
                        ),
                      ],
                    ),
                    StatefulBuilder(
                      builder: (context, state) {
                        return Slider(
                            value: rating,
                            divisions: widget.listData[0].cevaplar.length,
                            max: widget.listData[0].cevaplar.length.toDouble(),
                            label: rating.round().toString(),
                            onChanged: (newValue) {
                              state(() {
                                rating = newValue;
                                print(newValue);
                              });
                            });
                      },
                    ),
                  ],
                )) /*SizedBox(
              height: 300,
              width: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: listData![indexData].cevaplar.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print(listData![indexData].cevaplar[index].cevap);
                    },
                    child: Card(
                      color: Colors.primaries[index % 10],
                      child: Center(
                          child: Text('${listData![indexData].cevaplar[index].cevap}')),
                    ),
                  );
                },
              ),
            ),*/
          ],
        ),
      ],
    );
  }
}
