import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:nex/app/services/login_service.dart';
import 'package:nex/app/views/pages/login_page.dart';
import 'package:nex/app/views/pages/register_page.dart';
import 'package:nex/app/views/pages/wrapper_page.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginService loginService = LoginService();

  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      customDialog(context, 'Error', 'Please fill all the fields');
    }

    isLoading = true;
    notifyListeners();
    try {
      final response = await loginService.login(
        emailController.text,
        passwordController.text,
      );

      if (response['success']) {
        await Hive.openBox('user');
        await Hive.box('user').put('userProfile', response['userProfile']);

        clearFields();
        isLoading = false;
        notifyListeners();

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => const WrapperPage()),
          );
        }
      } else {
        if (context.mounted) {
          customDialog(context, 'Error', response['message']);
        }
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      if (context.mounted) {
        customDialog(context, 'Error', error.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void goToRegisterPage(BuildContext context) {
    if (context.mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const RegisterPage()),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    Supabase.instance.client.auth.signOut();
    await Hive.openBox('user');
    await Hive.box('user').clear();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
