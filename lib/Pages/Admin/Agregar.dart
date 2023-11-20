import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Services/select_image.dart';
import 'package:gestion_eventos/Services/upload.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Agregar extends StatefulWidget {
  const Agregar({Key? key}) : super(key: key);

  @override
  State<Agregar> createState() => _AgregarState();
}

class _AgregarState extends State<Agregar> {
  final formKey = GlobalKey<FormState>();
  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController detallesCtrl = TextEditingController();
  DateTime fecha_desarrollo = DateTime.now();
  final formatoFecha = DateFormat('dd-MM-yyyy');

  String estado = "D";
  int like = 0;

  File? imagen_subir;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Evento'),
        backgroundColor: Color(0xFF20d7c8),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //titulo
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
                    //detalles
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
                    //fecha
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text('Fecha de evento: '),
                          Text(
                            formatoFecha.format(fecha_desarrollo),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(MdiIcons.calendar),
                            onPressed: () {
                              print('Seleccionar fecha');
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
                    ),
                    //Subir imagen
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () async {
                          final imagen = await getImage();
                          setState(() {
                            imagen_subir = File(imagen!.path);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(MdiIcons.cameraBurst),
                            Text(' Seleccionar imagen'),
                          ],
                        ),
                      ),
                    ),
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
                              // Subir la imagen
                              final uploaded = await upload(imagen_subir!);
                              print('Imagen subida con éxito: $uploaded');

                              // Enviar el evento
                              FirestoreServices().eventoAgregar(
                                tituloCtrl.text.trim(),
                                detallesCtrl.text.trim(),
                                like,
                                fecha_desarrollo,
                                estado,
                              );

                              // Cerrar la pantalla actual
                              Navigator.pop(context);
                            } catch (error) {
                              print('Error al subir la imagen: $error');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al subir la imagen'),
                                ),
                              );
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
            //boton subir
          ],
        ),
      ),
    );
  }
}
