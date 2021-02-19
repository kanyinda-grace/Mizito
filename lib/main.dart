
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/services/authentification.dart';
import 'package:mwasimozoto/template/accueil.dart';
import 'package:mwasimozoto/template/passerelle.dart';
import 'package:mwasimozoto/template/splashScreen.dart';
import'package:provider/provider.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Utilisateur>.value(
      value: ServiceAuth().utilisateur,
      child: MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        routes: {
          '/passerelle': (context) => Passerelle(),
          '/accueil': (context) => Accueil()
          
        },
      ),
    );
  }
}
