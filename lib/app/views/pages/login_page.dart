import 'package:flutter/material.dart';
import 'package:nex/app/providers/login_provider.dart';
import 'package:nex/app/views/widgets/app_logo.dart';
import 'package:nex/app/views/widgets/custom_button.dart';
import 'package:nex/app/views/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // get provider
    final loginProvider = Provider.of<LoginProvider>(context);

    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(),
            const SizedBox(height: 20),
            Text(
              'Login to your account',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),

            CustomTextField(
              hintText: 'Email',
              controller: loginProvider.emailController,
            ),

            const SizedBox(height: 10),

            CustomTextField(
              hintText: 'Password',
              controller: loginProvider.passwordController,
              isPassword: true,
            ),

            const SizedBox(height: 10),

            CustomButton(
              text: 'Login',
              isLoading: false,
              onPressed: () {
                loginProvider.login(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
