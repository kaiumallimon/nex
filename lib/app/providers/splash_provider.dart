import 'package:flutter/cupertino.dart';
import 'package:nex/app/views/pages/login_page.dart';

class SplashProvider extends ChangeNotifier {
  void goNextPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
