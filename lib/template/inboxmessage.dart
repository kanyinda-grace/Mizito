import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/services/bdd.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class InboxMessage extends StatefulWidget {
  String nom, imgUrl, idExp, idDest, idMsg;
  InboxMessage({this.nom, this.imgUrl, this.idExp, this.idDest, this.idMsg});
  @override
  _InboxMessageState createState() => _InboxMessageState();
}

class _InboxMessageState extends State<InboxMessage> {
  File image;
  @override
  Widget build(BuildContext context) {
    TextEditingController messageContrlller = TextEditingController();
    final utilisateur = Provider.of<Utilisateur>(context);
    

    return StreamBuilder<DonnEesUtil>(
        stream: ServiceBDD(idUtil: utilisateur.idUtil).donnEesUtil,
        builder: (context, snapshot) {
          final donneUtil = snapshot.data;
          Future<void> envoieMsgText() async {
            ProgressDialog pr = ProgressDialog(context);
            pr = ProgressDialog(context,
                type: ProgressDialogType.Normal, isDismissible: false);

            pr.style(
                message: "encours d'envoie ...",
                backgroundColor: Colors.white,
                progressWidget: CircularProgressIndicator());
            await pr.show();

            if (messageContrlller.text.length > 0) {
              await ServiceBDD().envoyezMsg(
                  donneUtil.nomUtil,
                  donneUtil.photoUrl,
                  widget.idExp,
                  widget.idDest,
                  widget.nom,
                  widget.imgUrl,
                  messageContrlller.text,
                  '');
              await pr.hide();
              messageContrlller.clear();
            }
          }


          //methoe pour enregisterr une video
       Future<void>   envoieMsgImage(ImageSource source)async{
         File imageSelectionee = await ImagePicker.pickImage(source :source);
         setState((){
          this.image = imageSelectionee ;
          showDialog(context: context, builder: (_)=>SimpleDialog(
                contentPadding: EdgeInsets.zero,
                children: [
                  image.file(this.image),Padding(padding:EdgeInsets.only(left:8.0, right:8.0),
                  child:Column(crossAxisAlignment:CrossAxisAlignment.stretch, children:[
                    Flatutton(color:Colors.redAccent,child:Text('Envoyer la photo', style:TextStyle(color:Colors.white)))
                  ])
                  
                  )
                ],
          ));

         });
       }

          return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                  title: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(widget.imgUrl),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(widget.nom,
                        maxLines: 1, style: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(),
                ],
              )),
              body: Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        height: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: 'Tappez un message',
                                          border: InputBorder.none),
                                      maxLines: 3,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      controller: messageContrlller,
                                    ))),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent),
                              child: IconButton(
                                onPressed: ()=>envoieMsgText(),
                                icon: Icon(Icons.send, color: Colors.white),
                              ),
                            ),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent),
                              child: IconButton(
                                onPressed: ()=>envoieMsgImage(ImageSource.galerie),,
                                icon: Icon(Icons.image, color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ));
        });
  }
}
