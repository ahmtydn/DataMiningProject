import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppsCategory extends StatefulWidget {
  const AppsCategory({Key? key}) : super(key: key);

  @override
  State<AppsCategory> createState() => _AppsCategoryState();
}

class _AppsCategoryState extends State<AppsCategory> {

  Future<List<Application>> getCetogrys()  async {
    List<Application> apps = await DeviceApps.getInstalledApplications();
    return apps;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori"),
      ),
      body: FutureBuilder<List<Application>>(
        future: getCetogrys(),// async work
        builder: (BuildContext context,snapshot) {

         return snapshot.data==null?CircularProgressIndicator(): ListView.builder(
           itemCount: snapshot.data!.length,
           itemBuilder: (context, index) {
             return Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Card(child: Column(
                   children: [
                     Text(snapshot.data![index].appName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                     SizedBox(height: 10),
                     Text("Kategori: ${snapshot.data![index].category.name}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                   ],
                 )),
               ],
             );
           },
         );
        },
      )
    );
  }
}
