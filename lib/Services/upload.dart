import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> upload(File image) async {
  //corta la ruta para obtener nombre
  final String nombreImagen = image.path.split("/").last;
  Reference ref = storage.ref().child("imagenesEvento").child(nombreImagen);

//se guarda en el firestore
  final UploadTask uploadTask = ref.putFile(image);

  //confirma la subida
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  //se abtiene la url de la imagen
  final String url = await snapshot.ref.getDownloadURL();

  return false;
}
