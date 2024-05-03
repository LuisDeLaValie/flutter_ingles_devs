import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrincipalLayout extends StatelessWidget {
  final Widget body;
  const PrincipalLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        // elevation: 10,
        foregroundColor: Color.fromRGBO(255, 255, 255, 1),
        surfaceTintColor: Color.fromRGBO(255, 255, 255, 1),
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        title: Padding(
          padding: const EdgeInsets.only(left: 156),
          child:
              Image.asset('assets/imgs/INGLES-PARA-DEVS_logo.png', width: 100),
        ),
      ),
      body: body,
    );
  }
}
