import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> getPlan(String id) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('planners');
    DocumentSnapshot planDocument = await users.doc(id).get();

    if (planDocument.exists) {
      return planDocument.data() as Map<String, dynamic>;
    } else {
      print('Plan not found');
      return null;
    }
  } catch (e) {
    print('Error retrieving user data: $e');
    return null;
  }
}

Future<void> insertPlanner(String title, String source, String destination, String startDate, String endDate, int budget, int people) async {
  Map<String, dynamic> plan = {
    'title': title,
    'source': source,
    'destination': destination,
    'startDate': startDate,
    'endDate': endDate,
    'budget': budget,
    'people': people,
  };
  try {
    await FirebaseFirestore.instance.collection('planners').add(plan);
  } catch (e) {
    print('Error inserting plan: $e');
  }
}

Future<void> deletePlanner(String id) async {
  try {
    await FirebaseFirestore.instance.collection('planners').doc(id).delete();
  } catch (e) {
    print('Error deleting plan: $e');
  }
}

Future<void> updatePlanner(String id, String title, String source, String destination, String startDate, String endDate, int budget, int people) async {
  Map<String, dynamic> plan = {
    'title': title,
    'source': source,
    'destination': destination,
    'startDate': startDate,
    'endDate': endDate,
    'budget': budget,
    'people': people,
  };
  try {
    await FirebaseFirestore.instance.collection('planners').doc(id).update(plan);
  } catch (e) {
    print('Error updating plan: $e');
  }
}

Future<void> insertItinerary(String id, List<Map<String, dynamic>>? days) async {
  try {
    if (days != null) {
      List<dynamic> convertedDays = days.cast<dynamic>();
      await FirebaseFirestore.instance.collection('planners').doc(id).update({
        'days': FieldValue.arrayUnion(convertedDays),
      });
    }
  } catch (e) {
    print('Error inserting itinerary: $e');
  }
}