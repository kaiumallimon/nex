import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nex/app/models/conversation_model.dart';

class ConversationService {
  /// get conversations
  Future<Map<String, dynamic>> getConversations(String userId) async {
    try {
      final conversationResponse = await Supabase.instance.client
          .from('conversations')
          .select()
          .eq('user_id', userId);

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
          .insert(conversation.toJson());

      return {
        'success': true,
        'message': 'Conversation created successfully',
        'data': conversationResponse,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
