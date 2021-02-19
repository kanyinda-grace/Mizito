import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/services/authentification.dart';
import 'package:provider/provider.dart';

class ProfilUtilisateurs extends StatefulWidget {
  String idUtil, nomUtil, photoUtil, lastImgUrl, emailUtil;
  int nbrePost;
   Timestamp dateInscription;
        
  ProfilUtilisateurs(
      {this.idUtil,
      this.nomUtil,
      this.photoUtil,
      this.lastImgUrl,
      this.emailUtil,
      this.nbrePost,
      this.dateInscription});
  @override
  _ProfilUtilisateursState createState() => _ProfilUtilisateursState();
}

class _ProfilUtilisateursState extends State<ProfilUtilisateurs> {
  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<Utilisateur>(context);
    final dateDeFirestore = widget.dateInscription.toDate();
    String date = DateFormat.yMMMMd().format(dateDeFirestore);
    return Scaffold(
      appBar:AppBar(
        backgroundColor :Colors.white,

        iconTheme:IconThemeData(color:Colors.black),
        title:utilisateur.idUtil !=widget.idUtil?
         Text('Profil de ${widget.nomUtil} ', 
         style: TextStyle(color: Colors.black)):
         Text('Mon compte ', style:TextStyle(color:Colors.black))
      ),
      body:Column(children:[
        Container(
          height: 270,
          width:double.infinity,
          
        
          decoration :BoxDecoration(
            image:DecorationImage(
              image:widget.lastImgUrl ==''?AssetImage('assets/logo.jpg')
              :NetworkImage('${widget.lastImgUrl}'),fit:BoxFit.cover
            )
            
          ),
          child: Container(decoration: BoxDecoration(gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors:[

              Colors.black.withOpacity(.9),
              Colors.black.withOpacity(.1)
            ]
          )
          ),
          child: Padding(padding:EdgeInsets.all(16.0),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width:2.0),
                  image: DecorationImage(image: NetworkImage(
                    '${widget.photoUtil}',
                   
                  ),
                   fit:BoxFit.cover)
                ),
              ),
              SizedBox(height:10.0),
              Column(crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(widget.nomUtil,
                style:TextStyle(color:Colors.white,fontSize:16.0)),
                Text(widget.emailUtil,
                style:TextStyle(color:Colors.white,fontSize:18.0)),
                Text("membre depiuis $date",
                style:TextStyle(color:Colors.white,fontSize:16.0)),
                Text('${widget.nomUtil} posts en dilemme' ,
                maxLines: 1,
                style:TextStyle(color:Colors.white,fontSize:16.0)
                )
              ],
              
              ),
               utilisateur.idUtil == widget.idUtil ?  Padding(
            padding: EdgeInsets.only(right: 8.0),
            
            child: Align(alignment:Alignment.centerRight,
               child:MaterialButton(
                 onPressed:(){
                   ServiceAuth auth = ServiceAuth();
                   auth.signOut();
                 }
                 ,child:Text(
                 'deconnection' , style:TextStyle(color: Colors.white   ),

                
               ))
            ),
            ):Padding(padding:EdgeInsets.only(right:8.0),
            child:Align(alignment:Alignment.centerRight,child:Row(
              children: [
                MaterialButton(
                  child:Text("Mesaage", style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.white, letterSpacing: 1.5
                  )
                ),
                color: Colors.redAccent, onPressed: (){},
                ),

                SizedBox(width:10.0),

                 MaterialButton(
                  child:Text("Voir ses dilemmes", style: Theme.of(context).textTheme.button.copyWith(
                    color: Colors.white, letterSpacing: 1.5
                  )
                ),
                color: Colors.blueGrey, onPressed: (){},
                ),
              ],
            ))
            )
          
            ],
          ),

          
          
         
          ),
        )
        
        )
      ])
      
    );
  }
}
