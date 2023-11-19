import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_eventos/Pages/Admin/administracion.dart';
import 'package:gestion_eventos/Pages/Login/InicioSesion.dart';
import 'package:gestion_eventos/Pages/Publico/Principal.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF40215e), Color(0xFF20d7c8)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 150.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //icono
              Image.asset(
                'assets/images/icono.png',
                height: 100,
                width: 100,
                alignment: Alignment.bottomCenter,
              ),
              //titulo
              Text(
                'BIENVENID@!',
                style: TextStyle(
                  fontSize: 40.0,
                  color: Color.fromARGB(255, 29, 14, 43),
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 80.0,
                    padding: EdgeInsets.all(12.0),
                    //boton google
                    child: ElevatedButton(
                      onPressed: () async {
                        await inicioSesion();
                        if (FirebaseAuth.instance.currentUser != null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Administracion()),
                              (Route<dynamic> route) => false);
                        }
                      },
                      child: Text(
                        'Iniciar sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    height: 80.0,
                    padding: EdgeInsets.all(12.0),
                    //boton invitados
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Principal()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFcb769b),
                      ),
                      child: Text(
                        'Ingresar como invitado',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          //imagen de abajo
          Image.asset(
            'assets/images/personas.png',
            height: 350,
            width: 350,
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
