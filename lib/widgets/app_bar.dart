import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const AppBarWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[700],
      centerTitle: true,

      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.maybeOf(context)?.openDrawer();
        },
      ),

      title: Image.asset('assets/images/logoAndText.png', height: 40),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}