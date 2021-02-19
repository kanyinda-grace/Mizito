import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mwasimozoto/model/top10.dart';
import 'package:provider/provider.dart';

class ListTop10 extends StatefulWidget {
  @override
  _ListTop10State createState() => _ListTop10State();
}

class _ListTop10State extends State<ListTop10> {
  @override
  Widget build(BuildContext context) {
    final listTop10 = Provider.of<List<Top10>>(context) ?? [];
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
            height: 420,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: Swiper(
                itemCount: listTop10.length,
                itemWidth: 250,
                layout: SwiperLayout.STACK,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        activeSize: 20.0, color: Colors.black, space: 8)),
                itemBuilder: (context, index) {
                  int nbreVote = index + 1;
                  return Stack(children: [
                    SizedBox(height: 20.0),
                    Container(
                      height: 350,
                      decoration: BoxDecoration(color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          listTop10[index].imgBella
                        ),
                        fit: BoxFit.cover
                      )
                      ),
                      child:Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.black.withOpacity(0.1)
                            ],
                            begin:Alignment.bottomRight
                          )
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Padding(padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text('N°$nbreVote ${listTop10[index].nomBella}', maxLines: 1,style: TextStyle(color:Colors.white, fontSize:16)),
                            Text('La ${listTop10[index].nationaliteBella}', maxLines: 1,style: TextStyle(color:Colors.white, fontSize:14)),
                            Text('${listTop10[index].nbreVoteBela} votés', maxLines: 1,style: TextStyle(color:Colors.white, fontSize:14))
                            
                            ],
                          ),)
                        ],
                        ),
                        
                      )
                    )
                  ]);
                })
                ),
      ]),
    );
  }
}
