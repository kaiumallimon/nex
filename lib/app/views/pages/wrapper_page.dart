import 'package:flutter/material.dart';
import 'package:nex/app/providers/login_provider.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Nex'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, World!'),
            TextButton(
              onPressed: () {
                loginProvider.logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}