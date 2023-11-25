import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_eventos/Pages/Login/Login.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Widgets/TarjetasEvento.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  String estadoFiltro = "D";
//filtro
  void cambiarEstadoFiltro() {
    setState(() {
      estadoFiltro = (estadoFiltro == "D") ? "F" : "D";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(MdiIcons.arrowCollapseLeft, color: Color(0xFFaca6a2)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
        ),
        backgroundColor: Color(0xFF40215e),
        title: Text(
          'Gestion eventos Symphony',
          style: TextStyle(
            color: Color(0xFFaca6a2),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 200,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(8.0),
              //boton filtro
              child: DropdownButton<String>(
                style: TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Color(0xFF20d7c8),
                ),
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF40215e)),
                value: estadoFiltro,
                dropdownColor: Color(0xFF20d7c8),

                onChanged: (String? newValue) {
                  setState(() {
                    estadoFiltro = newValue!;
                  });
                },

                //botones filtro
                items: <String>['D', 'F']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirestoreServices().eventos(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar datos'));
                } else {
                  List<DocumentSnapshot> eventos = snapshot.data!.docs;
                  // Filtrar la lista según el estado seleccionado
                  List<DocumentSnapshot> eventosFiltrados = eventos
                      .where((evento) => evento['estado'] == estadoFiltro)
                      .toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemCount: eventosFiltrados.length,
                    itemBuilder: (BuildContext context, int index) {
                      var evento = eventosFiltrados[index];
                      return TarjetaEvento(evento: evento);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
