import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[600],
        appBar: AppBar(
          centerTitle: true,
          title: Text("Veri Madenciliği"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(130),
            ),
          ),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        body: Text("Veriler Kaydedildi"));
  }
}
