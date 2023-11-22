import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditarAdmin extends StatefulWidget {
  final QueryDocumentSnapshot evento;
  EditarAdmin({required this.evento});

  @override
  State<EditarAdmin> createState() => _EditarAdminState();
}

class _EditarAdminState extends State<EditarAdmin> {
  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');
  String estado = "D";
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Informacion del evento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //DETALLES
              Row(
                children: [
                  Text(
                    widget.evento['titulo'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    'Detalles',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(widget.evento['detalles']),
              //FECHA
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Text(
                      'Fecha',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "${formatoFecha.format(widget.evento['fecha'].toDate())} | ${formatoHora.format(widget.evento['fecha'].toDate())} hrs",
                  ),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    'Lugar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(widget.evento['lugar']),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    'Tipo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(widget.evento['tipo']),
                ],
              ),
              Spacer(),
              //LIKES
              Row(
                children: [
                  Text(
                    'Likes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    MdiIcons.heart,
                    color: Color(0xFFcb769b),
                  ),
                  Text(widget.evento['like'].toString()),
                ],
              ),
              Spacer(),
              //ESTADO
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                            'Estado (${estado == 'D' ? 'Disponible' : 'Finalizado'})',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    RadioListTile(
                        title: Text('Disponible'),
                        value: 'D',
                        groupValue: estado,
                        onChanged: (estadoSelec) {
                          setState(() {
                            estado = estadoSelec!;
                          });
                        }),
                    RadioListTile(
                        title: Text('Finalizado'),
                        value: 'F',
                        groupValue: estado,
                        onChanged: (estadoSelec) {
                          setState(() {
                            estado = estadoSelec!;
                          });
                        })
                  ],
                ),
              ),
              //BOTON
              Spacer(),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    await FirestoreServices().actualizarEvento(
                        widget.evento.id,
                        estado,
                        widget.evento['detalles'],
                        widget.evento['fecha'].toDate(),
                        widget.evento['like'],
                        widget.evento['titulo']);
                    Navigator.pop(context);
                  },
                  child: Text('Actualizar'),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
