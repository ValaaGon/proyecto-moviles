import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class TarjetaEvento extends StatefulWidget {
  final DocumentSnapshot evento;

  TarjetaEvento({
    required this.evento,
  });

  @override
  State<TarjetaEvento> createState() => _TarjetaEventoState();
}

//destacar proximos eventos
bool esFechaProxima(DateTime fechaEvento) {
  final hoy = DateTime.now();
  final diferenciaDias = fechaEvento.difference(hoy).inDays;
  return diferenciaDias >= 0 && diferenciaDias <= 3;
}

class _TarjetaEventoState extends State<TarjetaEvento> {
  final formatoFecha = DateFormat('dd-MM-yyyy');
  final formatoHora = DateFormat('HH:mm');

  bool leGusta = false;
//likes
  void actualizarLikes(String eventoId, bool nuevoLike) async {
    try {
      final eventoRef =
          FirebaseFirestore.instance.collection('Eventos').doc(eventoId);

      if (nuevoLike) {
        await eventoRef.update({'like': FieldValue.increment(1)});
      } else {
        await eventoRef.update({'like': FieldValue.increment(-1)});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaEvento = widget.evento['fecha'].toDate();
    final muestraEstrella = esFechaProxima(fechaEvento);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Color(0xFFaca6a2),
        child: InkWell(
          onTap: () {
            mostrarInfo(context, widget.evento);
          },
          //imagen
          child: Container(
            height: 200,
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 8 / 5,
                  child: Image(
                    image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/proyectoappmov-e5aab.appspot.com/o/imagenesEvento%2F${this.widget.evento['foto']}?alt=media&token=4a5fe4d1-949a-4c54-87a6-d956ebf4ff19',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                // Likes
                ListTile(
                  leading: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          leGusta = !leGusta;
                        });
                        actualizarLikes(widget.evento.id, leGusta);
                      },
                      child: Column(
                        children: [
                          Icon(
                            leGusta ? MdiIcons.heart : MdiIcons.heartOutline,
                            color: leGusta
                                ? Color.fromARGB(255, 190, 71, 123)
                                : null,
                          ),
                          Text(widget.evento['like'] != null
                              ? widget.evento['like'].toString()
                              : ''),
                        ],
                      ),
                    ),
                  ),
                  // Marca
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.evento['titulo'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (muestraEstrella)
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                    ],
                  ),
                ),
              ],
            ),
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
                        //Titulo Detallas
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
                        //Titulo tipo
                        children: [
                          Icon(
                            MdiIcons.bullhorn,
                            color: Color(0xFFaca6a2),
                          ),
                          Text(
                            ' Tipo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFaca6a2)),
                          ),
                        ],
                      ),
                      //detalles tipo
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Text(
                          evento['tipo'],
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFFaca6a2)),
                        ),
                      ),
                      Row(
                        //Titulo fecha
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
                      //detalles fecha
                      Container(
                        margin: EdgeInsets.only(left: 30.0),
                        child: Column(
                          children: [
                            Text(
                              "${formatoFecha.format(widget.evento['fecha'].toDate())} | ${formatoHora.format(widget.evento['fecha'].toDate())} hrs",
                              style: TextStyle(color: Color(0xFFaca6a2)),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        //Lugar
                        children: [
                          Icon(
                            MdiIcons.mapMarker,
                            color: Color(0xFFaca6a2),
                          ),
                          Text(
                            ' Lugar : ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFaca6a2)),
                          ),
                          Text(
                            widget.evento['lugar'],
                            style: TextStyle(color: Color(0xFFaca6a2)),
                          )
                        ],
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
                        backgroundColor: Color(0xFFcb769b)),
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
