import 'package:flutter/material.dart';
import 'package:nex/app/providers/login_provider.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:nex/app/views/pages/conversations_page.dart';
import 'package:provider/provider.dart';

class WrapperPage extends StatelessWidget {
  const WrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WrapperProvider>(
        builder: (context, wrapperProvider, child) {
          return PageView(
            physics: BouncingScrollPhysics(),
            controller: wrapperProvider.pageController,
            // reverse: true,
            scrollDirection: Axis.horizontal,
            children: [
              // conversations list page
              ConversationsPage(),

              // chat page
              Scaffold(
                appBar: AppBar(title: Text('Chat')),
                body: Column(children: [Text('Chat')]),
              ),
            ],
          );
        },
      ),
    );
  }
}
