import 'package:flutter/widgets.dart';
import 'package:nex/app/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  Future<Map<String, dynamic>> storeMessageInDatabase(Message message) async {
    try {
      var response = await Supabase.instance.client
          .from('messages')
          .insert(message.toJson())
          .select();

      debugPrint(response.toString());

      return {
        'success': true,
        'message': 'Message stored in database',
        'data': response,
      };
    } catch (e) {
      return {'success': false, 'message': "Error storing message in storeMessageInDatabase ${e.toString()}"};
    }
  }

  Future<Map<String, dynamic>> getMessages(String conversationId) async {
    try {
      final response = await Supabase.instance.client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      final messages = (response as List).map((json) => Message.fromJson(json)).toList();

      return {
        'success': true,
        'message': 'Messages fetched successfully',
        'data': messages,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error fetching messages: ${e.toString()}',
      };
    }
  }
}
