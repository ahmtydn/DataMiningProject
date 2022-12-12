import 'package:flutter/material.dart';
import 'package:verimadenciligi/model/data_model.dart';

class GoogleFitDataView extends StatelessWidget {
  const GoogleFitDataView({Key? key, required this.data}) : super(key: key);
  final DataModel data;

  @override
  Widget build(BuildContext context) {
    TextStyle style=const TextStyle(fontSize:25,);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Google Data View"),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Age : ${data.age}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Height: ${data.height}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Body Mass Index : ${data.bodyMassIndex.substring(0,5)}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Energy Burned : ${data.energyBurned.substring(0,8)}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Weight : ${data.weight}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Steps : ${data.stepsTotal}",style:style),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Gender : ${data.gender}",style:style),
                ],
              ),
            ),
          ],
        ));
  }
}
