import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nex/app/models/conversation_model.dart';
import 'package:nex/app/models/message_model.dart';
import 'package:nex/app/providers/conversation_provider.dart';
import 'package:nex/app/services/chat_service.dart';
import 'package:nex/app/services/conversation_service.dart';
import 'package:nex/app/services/gemini_service.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Map<String, String>> _chatHistory = [];
  Conversation? _currentConversation;

  List<Message> get messages => _messages;
  List<Map<String, String>> get chatHistory => _chatHistory;
  Conversation? get currentConversation => _currentConversation;

  List<Message> dummyMessages = [
    Message(
      id: '1',
      conversationId: '1',
      sender: 'user',
      content: 'Hello, how are you?',
      responseType: 'text',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),

    Message(
      id: '2',
      conversationId: '1',
      sender: 'model',
      content:
          'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
      responseType: 'text',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final TextEditingController messageController = TextEditingController();
  bool _isSending = false;
  bool get isSending => _isSending;

  final ChatService _chatService = ChatService();
  final GeminiService _geminiService = GeminiService();
  final ConversationService _conversationService = ConversationService();

  // Update chat history with latest 5 messages
  void _updateChatHistory() {
    if (_messages.isEmpty) return;

    // Sort messages by created_at in descending order and get last 5
    final latestMessages = List<Message>.from(_messages)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Take only the last 5 messages
    final last5Messages = latestMessages.take(5).toList();

    // Reverse the list to maintain chronological order for the API
    last5Messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Convert to chat history format
    _chatHistory = last5Messages.map((msg) => {
      'role': msg.sender == 'user' ? 'user' : 'assistant',
      'content': msg.content,
    }).toList();

    debugPrint('Chat history updated with ${_chatHistory.length} messages');
    for (final msg in _chatHistory) {
      final content = msg['content'] ?? '';
      debugPrint('${msg['role']}: ${content.substring(0, min(50, content.length))}...');
    }
  }

  // Set current conversation and load its messages
  Future<void> setCurrentConversation(
    Conversation conversation,
    BuildContext context,
  ) async {
    _currentConversation = conversation;
    await loadMessages(context);
    notifyListeners();
  }

  // Clear current conversation
  void clearCurrentConversation() {
    _currentConversation = null;
    _messages.clear();
    _chatHistory.clear();
    notifyListeners();
  }

  // Load messages for current conversation
  Future<void> loadMessages(BuildContext context) async {
    if (_currentConversation == null) {
      _messages.clear();
      _chatHistory.clear();
      notifyListeners();
      return;
    }

    try {
      final response = await _chatService.getMessages(_currentConversation!.id);

      if (!response['success']) {
        if (context.mounted) {
          customDialog(context, "Error", response['message']);
        }
        return;
      }

      _messages = response['data'];
      _updateChatHistory(); // Update chat history with latest 5 messages
      notifyListeners();
    } catch (e) {
      if (context.mounted) {
        customDialog(context, "Error", e.toString());
      }
    }
  }

  Future<void> sendMessage(BuildContext context) async {
    try {
      if (messageController.text.isEmpty) {
        if (context.mounted) {
          customDialog(context, "Error", "Message cannot be empty");
        }
        return;
      }

      _isSending = true;
      notifyListeners();

      String messageContent = messageController.text;
      messageController.clear();

      // Create a new conversation if none exists
      if (_currentConversation == null) {
        final userId = Supabase.instance.client.auth.currentUser!.id;
        final newConversation = Conversation(
          id: '', // Will be set by database
          userId: userId,
          title:
              messageContent.length > 50
                  ? '${messageContent.substring(0, 47)}...'
                  : messageContent,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final conversationResponse = await _conversationService
            .createConversation(newConversation);
        if (!conversationResponse['success']) {
          if (context.mounted) {
            customDialog(context, "Error", conversationResponse['message']);
          }
          return;
        }

        _currentConversation = Conversation.fromJson(
          conversationResponse['data'][0],
        );
        Provider.of<ConversationProvider>(
          context,
          listen: false,
        ).addConversation(_currentConversation!);
        notifyListeners();
      }

      // Create the user message
      final userMessage = Message.fromJson({
        'conversation_id': _currentConversation!.id,
        'sender': 'user',
        'content': messageContent,
        'response_type': 'text',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Add user message to local list
      _messages.add(userMessage);
      _updateChatHistory(); // Update chat history with latest 5 messages
      notifyListeners();

      // Store user message in database
      final response = await _chatService.storeMessageInDatabase(userMessage);

      if (!response['success']) {
        _messages.removeLast();
        _updateChatHistory(); // Update chat history after removing message
        notifyListeners();

        if (context.mounted) {
          customDialog(context, "Error", response['message']);
        }
        return;
      }

      // Generate AI response using latest chat history
      final aiResponse = await _geminiService.generateResponse(
        _chatHistory,
        messageContent,
      );

      if (aiResponse['success']) {
        // Create the AI message
        final aiMessage = Message.fromJson({
          'conversation_id': _currentConversation!.id,
          'sender': 'model',
          'content': aiResponse['data'],
          'response_type': 'text',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Add AI message to local list
        _messages.add(aiMessage);
        _updateChatHistory(); // Update chat history with latest 5 messages
        notifyListeners();

        // Store AI message in database
        await _chatService.storeMessageInDatabase(aiMessage);

        // Update conversation title if it's the first message
        if (_messages.length == 2) {
          _currentConversation = _currentConversation!.copyWith(
            title:
                messageContent.length > 50
                    ? '${messageContent.substring(0, 47)}...'
                    : messageContent,
          );
          await _conversationService.updateConversation(_currentConversation!);
          notifyListeners();
        }
      } else {
        if (context.mounted) {
          customDialog(context, "Error", aiResponse['message']);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        customDialog(context, "Error", e.toString());
      }
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    _chatHistory.clear();
    notifyListeners();
  }
}
