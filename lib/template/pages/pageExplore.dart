import 'package:flutter/material.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:mwasimozoto/template/listTop10.dart';
import 'package:mwasimozoto/template/listdebella.dart';
import 'package:provider/provider.dart';

class PageExplore extends StatefulWidget {
  @override
  _PageExploreState createState() => _PageExploreState();
}

class _PageExploreState extends State<PageExplore> {
  @override
  Widget build(BuildContext context) {
    final listBellaVte = Provider.of<List<BellaVote>>(context);
    return SafeArea(
      child: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          floating: true,
          title: Text('les Mizitos', style: TextStyle(color: Colors.red)),
          actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: Colors.black))
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Text('Listes des membres',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.red)),
            )
          ]),
        ),
        ListTop10(),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text("Plus des ${listBellaVte.length} utilisateurs ",
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(color: Colors.red)))
        ])
        ),
        ListDeBellaVote()
      ]),
    );
  }
}
