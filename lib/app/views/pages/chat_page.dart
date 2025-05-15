import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nex/app/providers/chat_provider.dart';
import 'package:nex/app/providers/wrapper_provider.dart';
import 'package:nex/app/views/widgets/app_logo.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    // Listen to messages changes and scroll to bottom
    if (chatProvider.messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // topbar
            Container(
              decoration: BoxDecoration(
                // color: Theme.of(context).primaryColorLight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     Provider.of<WrapperProvider>(
                  //       context,
                  //       listen: false,
                  //     ).setCurrentIndex(1);
                  //   },
                  //   icon: Icon(
                  //     Icons.menu,
                  //     color: Theme.of(context).primaryColor,
                  //   ),
                  // ),

                  AppLogo(
                    primary: Colors.black,
                    secondary: Theme.of(context).dividerColor,
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.chat_bubble_outline),
                  ),
                ],
              ),
            ),

            // chat messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'What can I help with?',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).shadowColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: Text(
                              'I can help you with your questions and concerns. Ask me anything, I\'m here to help! ',
                              textAlign: TextAlign.center,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withOpacity(.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: chatProvider.messages.length,
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 20,
                      top: 10,
                    ),
                    itemBuilder: (context, index) {
                      final message = chatProvider.messages[index];

                      return Align(
                        alignment:
                            message.sender == 'user'
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          constraints:
                              message.sender == 'user'
                                  ? BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * .7,
                                  )
                                  : null,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                message.sender == 'user'
                                    ? Theme.of(context).splashColor
                                    : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              message.sender == 'model'
                                  ? MarkdownBody(
                                    data: message.content,
                                    styleSheet: MarkdownStyleSheet(
                                      p: Theme.of(context).textTheme.bodyMedium,
                                      code: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        // backgroundColor: Theme.of(context).splashColor,
                                        fontFamily: 'monospace',
                                      ),
                                      codeblockDecoration: BoxDecoration(
                                        color: Theme.of(context).splashColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      codeblockPadding: const EdgeInsets.all(8),
                                      blockquote: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withOpacity(0.8),
                                        fontStyle: FontStyle.italic,
                                      ),
                                      blockquoteDecoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color:
                                                Theme.of(context).dividerColor,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      blockquotePadding: const EdgeInsets.only(
                                        left: 16,
                                      ),
                                    ),
                                  )
                                  : Text(message.content),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // chat input
            buildChatInput(context, chatProvider),
          ],
        ),
      ),
    );
  }

  Container buildChatInput(BuildContext context, ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .35,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).splashColor, width: 2),
        ),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).splashColor.withOpacity(.1),
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * .3,
                  ),
                  child: TextField(
                    controller: chatProvider.messageController,
                    readOnly: chatProvider.isSending,
                    expands: false,
                    maxLines: null,
                    onSubmitted:
                        chatProvider.isSending
                            ? null
                            : (_) async {
                              await chatProvider.sendMessage(context);
                            },
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: chatProvider.isSending ? null : () {},
                        icon: const Icon(Icons.photo),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            CircleBorder(
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: chatProvider.isSending ? null : () {},
                        icon: const Icon(Icons.mic),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            CircleBorder(
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).dividerColor.withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed:
                        chatProvider.isSending
                            ? null
                            : () async {
                              await chatProvider.sendMessage(context);
                            },
                    icon:
                        chatProvider.isSending
                            ? CupertinoActivityIndicator(
                              color: Theme.of(context).primaryColor,
                            )
                            : const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        chatProvider.isSending
                            ? Theme.of(context).splashColor
                            : Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all(const CircleBorder()),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
