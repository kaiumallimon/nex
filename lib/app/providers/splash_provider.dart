import 'package:flutter/cupertino.dart';
import 'package:nex/app/views/pages/login_page.dart';
import 'package:nex/app/views/pages/wrapper_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashProvider extends ChangeNotifier {
  void goNextPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    final isLoggedIn = Supabase.instance.client.auth.currentUser != null;

    debugPrint('Is Logged In: $isLoggedIn');
    debugPrint('Current User: ${Supabase.instance.client.auth.currentUser}');

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              isLoggedIn ? const WrapperPage() : const LoginPage(),
        ),
      );
    }
  }
}
