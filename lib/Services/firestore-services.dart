import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
//listar
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }
}
