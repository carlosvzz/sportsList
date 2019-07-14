import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String email;
  String uid;

  String getOnlyUser() {
    if (email?.isEmpty ?? true) {
      return '';
    } else {
      int pos = email.indexOf('@');
      return pos == -1 ? email : email.substring(0, pos);
    }
  }

  Future<bool> verifyUser(String _email, String _password) async {
    bool esValido = false;

    if (uid?.isNotEmpty ?? false) {
      esValido = true;
    } else {
      try {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        FirebaseUser fbUser;

        fbUser = await firebaseAuth.currentUser();
        if (fbUser == null) {
          // Verificar usuario
          fbUser = await firebaseAuth.signInWithEmailAndPassword(
              email: _email, password: _password);
        }

        if (fbUser != null) {
          esValido = true;
          email = fbUser.email;
          uid = fbUser.uid;
        }
      } catch (e) {
        print(e.toString());
      }
    }
    return esValido;
  }
}
