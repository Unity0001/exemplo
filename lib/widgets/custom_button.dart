import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final IconData? icon;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = GoogleFonts.quicksand(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: textStyle ?? defaultTextStyle,
                  ),
                ],
              )
            : Text(
                text,
                style: textStyle ?? defaultTextStyle,
              ),
      ),
    );
  }
}
