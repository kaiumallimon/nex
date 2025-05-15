import 'package:flutter/material.dart';
import 'package:nex/app/providers/register_provider.dart';
import 'package:nex/app/views/widgets/app_logo.dart';
import 'package:nex/app/views/widgets/custom_button.dart';
import 'package:nex/app/views/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the register provider
    final registerProvider = Provider.of<RegisterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(),
              const SizedBox(height: 20),
              Text(
                'Create an account',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                isReadOnly: registerProvider.isLoading,
                hintText: 'Name',
                controller: registerProvider.nameController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                isReadOnly: registerProvider.isLoading,
                hintText: 'Email',
                controller: registerProvider.emailController,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                isReadOnly: registerProvider.isLoading,
                hintText: 'Password',
                controller: registerProvider.passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomButton(
                isLoading: registerProvider.isLoading,
                text: 'Register',
                onPressed: () async {
                  await registerProvider.register(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
