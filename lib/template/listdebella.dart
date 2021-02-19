import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:provider/provider.dart';

class ListDeBellaVote extends StatefulWidget {
  @override
  _ListDeBellaVoteState createState() => _ListDeBellaVoteState();
}

class _ListDeBellaVoteState extends State<ListDeBellaVote> {
  @override
  Widget build(BuildContext context) {
    final bellaVote = Provider.of<List<BellaVote>>(context);
    return SliverPadding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 16.0),
        sliver: SliverStaggeredGrid.countBuilder(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(1, index.isEven ? 1.5 : 1.8),
          itemCount: bellaVote.length,
          itemBuilder: (context, index) {
            int nbreVote = index + 1;

            return Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                      image: NetworkImage(bellaVote[index].imgBella),
                      fit: BoxFit.cover
                      )
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.1)
                            ],begin: Alignment.bottomRight
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              
                            ),
                            Padding(padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,children: [
                                  Text("N° $nbreVote ${bellaVote[index].nomBella}",
                                  style:TextStyle(color:Colors.white,fontSize:16,), maxLines: 1,
                                  ),
                                   Text( "${bellaVote[index].nomBella}",
                                  style:TextStyle(color:Colors.white,fontSize:16)
                                  ),
                                  
                              ],
                            )),
                              
                          ],
                        ),
                        )
                        
                        
            );
          },
        ));
  }
}
