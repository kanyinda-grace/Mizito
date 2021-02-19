import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mwasimozoto/model/utilisateur.dart';
import 'package:mwasimozoto/services/bdd.dart';

class ServiceAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Utilisateur _utilisateurFirebaseUser(User utilisateur) {
    return utilisateur != null ? Utilisateur(idUtil: utilisateur.uid) : null;
  }

  Stream<Utilisateur> get utilisateur {
    return _auth.authStateChanges().map(_utilisateurFirebaseUser);
  }

  //se connecter avec Google
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      FirebaseAuth auth = FirebaseAuth.instance;
      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);

      await ServiceBDD(idUtil: user.uid)
          .saveUserData(user.displayName, user.email, user.photoURL);

      return _utilisateurFirebaseUser(user);

      //appelle a notre class ServiceB

    } catch (error) {
      print(error);
    }
  }
//Deconnexion
  Future signOut() async {
    try {
      await googleSignIn.signOut();
      return await _auth.signOut();
    } catch (error) {
      return null;
    }
  }
}