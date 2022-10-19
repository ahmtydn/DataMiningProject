
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verimadenciligi/auth/googleSignIn.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
 var size=MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 15,),
              GestureDetector(
                onTap: (){
                  final provider=Provider.of<GoogleSignInProvider>(context,listen: false);
                  provider.googleLogin();
                },
                child: Container(
                  height: size.height / 15,
                  width: size.width /5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo,
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: Offset(-4, -4),
                      ), // BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      )
                    ],
                  ),
                  child: Center(
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Image.asset("asset/images/google.png"),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}
