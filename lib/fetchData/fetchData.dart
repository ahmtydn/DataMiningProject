
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
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
    print(requested);
  }
  /// Fetch steps from the health plugin and show them in the app.
  Future<int?> fetchStepData() async {
    int? steps;
     await authorizationCheck();
    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    if (requested) {
      try {
        steps = (await health.getTotalStepsInInterval(midnight, now));
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

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
        print("bodyy: $body_index");
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
    final now = DateTime.now();
    print("Şimdi:$now");
    final midnight = DateTime(now.year, now.month, now.day);
    print("gece:$midnight");



    if (requested) {
      try {
        // fetch health data
        List<HealthDataPoint> EnergyBurnedData =
            await health.getHealthDataFromTypes(midnight, now, [HealthDataType.ACTIVE_ENERGY_BURNED]);
        var energy=0.0;
        for(var i in EnergyBurnedData)
          {
             energy=energy+double.parse(i.value.toString());
          }

        print("Harcanan Enerji:${energy}");

        return energy;
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
        return null;
      }
    }
  }
}
