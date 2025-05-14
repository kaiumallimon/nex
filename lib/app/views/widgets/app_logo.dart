import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'N',
        style: TextStyle(
          color: Theme.of(context).primaryColorDark,
          fontSize: 35,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'ex',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark.withOpacity(.5),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
