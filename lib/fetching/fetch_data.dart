import 'package:flutter/cupertino.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verimadenciligi/provider/provider.dart';

class FetchData {
  /// Fetch steps from the health plugin and show them in the app.
  Future<int?> fetchStepData(BuildContext context) async {
    final provider = Provider.of<DataMiningProvider>(context,listen: false);
    int? steps;

    // get steps for today (i.e., since midnight)
    final yesterday = DateTime.now().subtract(Duration(days:1));
    final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
    final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

    if (provider.requested) {
      try {
        steps = (await provider.health.getTotalStepsInInterval(yesterdayStart, yesterdayEnd));
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }
      return steps;
    } else {
      print("Authorization not granted - error in authorization");
      return null;
    }
  }

  Future<double?> fetchHeight(BuildContext context) async {
    final provider = Provider.of<DataMiningProvider>(context,listen: false);
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday =  now.subtract(Duration(days: 3652));

    if (provider.requested) {
      try {
        // fetch health data
        List<HealthDataPoint> heightData =
            await provider.health.getHealthDataFromTypes(yesterday, now, [HealthDataType.HEIGHT]);
        var height = double.parse(heightData.last.value.toString());
        return height;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }

  Future<double?> fetchWeight(BuildContext context) async {
    final provider = Provider.of<DataMiningProvider>(context,listen: false);
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 3652));

    if (provider.requested) {
      try {
        // fetch health data
        List<HealthDataPoint> heightData =
            await provider.health.getHealthDataFromTypes(yesterday, now, [HealthDataType.WEIGHT]);
        var height = double.parse(heightData.last.value.toString());
        return height;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }
  Future<double?> fetchBodyIndex(BuildContext context) async {
    final provider = Provider.of<DataMiningProvider>(context,listen: false);
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 3652));

    if (provider.requested) {
      try {
        // fetch health data
        List<HealthDataPoint> bodyIndexData =
            await provider.health.getHealthDataFromTypes(yesterday, now, [HealthDataType.BODY_MASS_INDEX]);
        var body_index = double.parse(bodyIndexData.last.value.toString());

        return body_index;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }

  Future<double?> fetchEnergyBurned(BuildContext context) async {
    final provider = Provider.of<DataMiningProvider>(context,listen: false);
    // get data within the last 24 hours
    final yesterday = DateTime.now().subtract(Duration(days:1));
    final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
    final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

    if (provider.requested) {
      try {
        // fetch health data
        List<HealthDataPoint> EnergyBurnedData =
            await provider.health.getHealthDataFromTypes(yesterdayStart, yesterdayEnd, [HealthDataType.ACTIVE_ENERGY_BURNED]);
        var energy=0.0;
        for(var i in EnergyBurnedData)
          {
             energy=energy+double.parse(i.value.toString());
          }
        return energy;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }


  Future<String?> ageReadSharedPreferences() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("age");
  }

  Future<String?> genderReadSharedPreferences() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("gender");
  }

}
