
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
class fetchData {
  HealthFactory health = HealthFactory();
  bool requested=false;

  Future<void> authorizationCheck() async {
    final types = [
      HealthDataType.HEIGHT,
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.BODY_MASS_INDEX,
      HealthDataType.ACTIVE_ENERGY_BURNED,
    ];
    // with coresponsing permissions
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];
    requested = await health.requestAuthorization(types, permissions: permissions);
    await Permission.activityRecognition.request();
    await Permission.location.request();

  }
  /// Fetch steps from the health plugin and show them in the app.
  Future<int?> fetchStepData() async {
    int? steps;
     await authorizationCheck();
    // get steps for today (i.e., since midnight)
    final yesterday = DateTime.now().subtract(Duration(days:1));
    final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
    final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

    if (requested) {
      try {
        steps = (await health.getTotalStepsInInterval(yesterdayStart, yesterdayEnd));
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }



      return steps;
    } else {
      print("Authorization not granted - error in authorization");
      return null;
    }
  }

  Future<double?> fetchHeight() async {
    await authorizationCheck();
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday =  now.subtract(Duration(days: 3652));

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> heightData =
            await health.getHealthDataFromTypes(yesterday, now, [HealthDataType.HEIGHT]);
        var height = double.parse(heightData.last.value.toString());
        return height;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }

  Future<double?> fetchWeight() async {
    await authorizationCheck();
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 3652));

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> heightData =
            await health.getHealthDataFromTypes(yesterday, now, [HealthDataType.WEIGHT]);
        var height = double.parse(heightData.last.value.toString());
        return height;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }
  Future<double?> fetchBodyIndex() async {
    await authorizationCheck();
    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 3652));

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> bodyIndexData =
            await health.getHealthDataFromTypes(yesterday, now, [HealthDataType.BODY_MASS_INDEX]);
        var body_index = double.parse(bodyIndexData.last.value.toString());

        return body_index;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }

  Future<double?> fetchEnergyBurned() async {
    await authorizationCheck();

    // get data within the last 24 hours
    final yesterday = DateTime.now().subtract(Duration(days:1));
    final yesterdayStart =DateTime(yesterday.year,yesterday.month,yesterday.day,00,00);
    final yesterdayEnd = DateTime(yesterdayStart.year, yesterdayStart.month, yesterdayStart.day,23,59,59);

    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> EnergyBurnedData =
            await health.getHealthDataFromTypes(yesterdayStart, yesterdayEnd, [HealthDataType.ACTIVE_ENERGY_BURNED]);
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
