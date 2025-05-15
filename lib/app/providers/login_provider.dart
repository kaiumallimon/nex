import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:nex/app/services/login_service.dart';
import 'package:nex/app/views/pages/login_page.dart';
import 'package:nex/app/views/pages/register_page.dart';
import 'package:nex/app/views/pages/wrapper_page.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:nex/app/providers/splash_provider.dart';
import 'package:nex/app/providers/register_provider.dart';
import 'package:nex/app/providers/conversation_provider.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:nex/app/providers/chat_provider.dart';

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
    // Sign out from Supabase
    await Supabase.instance.client.auth.signOut();
    
    // Clear local storage
    await Hive.openBox('user');
    await Hive.box('user').clear();

    // First navigate to login page
    if (context.mounted) {
      // Clean up providers before navigation
      final wrapperProvider = Provider.of<WrapperProvider>(context, listen: false);
      final conversationProvider = Provider.of<ConversationProvider>(context, listen: false);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      final splashProvider = Provider.of<SplashProvider>(context, listen: false);
      final registerProvider = Provider.of<RegisterProvider>(context, listen: false);

      // Reset states before navigation
      wrapperProvider.reset();
      conversationProvider.reset();
      chatProvider.reset();
      
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginPage(),
        ),
      ).then((_) {
        // Dispose providers after navigation is complete
        if (context.mounted) {
          try {
            splashProvider.dispose();
            registerProvider.dispose();
            conversationProvider.dispose();
            wrapperProvider.dispose();
            chatProvider.dispose();
          } catch (e) {
            // Ignore disposal errors during transitions
          }
        }
      });
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
