import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.primary,
    this.secondary,
  });

  final Color? primary;
  final Color? secondary;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: primary?? Theme.of(context).primaryColorDark,
          fontSize: 35,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'ex',
            style: TextStyle(
              color: secondary ?? Theme.of(context).primaryColorDark.withOpacity(.5),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
