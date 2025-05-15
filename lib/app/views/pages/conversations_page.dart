import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nex/app/providers/chat_provider.dart';
import 'package:nex/app/providers/conversation_provider.dart';
import 'package:nex/app/providers/login_provider.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:provider/provider.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).splashColor, width: 2),
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// search bar and new chat button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).splashColor,
                            border: InputBorder.none,
                            hintText: 'Search',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              gapPadding: 0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 0,
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              gapPadding: 0,
                            ),

                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Clear current conversation when starting new chat
                        context.read<ChatProvider>().clearCurrentConversation();
                        context.read<WrapperProvider>().setCurrentIndex(1);
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),

              /// chats placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Chats',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),

              /// Conversations list:
              Expanded(
                child: Consumer2<ConversationProvider, ChatProvider>(
                  builder: (
                    context,
                    conversationProvider,
                    chatProvider,
                    child,
                  ) {
                    // Call fetch once here
                    Future.microtask(
                      () => conversationProvider.fetchConversations(context),
                    );

                    return conversationProvider.isLoading
                        ? Center(
                          child: CupertinoActivityIndicator(
                            radius: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                        : ListView.builder(
                          itemCount: conversationProvider.conversations.length,
                          itemBuilder: (context, index) {
                            final convo =
                                conversationProvider.conversations[index];
                            final isSelected =
                                chatProvider.currentConversation?.id ==
                                convo.id;

                            return InkWell(
                              onTap: () {
                                chatProvider.setCurrentConversation(
                                  convo,
                                  context,
                                );
                                context.read<WrapperProvider>().setCurrentIndex(
                                  0,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                  horizontal: 20,
                                ),
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.1)
                                          : null,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        convo.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right, size: 20),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                  },
                ),
              ),

              /// Profile section:
              Consumer<ConversationProvider>(
                builder: (context, conversationProvider, child) {
                  Future.microtask(
                    () => conversationProvider.fetchProfileData(context),
                  );

                  final profile = conversationProvider.profile;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).splashColor,
                          width: 2,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColorLight,
                          child: const Icon(Icons.person, size: 20),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.fullName ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                profile?.email ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                title: Text('Logout'),
                                content: Text('Are you sure you want to logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Provider.of<LoginProvider>(context, listen: false).logout(context);
                                    },
                                    child: Text(
                                      'Logout',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            size: 25,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
