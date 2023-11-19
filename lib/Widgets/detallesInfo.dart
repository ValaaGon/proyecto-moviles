import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class detallesInfo extends StatelessWidget {
  final Map<String, dynamic> evento;

  const detallesInfo({Key? key, required this.evento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            //titulo
            children: [
              Icon(MdiIcons.information),
              Text(
                ' Detalles',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          //detalles
          Container(
            margin: EdgeInsets.only(left: 30.0),
            child: Text(
              evento['detalles'],
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
