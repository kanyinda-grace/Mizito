import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mwasimozoto/model/bellavote.dart';
import 'package:mwasimozoto/model/dilemmePost.dart';
import 'package:mwasimozoto/model/top10.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/model/vote.dart';

class ServiceBDD {
  String idUtil, idPost;
  ServiceBDD({this.idUtil, this.idPost});

// collection de reference utilisateur
  final CollectionReference collectionUtilisateurs =
      FirebaseFirestore.instance.collection('utilisateurs');

//collection pour le top10 de dillemme
//collection pour le top10
  final CollectionReference collectionTop10 =
      FirebaseFirestore.instance.collection('top10');

  // query de top 10 de bella
  final Query queryTop10 = FirebaseFirestore.instance
      .collection('top10')
      .orderBy('nbreVoteBella', descending: true)
      .limit(10);

  //query de toutes les bellas votées

  final Query queryBellaVote = FirebaseFirestore.instance
      .collection('top10')
      .orderBy('nbreVoteBella', descending: false);

  //collection Romm pour le chat
  final CollectionReference collectionRoom =
      FirebaseFirestore.instance.collection('room');

// collection des posts

  final CollectionReference collectionPosts =
      FirebaseFirestore.instance.collection('posts');

//query utilisteur
  final Query queryUilisateurs = FirebaseFirestore.instance
      .collection('utilisateurs')
      .orderBy('nbrePost', descending: true);

