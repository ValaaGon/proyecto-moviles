import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Pages/Admin/AgregarEvento.dart';
import 'package:gestion_eventos/Services/firestore-services.dart';
import 'package:gestion_eventos/Widgets/TarjetasAdmin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Administracion extends StatefulWidget {
  const Administracion({Key? key}) : super(key: key);

  @override
  _AdministracionState createState() => _AdministracionState();
}

class _AdministracionState extends State<Administracion> {
  final ScrollController _scrollController = ScrollController();
  bool _showDebugBanner = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    setState(() {
      _showDebugBanner = _scrollController.offset <= 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: _showDebugBanner,
      home: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            buildSliverAppBar(),
            buildSliverToBoxAdapter(),
          ],
        ),
        //boton agregar
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFaca6a2),
          child: Icon(
            Icons.add,
            color: Color(0xFF40215e),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AgregarEvento();
                });
          },
        ),
      ),
    );
  }

  //apbar
  SliverAppBar buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      snap: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              color: Color(0xFF49c2ee),
            ),
          ),
          Positioned(
            left: 16.0,
            bottom: 16.0,
            child: Row(
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                      color: Color(0xFF40215e),
                      width: 8.0,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/user.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correo electronico',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Administrador',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(MdiIcons.dotsVertical),
        ),
      ],
    );
  }

//contenido
  SliverToBoxAdapter buildSliverToBoxAdapter() {
    return SliverToBoxAdapter(
      child: Container(
        height: 1000,
        child: Center(
          child: StreamBuilder(
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
                    return TarjetasAdmin(evento: evento);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
