import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

class UserScopedModel extends Model {
  String email;
  String uid;
  bool isLoading;

  String getOnlyUser() {
    if (email.isEmpty) {
      return '';
    } else {
      int pos = email.indexOf('@');
      return pos == -1 ? email : email.substring(0, pos);
    }
  }

  Future<bool> verifyUser(String _email, String _password) async {
    bool esValido = false;

    isLoading = true;
    notifyListeners();

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

    isLoading = false;
    notifyListeners();
    return esValido;
  }
}
