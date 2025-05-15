import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nex/app/models/conversation_model.dart';

class ConversationService {
  /// get conversations
  Future<Map<String, dynamic>> getConversations(String userId) async {
    try {
      final conversationResponse = await Supabase.instance.client
          .from('conversations')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      // parse to the model:
      final conversations =
          (conversationResponse as List)
              .map((json) => Conversation.fromJson(json))
              .toList();

      return {
        'success': true,
        'message': 'Conversations fetched successfully',
        'data': conversations,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // create conversation
  Future<Map<String, dynamic>> createConversation(Conversation conversation) async {
    try {
      final conversationResponse = await Supabase.instance.client
          .from('conversations')
          .insert(conversation.toJson())
          .select();

      return {
        'success': true,
        'message': 'Conversation created successfully',
        'data': conversationResponse,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // update conversation
  Future<Map<String, dynamic>> updateConversation(Conversation conversation) async {
    try {
      final conversationResponse = await Supabase.instance.client
          .from('conversations')
          .update(conversation.toJson())
          .eq('id', conversation.id)
          .select();

      return {
        'success': true,
        'message': 'Conversation updated successfully',
        'data': conversationResponse,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
