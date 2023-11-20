import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TarjetasAdmin extends StatefulWidget {
  final QueryDocumentSnapshot evento;

  TarjetasAdmin({required this.evento});

  @override
  State<TarjetasAdmin> createState() => _TarjetasAdminState();
}

class _TarjetasAdminState extends State<TarjetasAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 200.0,
        child: Card(
          color: Color(0xFF40215e),
          child: ListView(
            shrinkWrap: true,
            children: [
              // Título
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.evento['titulo'] ?? '',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFaca6a2)),
                  ),
                ),
              ),
              // Imagen
              AspectRatio(
                aspectRatio: 15 / 5,
                child: Image.asset(
                  'assets/images/imagen.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              // Boton
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      MdiIcons.pencilBox,
                      size: 50,
                      color: Color(0xFF49c2ee),
                    ),
                    onPressed: () {},
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      MdiIcons.trashCan,
                      size: 50,
                      color: Color(0xFFcb769b),
                    ),
                    onPressed: () {
                      print('apretao');
                      FirestoreServices().eventoBorrar(widget.evento.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
