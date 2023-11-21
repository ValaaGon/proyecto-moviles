import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
//listar
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }

  //agregar
  Future<void> eventoAgregar(String detalles, String estado, int like,
      DateTime fecha_desarrollo, String titulo) async {
    return FirebaseFirestore.instance.collection('evento').doc().set({
      'detalles': detalles,
      'estado': estado,
      'fecha': fecha_desarrollo,
      'like': like,
      'titulo': titulo,
    });
  }

  //borrar
  Future<void> eventoBorrar(String id) async {
    return FirebaseFirestore.instance.collection('Eventos').doc(id).delete();
  }

  // Filtrados
  Stream<QuerySnapshot> eventosFiltrados(String estado) {
    return FirebaseFirestore.instance
        .collection('Eventos')
        .where('estado', isEqualTo: estado)
        .snapshots();
  }

  //editar
}
