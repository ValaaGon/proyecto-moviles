import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Widgets/TarjetasEvento.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Principal extends StatelessWidget {
  const Principal({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF40215e),
        title: Text(
          'Gestion eventos Symphony',
          style: TextStyle(
            color: const Color.fromARGB(
              255,
              240,
              237,
              237,
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirestoreServices().eventos(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Esperando datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // errores
            return Center(child: Text('Error al cargar datos'));
          } else {
            // listar

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                //se llama el widget de tarjetas
                var evento = snapshot.data!.docs[index];
                return TarjetaEvento(evento: evento);
              },
            );
          }
        },
      ),
    );
  }
}
