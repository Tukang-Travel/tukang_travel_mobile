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

Future<void> insertPediaComment(String id, String comment, String userId) async {
  try {
    await FirebaseFirestore.instance.collection('pedias').doc(id).update({
      'comments': FieldValue.arrayUnion([
        {'comment': comment, 'userid': userId}
      ]),
    });
    print('Comment added successfully!');
  } catch (e) {
    print('Error adding comment: $e');
  }
}

Future<void> insertPediaRate(String id, int rate, String userId) async {
  try {
    List<dynamic> results = await Future.wait([
      getPedia(id)
    ]);

    await FirebaseFirestore.instance.collection('pedias').doc(id).update({
      'rates': FieldValue.arrayUnion([
        {'rate': rate, 'userid': userId}
      ]),
    });
    print('Rate added successfully!');
  } catch (e) {
    print('Error adding rate: $e');
  }
}