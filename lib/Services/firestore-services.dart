import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
//listar
  Stream<QuerySnapshot> eventos() {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  }

  //agregar
  Future<void> eventoAgregar(
      String detalles,
      String estado,
      int like,
      DateTime fecha_desarrollo,
      String titulo,
      String tipo,
      String lugar,
      String foto) async {
    return FirebaseFirestore.instance.collection('Eventos').doc().set({
      'detalles': detalles,
      'estado': estado,
      'fecha': fecha_desarrollo,
      'like': like,
      'titulo': titulo,
      'tipo': tipo,
      'lugar': lugar,
      'foto': foto
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

  //Actualizacion
  Future<void> actualizarEvento(
    String id,
    String estado,
    String detalles,
    DateTime fecha,
    int like,
    String titulo,
  ) async {
    return FirebaseFirestore.instance.collection('Eventos').doc(id).update({
      'estado': estado,
      'detalles': detalles,
      'fecha': fecha,
      'like': like,
      'titulo': titulo,
    });
  }

  //Tipos de evento
  Future<QuerySnapshot> tiposEvento() async {
    return FirebaseFirestore.instance.collection('Tipos').get();
  }
}