  //querry de Dilemme
  final Query queryDilemme = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true);
  // metohe pour enregistre un nouveau utilisateur

  Future<void> saveUserData(nomUtil, emailUtil, photoUrl) async {
    try {
      DocumentReference documentReference = collectionUtilisateurs.doc(idUtil);
      documentReference.snapshots().listen((doc) async {
        if (doc.exists) {
          return null;
        } else {
          return await collectionUtilisateurs.doc(idUtil).set({
            "idUtil": idUtil,
            'nomUtil': nomUtil,
            'emailUtil': emailUtil,
            'photoUrl': photoUrl,
            'nbrePost': 0,
            'lastImgPost': '',
            'dateInscription': FieldValue.serverTimestamp()
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

  //methode pour fetching les donées utilisateurs
  DonnEesUtil _donnEesUtilFromSnapshot(DocumentSnapshot snapshot) {
    return DonnEesUtil(
        idUtil: snapshot.data()['idUtil'],
        nomUtil: snapshot.data()['nomUtil'],
        emailUtil: snapshot.data()['emailUtil'],
        photoUrl: snapshot.data()['photoUrl'],
        nbrePost: snapshot.data()['nbrePost'],
        lastImgPost: snapshot.data()['lastImgPost'],
        dateInscription: snapshot.data()['dateInscription']);
  }

  Stream<DonnEesUtil> get donnEesUtil {
    return collectionUtilisateurs
        .doc(idUtil)
        .snapshots()
        .map(_donnEesUtilFromSnapshot);
  }

  // list de tous les utilisateurs from snapshot
  // c'est une snapshot parceque nous avons besoinde lister les données
  List<DonnEesUtil> _listUtilFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DonnEesUtil(
          idUtil: doc.data()['idUtil'],
          nomUtil: doc.data()['nomUtil'],
          emailUtil: doc.data()['emailUtil'],
          photoUrl: doc.data()['photoUrl'],
          nbrePost: doc.data()['nbrePost'],
          lastImgPost: doc.data()['lastImgPost'],
          dateInscription: doc.data()['dateInscription']);
    }).toList();
  }

  //obtention des utilisateurs en stream
  Stream<List<DonnEesUtil>> get listDesUtils {
    return queryUilisateurs.snapshots().map(_listUtilFromSnapshot);
  }

  // methode pour ajouter un dilemme

  Future<void> ajoutPost(context, nomB1, nationaliteB1, imB1, nomB2,
      nationaliteB2, imB2, nomUtil, imgUtil, emailUtil) async {
    try {
      Random radom = Random();
      int idBella1 = radom.nextInt(1000);
      int idBella2 = radom.nextInt(1000);
      String idPost = collectionPosts.doc().id;

      await collectionUtilisateurs.doc(idUtil).update(
        {'nbrePost': FieldValue.increment(1), 'lastImgPost': imB1},
      );
      return await collectionPosts.doc(idPost).set({
        'bella1': {
          'idB1': idBella1,
          'nomB1': nomB1,
          'nationaliteB1': nationaliteB1,
          'imgB1': imB1
        },
        'bella2': {
          'idB2': idBella2,
          'nomB2': nomB1,
          'nationaliteB12': nationaliteB1,
          'imgB2': imB2
        },
        "utilisateur": {
          'idUtil': idUtil,
          'nomUtil': nomUtil,
          'emailUtil': emailUtil,
          'imgUtil': imgUtil
        },
        'idPost': idPost,
        'nbreVoteB1': 0,
        'nbreVoteB2': 0,
        'totalVotePost': 0,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("oups quelque chose ne va pas  ${error.toString()} "),
      ));
    }
  }
  //ist des dilemme from snapshot

  //list des dilemmes from snapshot
  List<Dilemme> _dilemmeListOfSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Dilemme(
        totalVote: doc.data()['totalVotePost'],
        nbreVoteB1: doc.data()['nbreVoteB1'],
        nbreVoteB2: doc.data()['nbreVoteB2'],
        timestamp: doc.data()['timestamp'],
        bella1: doc.data()['bella1'],
        bella2: doc.data()['bella2'],
        idPost: doc.data()['idPost'],
        utilisateur: doc.data()['utilisateur'] ?? {},
      );
    }).toList();
  }

  Stream<List<Dilemme>> get listDilemme {
    return queryDilemme.snapshots().map(_dilemmeListOfSnapshot);
  }

  //get vote by User
  Vote _voteFromSnapShop(DocumentSnapshot doc) {
    return Vote(
        idUtilVote: doc.data()['idVoteUtil'] ?? '',
        idPostVote: doc.data()['idPost'] ?? '',
        nomBvote: doc.data()['nomBella'] ?? '',
        natBvote: doc.data()['nationalite'] ?? '',
        nomUtil: doc.data()['nomUtil'] ?? '');
  }

  Stream<Vote> get voteData {
    return collectionPosts
        .doc(idPost)
        .collection('votes')
        .doc(idUtil)
        .snapshots()
        .map(_voteFromSnapShop);
  }

  Future onVoteB1(
      idPost, idUser, nomUser, idBella, nomBella, nationalite, imgBella) async {
    try {
      final DocumentReference docummentReference =
          collectionTop10.doc(idBella.toString());
      docummentReference.get().then((ds) async {
        if (ds.exists) {
          await collectionPosts.doc(idPost).update({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost': FieldValue.increment(1),
          });
          await collectionPosts
              .doc(idPost)
              .collection('votes')
              .doc(idUser)
              .set({
            'idVoteUtil': idUser,
            'idPost': idPost,
            'nomBella': nomBella,
            'nationalite': nationalite,
            'nomUtil': nomUser
          });
          return await collectionTop10
              .doc(idBella.toString())
              .update({'nbreVoteBella': FieldValue.increment(1)});
        } else {
          await collectionPosts.doc(idPost).update({
            'nbreVoteB1': FieldValue.increment(1),
            'totalVotePost': FieldValue.increment(1),
          });
          await collectionPosts
              .doc(idPost)
              .collection('votes')
              .doc(idUser)
              .set({
            'idVoteUtil': idUser,
            'idPost': idPost,
            'nomBella': nomBella,
            'nationalite': nationalite,
            'nomUtil': nomUser
          });
          return await collectionTop10.doc(idBella.toString()).set({
            'idBella': idBella,
            'nomBella': nomBella,
            'nationalitBella': nationalite,
            'imgBella': imgBella,
            'nbreVoteBella': 1,
            'idUser': idUser
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future onVoteB2(
      idPost, idUser, nomUser, idBella, nomBella, nationalite, imgBella) async {
    try {
      final DocumentReference docummentReference =
          collectionTop10.doc(idBella.toString());
      docummentReference.get().then((ds) async {
        if (ds.exists) {
          await collectionPosts.doc(idPost).update({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost': FieldValue.increment(1),
          });
          await collectionPosts
              .doc(idPost)
              .collection('votes')
              .doc(idUser)
              .set({
            'idVoteUtil': idUser,
            'idPost': idPost,
            'nomBella': nomBella,
            'nationalite': nationalite,
            'nomUtil': nomUser
          });
          return await collectionTop10
              .doc(idBella.toString())
              .update({'nbreVoteBella': FieldValue.increment(1)});
        } else {
          await collectionPosts.doc(idPost).update({
            'nbreVoteB2': FieldValue.increment(1),
            'totalVotePost': FieldValue.increment(1),
          });
          await collectionPosts
              .doc(idPost)
              .collection('votes')
              .doc(idUser)
              .set({
            'idVoteUtil': idUser,
            'idPost': idPost,
            'nomBella': nomBella,
            'nationalite': nationalite,
            'nomUtil': nomUser
          });
          return await collectionTop10.doc(idBella.toString()).set({
            'idBella': idBella,
            'nomBella': nomBella,
            'nationalitBella': nationalite,
            'imgBella': imgBella,
            'nbreVoteBella': 1,
            'idUser': idUser
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> suppressionDilemme(idPost, idUser, context) async {
    try {
      await collectionUtilisateurs.doc(idUser).update({
        'nbrePost': FieldValue.increment(-1),
      });
      return await collectionPosts.doc(idPost).delete();
    } catch (error) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Oups! quelque chose s\'est mal passé'),
      ));
    }
  }

  //listes de top 10 de bella votées
  List<Top10> queryTop10FromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Top10(
        idBella: doc.data()['idBella'],
        nomBella: doc.data()['nomBella'],
        nationaliteBella: doc.data()['nationaliteBella'],
        imgBella: doc.data()['imgBella'],
        nbreVoteBela: doc.data()['nbreVoteBella'],
        idUser: doc.data()['idUser'],
      );
    }).toList();
  }

// stream de query de top10
  Stream<List<Top10>> get top10data {
    return queryTop10.snapshots().map(queryTop10FromSnapShot);
  }

//listes des toutes les bellas votéées
  List<BellaVote> querybellaVoteFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BellaVote(
        idBella: doc.data()['idBella'],
        nomBella: doc.data()['nomBella'],
        nationaliteBella: doc.data()['nationaliteBella'],
        imgBella: doc.data()['imgBella'],
        nbreVoteBela: doc.data()['nbreVoteBella'],
        idUser: doc.data()['idUser'],
      );
    }).toList();
  }

//stream de query d bella votee
  Stream<List<BellaVote>> get bellaVotee {
    return queryBellaVote.snapshots().map(querybellaVoteFromSnapShot);
  }
  //creer une nouvelle duscusion

  //créer une nvlle discussion
  Future<void> envoyezMsg(nomExp,  imgUrlExp, idExp, idDest, nomDest, imgUrlDest, msgTxt, msgImage) {
    try {
      String idMonChat = '$idExp$idDest';
      String idSonChat = '$idDest$idExp';
      String idMessage = collectionRoom.doc().id;

      DocumentReference docChat = collectionRoom
          .doc(idExp)
          .collection('chats')
          .doc(idMonChat);

      docChat.get().then((doc) async {
        if (doc.exists) {
          await collectionRoom
              .doc(idExp)
              .collection('chats')
              .doc(idMonChat)
              .update({
            'nbreMsgNonLis': FieldValue.increment(1),
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp(),
          });

          await collectionRoom
              .doc(idDest)
              .collection('chats')
              .doc(idSonChat)
              .update(({
            'nbreMsgNonLis': FieldValue.increment(1),
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp(),
          }));

          await collectionRoom
              .doc(idDest)
              .collection('chats')
              .doc(idSonChat)
              .collection('messages')
              .doc(idMessage)
              .set({
            'idMsg': idMessage,
            'idExp': idExp,
            'idDest': idDest,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp()
          });

          return await collectionRoom
              .doc(idExp)
              .collection('chats')
              .doc(idMonChat)
              .collection('messages')
              .doc(idMessage)
              .set({
            'idMsg': idMessage,
            'idExp': idExp,
            'idDest': idDest,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp()
          });
        } else {
          await collectionRoom
              .doc(idDest)
              .collection('chats')
              .doc(idSonChat)
              .set({
            'nbreMsgNonLis': 1,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp(),
            'exp': {
              'idExp': idExp,
              'nomExp': nomExp,
              'emailExp': emailExp,
              'imgUrlExp': imgUrlExp,
            },
            'dest': {
              'idDest': idDest,
              'emailDest': emailDest,
              'nomDest': nomDest,
              'imgUrlDest': imgUrlDest
            }
          });

          await collectionRoom
              .doc(idExp)
              .collection('chats')
              .doc(idMonChat)
              .set({
            'nbreMsgNonLis': 1,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp(),
            'exp': {
              'idExp': idExp,
              'nomExp': nomExp,
              'emailExp': emailExp,
              'imgUrlExp': imgUrlExp,
            },
            'dest': {
              'idDest': idDest,
              'emailDest': emailDest,
              'nomDest': nomDest,
              'imgUrlDest': imgUrlDest
            }
          });

          await collectionRoom
              .doc(idDest)
              .collection('chats')
              .doc(idSonChat)
              .collection('messages')
              .doc(idMessage)
              .set({
            'idMsg': idMessage,
            'idExp': idExp,
            'idDest': idDest,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp()
          });
          return await collectionRoom
              .doc(idExp)
              .collection('chats')
              .doc(idMonChat)
              .collection('messages')
              .doc(idMessage)
              .set({
            'idMsg': idMessage,
            'idExp': idExp,
            'idDest': idDest,
            'msgTxt': msgTxt,
            'msgImage': msgImage,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
      });
    } catch (error) {
      print(error.toString());
    }
  }

}
