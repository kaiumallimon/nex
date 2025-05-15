import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      Supabase.instance.client.auth.startAutoRefresh();

      // fetch user profile
      final userProfile =
          await Supabase.instance.client
              .from('profiles')
              .select('*')
              .eq('id', response.user!.id)
              .single();

      debugPrint(userProfile.toString());

      return {
        'success': true,
        'message': 'Login successful',
        'session': response.session,
        'user': response.user,
        'userProfile': userProfile,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
