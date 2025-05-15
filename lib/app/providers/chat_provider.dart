import 'package:flutter/material.dart';
import 'package:nex/app/models/message_model.dart';
import 'package:nex/app/services/chat_service.dart';
import 'package:nex/app/services/gemini_service.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _messages = [];
  List<Map<String, String>> _chatHistory = [];

  List<Message> get messages => _messages;
  List<Map<String, String>> get chatHistory => _chatHistory;

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

  void addMessage(Message message) {
    _messages.add(message);
  }

  final TextEditingController messageController = TextEditingController();

  bool _isSending = false;

  bool get isSending => _isSending;

  final ChatService _chatService = ChatService();
  final GeminiService _geminiService = GeminiService();

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

      // Create the user message
      final userMessage = Message.fromJson({
        'conversation_id': 'b350f8f4-b3be-4a3c-8f23-0febd2dde949',
        'sender': 'user',
        'content': messageContent,
        'response_type': 'text',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Add user message to local list and history
      _messages.add(userMessage);
      _chatHistory.add({
        'role': 'user',
        'content': messageContent,
      });
      notifyListeners();

      // Store user message in database
      final response = await _chatService.storeMessageInDatabase(userMessage);

      if (!response['success']) {
        _messages.removeLast();
        _chatHistory.removeLast();
        notifyListeners();
        
        if (context.mounted) {
          customDialog(context, "Error", response['message']);
        }
        return;
      }

      // Generate AI response
      final aiResponse = await _geminiService.generateResponse(_chatHistory, messageContent);

      if (aiResponse['success']) {
        // Create the AI message
        final aiMessage = Message.fromJson({
          'conversation_id': 'b350f8f4-b3be-4a3c-8f23-0febd2dde949',
          'sender': 'model',
          'content': aiResponse['data'],
          'response_type': 'text',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // Add AI message to local list and history
        _messages.add(aiMessage);
        _chatHistory.add({
          'role': 'assistant',
          'content': aiResponse['data'],
        });
        notifyListeners();

        // Store AI message in database
        await _chatService.storeMessageInDatabase(aiMessage);
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
