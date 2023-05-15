import 'dart:async';
import 'package:chatzy/firebase_services/apis.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';
import '../login/sign_in_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../widgets/splash_screen.dart';

class InternetCheck extends StatefulWidget {
  const InternetCheck({Key? key}) : super(key: key);

  @override
  State<InternetCheck> createState() => _InternetCheckState();
}

class _InternetCheckState extends State<InternetCheck> {
  Connectivity connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged,
        builder: (_, snapshot){
          return SplashScreen(snapshot: snapshot) ;
        },
      ),
    );
  }
}

class SplashServices {
  Future<void> isLogedIn(BuildContext context) async {

    final user = Apis.auth.currentUser;
    if (user != null) {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage(),),),);
    } else {
      Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInPage(),),),);
    }
  }
}
