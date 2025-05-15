import 'package:flutter/widgets.dart';
import 'package:nex/app/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatService {
  Future<Map<String, dynamic>> storeMessageInDatabase(Message message) async {
    try {
      var response = await Supabase.instance.client
          .from('messages')
          .insert(message.toJson());

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
}
