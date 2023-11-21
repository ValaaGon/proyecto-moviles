import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
    return Builder(builder: (context) {
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
              Row(
                children: [
                  Text(
                    'Fecha',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${formatoFecha.format(widget.evento['fecha'].toDate())} | ${formatoHora.format(widget.evento['fecha'].toDate())}",
                  ),
                ],
              ),
              //LIKES
              Row(
                children: [
                  Text(
                    'Like',
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
              //ESTADO
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Estado',
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
                  onPressed: () {
                    final eventoRef = FirebaseFirestore.instance
                        .collection('Eventos')
                        .doc(widget.evento.id);
                    eventoRef.update({'estado': estado});
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
