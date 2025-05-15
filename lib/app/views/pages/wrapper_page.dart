import 'package:flutter/material.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:nex/app/views/pages/chat_page.dart';
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
            physics: AlwaysScrollableScrollPhysics(),
            controller: wrapperProvider.pageController,
            reverse: true,
            scrollDirection: Axis.horizontal,
            children: [
              // chat page
              ChatPage(),

              // conversations list page
              ConversationsPage(),

              
            ],
          );
        },
      ),
    );
  }
}

