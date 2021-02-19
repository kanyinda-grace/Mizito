import 'package:flutter/material.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/template/accueil.dart';
import 'package:mwasimozoto/template/loginPage1.dart';
import 'package:provider/provider.dart';
class Passerelle extends StatefulWidget {
  @override
  _PasserelleState createState() => _PasserelleState();
}

class _PasserelleState extends State<Passerelle> {
  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<Utilisateur>(context);

    if (utilisateur == null) {
      return LoginPage1();
    } else {
      return Accueil();
    }
  }
}
