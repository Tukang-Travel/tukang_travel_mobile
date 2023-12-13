import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getPedia(String id) async {
  try {
    CollectionReference pedias = FirebaseFirestore.instance.collection('pedias');
    DocumentSnapshot pediaDocument = await pedias.doc(id).get();

    if (pediaDocument.exists) {
      return pediaDocument.data() as Map<String, dynamic>;
    } else {
      print('Pedia not found');
      return null;
    }
  } catch (e) {
    print('Error retrieving pedia data: $e');
    return null;
  }
}