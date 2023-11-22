import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Widgets/EditarAdmin.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TarjetasAdmin extends StatefulWidget {
  final QueryDocumentSnapshot evento;

  TarjetasAdmin({required this.evento});

  @override
  State<TarjetasAdmin> createState() => _TarjetasAdminState();
}

class _TarjetasAdminState extends State<TarjetasAdmin> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      key: scaffoldKey,
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
                /*
                child: Image.network(
                  widget.evento['foto'],
                  fit: BoxFit.cover,
                ),*/
              ),
              // Boton editar
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      MdiIcons.pencilBox,
                      size: 50,
                      color: Color(0xFF49c2ee),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return EditarAdmin(evento: widget.evento);
                          });
                    },
                  ),
                  Spacer(),
                  //Boton borrar
                  IconButton(
                    icon: Icon(
                      MdiIcons.trashCan,
                      size: 50,
                      color: Color(0xFFcb769b),
                    ),
                    onPressed: () {
                      confiDialog(widget.evento).then((confiBorrado) {
                        if (confiBorrado != null && confiBorrado) {
                          setState(() {
                            FirestoreServices()
                                .eventoBorrar(widget.evento.id)
                                .then((exito) {
                              if (exito = true) {
                                print('borrado');
                              } else {
                                //
                              }
                            });
                          });
                        }
                      });
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

  //dialogo de confirmar borrado
  Future<bool?> confiDialog(QueryDocumentSnapshot evento) {
    return showDialog<bool?>(
      barrierDismissible: false,
      context: scaffoldKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Borrado'),
          content: Text(
              '¿Está seguro de que quiere borrar el evento ${evento['titulo']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Borrar'),
            )
          ],
        );
      },
    );
  }
}
