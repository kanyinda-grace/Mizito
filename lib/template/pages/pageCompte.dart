import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/services/authentification.dart';
import 'package:provider/provider.dart';

class PageCompte extends StatefulWidget {
  @override
  _PageCompteState createState() => _PageCompteState();
}

class _PageCompteState extends State<PageCompte> {
  @override
  Widget build(BuildContext context) {
    final donneutil = Provider.of<DonnEesUtil>(context) ?? DonnEesUtil();
    final dateDeFirestore = donneutil.dateInscription.toDate();
    String date = DateFormat.yMMMEd().format(dateDeFirestore);
    return donneutil == null ? SafeArea(
        child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            )
        )
    )  : SafeArea(
            child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                  backgroundColor: Colors.white,
                  title: Text("Mon Compte",
                      style: TextStyle(color: Colors.black))),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      height: 235.0,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: donneutil.lastImgPost == ''
                                    ? AssetImage('assets/logo.jpg')
                                    : NetworkImage('${donneutil.lastImgPost}'),
                                fit: BoxFit.cover)),
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.5),
                            ], begin: Alignment.bottomRight)),
                            child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              image: DecorationImage(
                                                  image: donneutil.photoUrl !=
                                                          ''
                                                      ? NetworkImage(
                                                          '${donneutil.photoUrl}')
                                                      : AssetImage(
                                                          'assets/logo.jpg'),
                                                  fit: BoxFit.cover))),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(donneutil.nomUtil,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.0)),
                                          Text(donneutil.emailUtil,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0)),
                                          Text('${donneutil.nbrePost}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0)),
                                          Text('Membre depuis $date',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.0))
                                        ],
                                      )
                                    ]))),
                      )),
                  Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: MaterialButton(
                            onPressed: () {
                              ServiceAuth auth = ServiceAuth();
                              auth.signOut();
                            },
                            color: Colors.redAccent,
                            child: Text(
                              "Deconnection",
                              style: TextStyle(color: Colors.white),
                            ),
                          )))
                ]),
              )
            ],
          ));
  }
}
