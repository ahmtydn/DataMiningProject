import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verimadenciligi/apps/appUsage.dart';
import 'package:verimadenciligi/apps/appsCategory.dart';
import 'package:verimadenciligi/auth/googleSignIn.dart';
import 'package:verimadenciligi/auth/login_screen.dart';
import 'package:verimadenciligi/fetchData/fetchData.dart';
import 'package:verimadenciligi/model/dataModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataModel? _dataModel;
  bool isLoading = true;

  Future<void> fetchsData() async {
    await fetchData().authorizationCheck();
    var _steps,
        _height,
        _weight,
        _energyBurned,
        _body_mass_index,
        _age,
        _genders,
        _phoneModel;

    await fetchData()
        .fetchStepData()
        .then((value) => _steps = value.toString());
    await fetchData()
        .fetchHeight()
        .then((value) => _height = value.toString().substring(0, 4));
    await fetchData().fetchWeight().then((value) => _weight = value.toString());
    await fetchData()
        .fetchEnergyBurned()
        .then((value) => _energyBurned = value.toString());
    await fetchData()
        .fetchBodyIndex()
        .then((value) => _body_mass_index = value.toString());
    await fetchData()
        .ageReadSharedPreferences()
        .then((value) => _age = value.toString());
    await fetchData()
        .genderReadSharedPreferences()
        .then((value) => _genders = value.toString());
    await deviceInfoGet().then((value) => _phoneModel = value.toString());

    _dataModel = DataModel(
      stepsTotal: _steps,
      height: _height,
      weight: _weight,
      energyBurned: _energyBurned,
      body_mass_index: _body_mass_index,
      age: _age,
      gender: _genders,
      phoneModel: _phoneModel,
    );
  }

  Future<void> fetchDataMain() async {
    await fetchsData();
    setState(() {
      isLoading = false;
    });
  }

  Future<String> deviceInfoGet() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  }

  @override
  void initState() {
    fetchDataMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : LoginedInWidget(
                model: _dataModel!,
              ));
  }
}

class LoginedInWidget extends StatelessWidget {
  DataModel model;
  LoginedInWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Veri Madenciliği"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              color: Colors.blueGrey.shade900,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        AuthServices().logout();
                      },
                      child: Text("Çıkış")),
                  const SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Yaş: ${model.age}",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                  ),
                  Text(
                    "Cinsiyet: ${model.gender}",
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Günlük Adım Sayısı: ${model.stepsTotal == null ? 0 : model.stepsTotal.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Boy: ${model.height.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Vücut Kitle Indeksi: ${model.body_mass_index.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Kilo: ${model.weight.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Harcanan Enerji: ${model.energyBurned.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Telefon Modeli: ${model.phoneModel.toString()}",
                      style: TextStyle(fontSize: 25),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppUsageClass()));
                    },
                    child: Text("Uygulama Süreleri"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppsCategory()));
                    },
                    child: Text("Uygulamaların Kategorileri"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
