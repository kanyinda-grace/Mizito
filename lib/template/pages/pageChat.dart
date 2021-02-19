import 'package:flutter/material.dart';
import 'package:mwasimozoto/template/listeDesMembres.dart';

class PageChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: Text("Discusions", style: TextStyle(color: Colors.black)),
            actions: [
              IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {})
            ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListesDesMembres()));
            },
            child: Icon(Icons.add_comment)));
  }
}
