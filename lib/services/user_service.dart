import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/user_model.dart';

class UserService {
  User? currUser = FirebaseAuth.instance.currentUser;

  void refreshUser() {
    currUser = FirebaseAuth.instance.currentUser;
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDocument = await users.doc(uid).get();

      if (userDocument.exists) {
        return userDocument.data() as Map<String, dynamic>;
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

  // get user details
  Future<UserModel> getUserDetails() async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return UserModel.fromSnap(documentSnapshot);
  }

  //register
  Future<String> register(String name, String username, String email,
      String password, String userType) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((response) {
        refreshUser();
        currUser?.updateDisplayName(name);
        users.doc(currUser?.uid).set(UserModel(
                uid: response.user?.uid as String,
                name: name,
                username: username,
                email: email,
                type: userType)
            .toMap());
      });
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.code;
    } catch (e) {
      return e.toString();
    }
  }

  // login
  Future<String> login(String username, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot = await users.get();
      for (var data in querySnapshot.docs) {
        if (data.get('username').toString() == username) {
          await auth.signInWithEmailAndPassword(
              email: data.get('email'), password: password);
          refreshUser();
          return 'Success';
        }
      }
      return 'Account not found';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      }
    } catch (e) {
      return e.toString();
    }
    return '';
  }

  // login
  Future<String> googleLoginRegister(String type) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        QuerySnapshot querySnapshot = await users.get();
        for (var data in querySnapshot.docs) {
          if (data.get('email').toString() == userCredential.user!.email) {
            refreshUser();
            return 'Success';
          }
        }

        //user first time login, masukin ke db dulu
        refreshUser();
        users.doc(userCredential.user!.uid).set(UserModel(
                uid: userCredential.user!.uid,
                name: userCredential.user!.displayName!,
                username: userCredential.user!.displayName!
                    .toLowerCase()
                    .replaceAll(' ', '_'),
                email: userCredential.user!.email!,
                type: type)
            .toMap());
        return 'Success';
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return 'The account already exists with a different credential.';
        } else if (e.code == 'invalid-credential') {
          return 'Error occurred while accessing credentials. Try again.';
        }
      } catch (e) {
        return e.toString();
      }
    }

    return '';
  }

  // logout
  Future<bool> logout() async {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  // get user token
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  // get user id
  Future<int> getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt('userId') ?? 0;
  }

  Future<List<Map<String, dynamic>>> getPreferencesTemplate() async {
    try {
      CollectionReference preferences =
          FirebaseFirestore.instance.collection('preferences');
      QuerySnapshot preferencesSnapshot = await preferences.get();

      List<Map<String, dynamic>> resultList = [];

      for (QueryDocumentSnapshot documentSnapshot in preferencesSnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        resultList.add(data);
      }
      return resultList;
    } catch (e) {
      print('Error retrieving preferences data: $e');
      return [];
    }
  }

  Future<String> createUpdateUserPreferences(List<String> data) async {
    String res = "Some error occurred";
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currUser?.uid)
          .update({'interest': FieldValue.arrayUnion(data)});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
