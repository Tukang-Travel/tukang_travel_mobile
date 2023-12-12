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

Future<void> insertSubItinerary(String id, String dayNum, Map<String, dynamic> itinerary) async {
  CollectionReference plans = FirebaseFirestore.instance.collection('planners');

  // Get the document reference
  DocumentReference docRef = plans.doc(id);

  // Get the current data of the document
  DocumentSnapshot docSnapshot = await docRef.get();
  Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

  // Find the day with the specified dayNumber
  var day = data['days']?.firstWhere((day) => day['day'] == dayNum, orElse: () => {});

  // If the day is found, append the new itinerary
  if (day.isNotEmpty) {
    day['itineraries'] = [...day['itineraries'], itinerary];
  }

  // Update the document in Firebase
  await docRef.update({'days': data['days']});
}

Future<void> updateSubItinerary(String id, int dayIdx, int itineraryIdx, Map<String, dynamic> itinerary) async {
  try {
    FirebaseFirestore.instance.collection('planners').doc(id)
    .update({
      'days.$dayIdx.itineraries.$itineraryIdx': itinerary,
    })
    .then((_) {
      print('Itinerary updated successfully!');
    })
    .catchError((error) {
      print('Error updating itinerary: $error');
    });
  } catch (e) {
    print('Error updating itinerary: $e');
  }
}

Future<void> deleteSubItinerary(String id, int dayIdx, int itineraryIdx) async {
  try {
    FirebaseFirestore.instance.collection('planners').doc(id)
    .update({
      'days.$dayIdx.itineraries.$itineraryIdx': FieldValue.delete(),
    })
    .then((_) {
      print('Itinerary deleted successfully!');
    })
    .catchError((error) {
      print('Error deleting itinerary: $error');
    });
  } catch (e) {
    print('Error deleting itinerary: $e');
  }
}