import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addItemDetails(
      Map<String, dynamic> itemDetails, String id) async {
    await _firestore.collection('items').doc(id).set(itemDetails);
  }
}
