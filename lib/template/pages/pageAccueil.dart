import 'package:flutter/material.dart';
import 'package:mwasimozoto/template/ListUtilisateur.dart';
import 'package:mwasimozoto/template/listdilemme.dart';

class PageAccueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/logo.jpg'),
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'MIZ',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextSpan(
                    text: 'OTO',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                ]
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.search, size: 25, color: Colors.black,),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(Icons.notifications, size: 25, color: Colors.black,),
              )
            ],
            backgroundColor: Colors.white,
            floating: true,
          ),
       SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 8.0),
                  child: Container(
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(height: 100, child:ListUtil()),
                    ),
                  ),
                )
              ]
            ),
          ),
         ListDilemm()
        ]
      )
    );
  }
  }

