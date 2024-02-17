import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _preferredHeight = 100.0;

  final String title;
  final Color gradientBegin, gradientEnd;

  GradientAppBar({
    required this.title,
    required this.gradientBegin,
    required this.gradientEnd,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _preferredHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            gradientBegin,
            gradientEnd,
          ],
        ),
      ),
      child: Text(
  title,
  style: TextStyle(
    color: Colors.white,
    letterSpacing: 10.0,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    fontFamily: GoogleFonts.dancingScript().fontFamily, // Use the Dancing Script font
  ),
),

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_preferredHeight);
}
