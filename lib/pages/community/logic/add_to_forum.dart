import 'package:cloud_firestore/cloud_firestore.dart';

// this functions are focused on added  and manging members inforum

//add members to a particular forum
Future<void> addMembers(String colName, Map<String, dynamic> data) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('forum/$colName/members');

  await collection.add(data);
}

// check if someone is a member
Future<bool> ifMember(String colName, String member) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('forum/$colName/members');

  QuerySnapshot querySnapshot =
      await collection.where('userid', isEqualTo: member).get();
  if (querySnapshot.docs.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}
