import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reviews_slider/reviews_slider.dart';
import 'package:verimadenciligi/model/sorularModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var valueFirst = null;
  bool isLoading = true;
  Map? mapsSoru;
  List<SoruDatum>? listData;
  SorularModel? sorularModel;

  Future<void> getJson() async {
    final jsonString = await rootBundle.loadString('asset/jsonData/soru.json');
    sorularModel = sorularModelFromJson(jsonString);
    listData = sorularModel!.soruData;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rating = 0;
    var size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.blueGrey.shade900,
            appBar: AppBar(
              title: Text("Veri Madenciliği"),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(child: buildQuestion(0,size)),
                  //buildQuestion(1,size),
                ],
              ),
            ));
  }

  Row buildQuestion(int indexData ,Size size) {
  double rating=0;
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
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  listData![indexData].soru.toString(),
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            SizedBox(
                width: size.width-30,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text("0",style: TextStyle(fontSize: 20,color: Colors.black),),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right:20.0),
                          child: const Text("10",style: TextStyle(fontSize: 20,color: Colors.black),),
                        ),
                      ],
                    ),
                    StatefulBuilder(
                      builder: (context, state) {
                        return Slider(
                            value: rating,
                            divisions: listData![indexData].cevaplar.length,
                            max: listData![indexData].cevaplar.length.toDouble(),
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
                ))
          ],
        ),
      ],
    );
  }
}
