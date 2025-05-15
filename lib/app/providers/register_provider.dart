import 'package:flutter/material.dart';
import 'package:nex/app/services/register_service.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';

class RegisterProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RegisterService registerService = RegisterService();
  bool isLoading = false;

  Future<void> register(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      customDialog(context, 'Error', 'Please fill all the fields');
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await registerService.registerUser(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );

      if (response.containsKey('data') &&
          response['data'] != null &&
          response['success']) {
        if (context.mounted) {
          customDialog(context, 'Success', response['message']);
          clearControllers();
          notifyListeners();
        }

        
      } else {
        if (context.mounted) {
          customDialog(context, 'Error', response['message']);
        }
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      if (context.mounted) {
        customDialog(context, 'Error', e.toString());
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
