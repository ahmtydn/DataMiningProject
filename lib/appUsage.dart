import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';

class AppUsageClass extends StatefulWidget {
  const AppUsageClass({Key? key}) : super(key: key);

  @override
  State<AppUsageClass> createState() => _AppUsageState();
}

class _AppUsageState extends State<AppUsageClass> {

  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime now = new DateTime.now();
      DateTime startDate =  DateTime(now.year, now.month, now.day);
      print("Şimdi: $now");
      print("geçmiş: $startDate");
      List<AppUsageInfo> infoList = await AppUsage.getAppUsage(startDate, now);
      setState(() {
        _infos = infoList;
      });

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: const Text('App Usage'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            itemCount: _infos.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_infos[index].appName),
                  trailing: Text(_infos[index].usage.toString()));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: Icon(Icons.file_download)),

    );
  }
}
