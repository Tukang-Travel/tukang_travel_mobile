import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuktraapp/models/user_model.dart';

User? currUser = FirebaseAuth.instance.currentUser;

void refreshUser() {
  currUser = FirebaseAuth.instance.currentUser;
}

Future<Map<String, dynamic>?> getUser(String uid) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();

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

//register google
Future<String> registerGoogle() async {
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  // try {
  //   await FirebaseAuth.instance
  //       .createUserWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   )
  //       .then((response) {
  //     refreshUser();
  //     currUser?.updateDisplayName(name);
  //     users.add(UserModel(response.user?.uid, name, username, email, userType)
  //         .toMap());
  //   });
  //   return 'Success';
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'weak-password') {
  //     return 'The password provided is too weak.';
  //   } else if (e.code == 'email-already-in-use') {
  //     return 'The account already exists for that email.';
  //   }
  //   return e.code;
  // } catch (e) {
  //   return e.toString();
  // }
  return '';
}

// login
Future<String> login(String username, String password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    QuerySnapshot querySnapshot = await users.get();
    for (var data in querySnapshot.docs) {
      if(data.get('username').toString() == username) {
        await auth.signInWithEmailAndPassword(email: data.get('email'), password: password);
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
Future<String> loginGoogle() async {
  //  FirebaseAuth auth = FirebaseAuth.instance;
  // try {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   QuerySnapshot querySnapshot = await users.get();
  //   for (var data in querySnapshot.docs) {
  //     if(data.get('username').toString() == username) {
  //       await auth.signInWithEmailAndPassword(email: data.get('email'), password: password);
  //       refreshUser();
  //     }
  //   }
  //   return 'Account not found';
  // } on FirebaseAuthException catch (e) {
  //   if (e.code == 'user-not-found') {
  //     return 'No user found for that email.';
  //   } else if (e.code == 'wrong-password') {
  //     return 'Wrong password provided.';
  //   }
  // } catch (e) {
  //   return e.toString();
  // }
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

// // user detail
// Future<ApiResponseModel> getUserDetail() async {
//   ApiResponseModel apiResponse = ApiResponseModel();

//   try {
//     String token = await getToken();

//     final response = await http.get(Uri.parse(userURL), headers: {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token'
//     });

//     switch (response.statusCode) {
//       case 200:
//         apiResponse.data = UserModel.fromJson(jsonDecode(response.body));
//         break;

//       case 401:
//         apiResponse.err = unauthorized;
//         break;

//       default:
//         apiResponse.err = other;
//         break;
//     }
//   } catch (e) {
//     apiResponse.err = serverError;
//   }

//   return apiResponse;
// }
