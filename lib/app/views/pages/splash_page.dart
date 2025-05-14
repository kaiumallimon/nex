import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nex/app/providers/splash_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // get provider
    final splashProvider = Provider.of<SplashProvider>(context);

    // go to next page after 3 seconds
    splashProvider.goNextPage(context);

    return Scaffold(
      body: Center(
        child: RichText(
          text: TextSpan(
            text: 'N',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 75,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'ex',
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark.withOpacity(.5),
                  fontSize: 35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
