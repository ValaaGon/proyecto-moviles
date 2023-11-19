import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class TarjetaEvento extends StatefulWidget {
  final QueryDocumentSnapshot evento;

  TarjetaEvento({required this.evento});

  @override
  State<TarjetaEvento> createState() => _TarjetaEventoState();
}

class _TarjetaEventoState extends State<TarjetaEvento> {
  final formatoFecha = DateFormat('dd-MM-yyyy');

  final formatoHora = DateFormat('HH:mm');

  bool leGusta = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Color(0xFFaca6a2),
        child: InkWell(
          onTap: () {
            mostrarInfo(context, widget.evento);
          },
          child: Column(
            //imagen
            children: [
              AspectRatio(
                aspectRatio: 15 / 9,
                child: Image.asset(
                  'assets/images/imagen.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              //Likes
              ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          leGusta = !leGusta;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            leGusta ? MdiIcons.heart : MdiIcons.heartOutline,
                            color: leGusta ? Color(0xFFcb769b) : null,
                          ),
                          Text(widget.evento['like'] != null
                              ? widget.evento['like'].toString()
                              : ''),
                        ],
                      ),
                    ),
                  ),
                  //nombre
                  title: Text(
                    widget.evento['titulo'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  //INFORMACION
  void mostrarInfo(BuildContext context, evento) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF40215e),
              border: Border.all(color: Color(0xFF40215e), width: 2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //titulo principal
                Container(
                  child: Text(evento['titulo'],
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFaca6a2))),
                ),
                //informacion
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        //titulo
                        children: [
                          Icon(
                            MdiIcons.information,
                            color: Color(0xFFaca6a2),
                          ),
                          Text(
                            ' Detalles',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFaca6a2)),
                          ),
                        ],
                      ),
                      //detalles
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Text(
                          '- ${evento['detalles']}',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFaca6a2)),
                        ),
                      ),
                      Row(
                        //titulo
                        children: [
                          Icon(
                            evento['estado'] == 'D'
                                ? Icons.check_circle_rounded
                                : Icons.cancel,
                            color: evento['estado'] == 'F'
                                ? Colors.red
                                : Colors.green,
                          ),
                          Text(
                            ' Estado',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFaca6a2)),
                          ),
                        ],
                      ),
                      //detalles
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Text(
                          evento['estado'] == 'F'
                              ? '- Finalizado'
                              : '- Proximo',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFaca6a2)),
                        ),
                      ),
                      Row(
                        //titulo
                        children: [
                          Icon(
                            MdiIcons.calendar,
                            color: Color(0xFFaca6a2),
                          ),
                          Text(
                            ' Fecha',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFaca6a2)),
                          ),
                        ],
                      ),
                      //detalles
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            Text(
                              formatoFecha.format(evento['fecha'].toDate()),
                              style: TextStyle(color: Color(0xFFaca6a2)),
                            ),
                            Text(
                              'hrs${formatoHora.format(evento['fecha'].toDate())}',
                              style: TextStyle(color: Color(0xFFaca6a2)),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //boton
                Spacer(),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color(0xFF20d7c8)),
                    child: Text(
                      'Cerrar',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
