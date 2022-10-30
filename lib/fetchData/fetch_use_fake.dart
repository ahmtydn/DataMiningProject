import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:verimadenciligi/pages/fetching_data_page.dart';

class FetchUseFake extends StatefulWidget {
  const FetchUseFake({Key? key}) : super(key: key);

  @override
  State<FetchUseFake> createState() => _FetchUseFakeState();
}

class _FetchUseFakeState extends State<FetchUseFake> {

  bool isLoading=true;

  Future<void> getUsageStats() async {
    try {

      final yesterday = DateTime.now().subtract(Duration(days:1));
      final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
      final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

   await AppUsage.getAppUsage(yesterdayStart, yesterdayEnd);
      setState(() {
        isLoading=false;
      });


    } on AppUsageException catch (exception) {
      print(exception);
    }
  }
  @override
  void initState() {
    getUsageStats();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator(),):FetchingDataPage();
  }
}
