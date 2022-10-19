import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verimadenciligi/appUsage.dart';
import 'package:verimadenciligi/appsCategory.dart';
import 'package:verimadenciligi/auth/googleSignIn.dart';
import 'package:verimadenciligi/auth/login_screen.dart';
import 'package:verimadenciligi/fetchData/fetchData.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var steps, height, glucose, weight, _body_index, _energyBurned;
  Future<void> fetchDataMain() async {
    await fetchData().authorizationCheck();
    var step = await fetchData().fetchStepData();
    var heig = await fetchData().fetchHeight();
    var wei = await fetchData().fetchWeight();
    var energyBurned = await fetchData().fetchEnergyBurned();

    // kg/m^2
    var body_index = await fetchData().fetchBodyIndex();
    // var blood_glucose = await fetchData().fetchBloodGLucose();
    setState(() {
      steps = step;
      height = heig.toString().substring(0, 4);
      // glucose = blood_glucose.toString().substring(0, 4);
      weight = wei.toString();
      _body_index = body_index.toString().substring(0, 5);
      _energyBurned = energyBurned.toString();
    });
  }

  @override
  void initState() {
    fetchDataMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasData){
            return LoginedInWidget(steps: steps,height: height,glucose: glucose,weight: weight,body_index: _body_index,energyBurned: _energyBurned,);
          }
          else if(snapshot.hasError){
            return Center(child: Text("Bir hata oluştu!"),);
          }
          else{
            return LoginScreen();
          }
        }
      ),
    );
  }
}
class LoginedInWidget extends StatelessWidget {
  final steps;
  final height;
  final glucose;
  final weight;
  final body_index;
  final energyBurned;

  LoginedInWidget({this.steps, this.height, this.glucose, this.weight,
       this.body_index, this.energyBurned});

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser!;
    final provider=Provider.of<GoogleSignInProvider>(context,listen: true);
    var genderNew=provider.gender;
    if(genderNew=="Male")
      {
        genderNew="Erkek";
      }
    else if(genderNew=="Female"){
      genderNew="Kadın";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Veri Madenciliği"),
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.blueGrey.shade900,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: (){
              final provider=Provider.of<GoogleSignInProvider>(context,listen: false);
              provider.logout();
            }, child: Text("Çıkış")),
            SizedBox(height: 32,),
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(height: 8,),
            Text("İsim: "+user.displayName.toString(),style: TextStyle(color: Colors.amber,fontSize: 25),),
            Text("Cinsiyet: ${genderNew}",style: TextStyle(color: Colors.amber,fontSize: 25),),

            Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Günlük Adım Sayısı: ${steps==null?0:steps.toString()}",
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
                    "Boy: ${height.toString()}",
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
                    "Vücut Kitle Indeksi: ${body_index.toString()}",
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
                    "Kilo: ${weight.toString()}",
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
                    "Harcanan Enerji: ${energyBurned.toString()}",
                    style: TextStyle(fontSize: 25),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppUsageClass()));
              },
              child: Text("Uygulama Süreleri"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppsCategory())) ;
              },
              child: Text("Uygulamaların Kategorileri"),
            ),
          ],
        ),
      ),
    );
  }
}
