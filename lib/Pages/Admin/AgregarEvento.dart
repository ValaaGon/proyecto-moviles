import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Services/select_image.dart';
import 'package:gestion_eventos/Services/upload.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgregarEvento extends StatefulWidget {
  const AgregarEvento({super.key});

  @override
  State<AgregarEvento> createState() => _AgregarEventoState();
}

class _AgregarEventoState extends State<AgregarEvento> {
  final formKey = GlobalKey<FormState>();
  //controllers
  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();
  TextEditingController detallesCtrl = TextEditingController();
  //formatos fecha
  DateTime fecha_desarrollo = DateTime.now();
  final formatoFecha = DateFormat('dd-MM-yyyy');
//campos por default
  String estado = "D";
  String tipo = "";
  int like = 0;

  File? imagen_subir;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        title: Text('Agregar eventos'),
        content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                //Ingresar titulo del evento
                TextFormField(
                  controller: tituloCtrl,
                  decoration: InputDecoration(
                    label: Text('Titulo'),
                  ),
                  validator: (titulo) {
                    if (titulo!.isEmpty) {
                      return 'Ingrese un titulo';
                    }
                    if (titulo.length < 3) {
                      return 'Titulo muy corto';
                    }
                    return null;
                  },
                ),
                //Ingresar detalles del evento
                TextFormField(
                  controller: detallesCtrl,
                  decoration: InputDecoration(
                    label: Text('Detalles'),
                  ),
                  validator: (detalles) {
                    if (detalles!.isEmpty) {
                      return 'Ingrese detalles';
                    }
                    if (detalles.length < 50) {
                      return 'Este campo debe tener al menos 50 caracteres';
                    }
                    return null;
                  },
                ),
                //Ingresar lugar de desarrollo
                TextFormField(
                  controller: lugarCtrl,
                  decoration: InputDecoration(
                    label: Text('Lugar'),
                  ),
                  validator: (detalles) {
                    if (detalles!.isEmpty) {
                      return 'Ingrese lugar';
                    }
                    if (detalles.length < 5) {
                      return 'Texto muy corto';
                    }
                    return null;
                  },
                ),
                //Seleccionar fecha
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Fecha de evento: '),
                          Spacer(),
                          IconButton(
                            icon: Icon(MdiIcons.calendar),
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2024),
                                locale: Locale('es', 'ES'),
                              ).then((fecha) {
                                setState(() {
                                  fecha_desarrollo = fecha ?? fecha_desarrollo;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                      Text(
                        formatoFecha.format(fecha_desarrollo),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                //Elegir tipo de evento

                FutureBuilder(
                  future: FirestoreServices().tiposEvento(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      var tipos = snapshot.data!.docs;
                      return DropdownButtonFormField<String>(
                        value: tipo == '' ? tipos[0]['tipo_evento'] : tipo,
                        decoration: InputDecoration(labelText: 'Tipo evento'),
                        items: tipos.map<DropdownMenuItem<String>>((tipo) {
                          return DropdownMenuItem<String>(
                              child: Text(tipo['tipo_evento']),
                              value: tipo['tipo_evento']);
                        }).toList(),
                        onChanged: (tipoSeleccionado) {
                          setState(() {
                            tipo = tipoSeleccionado!;
                          });
                        },
                      );
                    }
                  },
                ),
                //Subir imagen
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      final imagen = await getImage();
                      try {
                        setState(() {
                          imagen_subir = File(imagen!.path);
                        });
                        print(imagen_subir);
                      } catch (e) {
                        print('Error $e');
                      }
                    },
                    child: Row(
                      children: [
                        Icon(MdiIcons.cameraBurst),
                        Text(' Seleccionar imagen'),
                      ],
                    ),
                  ),
                ),
                //mostrar imagen seleccionada
                Container(
                  height: 200,
                  child: ClipRect(
                    child: imagen_subir != null
                        ? Image.file(imagen_subir!, fit: BoxFit.cover)
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Color(0xFFaca6a2),
                              child: Center(
                                child: Icon(MdiIcons.panorama, size: 40),
                              ),
                            ),
                          ),
                  ),
                ),
                Spacer(),
                //Boton agregar
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (imagen_subir == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Seleccione una imagen.'),
                            ),
                          );
                          return;
                        }

                        try {
                          final uploaded = await upload(imagen_subir!);
                          print('Imagen subida con éxito: $uploaded');
                          //actualizacion de bd
                          FirestoreServices().eventoAgregar(
                            detallesCtrl.text.trim(),
                            estado,
                            like,
                            fecha_desarrollo,
                            tituloCtrl.text.trim(),
                            tipo,
                            lugarCtrl.text.trim(),
                            uploaded.toString(),
                          );
                          setState(() {
                            Navigator.pop(context);
                          });
                        } catch (error) {
                          print('Error al subir la imagen: $error');
                        }
                      }
                    },
                    child: Text('Ingresar evento'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
