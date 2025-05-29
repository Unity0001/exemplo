import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatelessWidget {
  final String nome;
  final String email;

  DrawerWidget({required this.nome, required this.email});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            accountName: Text(
              nome,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              email,
              style: GoogleFonts.quicksand(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                nome.isNotEmpty ? nome[0].toUpperCase() : '',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.houseChimneyUser),
            title: Text(
              'Ínicio',
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/menuScreen');
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.arrowLeftLong),
            title: Text(
              'Sair',
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirmar saída',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    content: Text(
                      'Tem certeza que deseja sair? Será necessário efetuar o login novamente.',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.w800),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w800),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Sair',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.w800),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.pushNamed(context, '/');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
