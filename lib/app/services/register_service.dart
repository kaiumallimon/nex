import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterService {
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // First, check if email already exists in profiles
      final existingProfile =
          await Supabase.instance.client
              .from('profiles')
              .select('id') // Limit selection to avoid large data
              .eq('email', email)
              .maybeSingle();

      if (existingProfile != null) {
        return {'success': false, 'message': 'Email already registered'};
      }

      // Sign up user
      final AuthResponse authResponse = await Supabase.instance.client.auth
          .signUp(email: email, password: password);

      final User? user = authResponse.user;

      if (user == null) {
        return {
          'success': false,
          'message': 'Registration failed: User not created',
        };
      }

      debugPrint('User created: ${user.id}');
      // debugPrint(
      //   'Session: ${authResponse.session?.accessToken ?? "No session returned"}',
      // );

      // debugPrint('User created: ${user.id}');
      // debugPrint('User email: ${authResponse.session!}');

      // Create user profile
      final now = DateTime.now().toIso8601String();
      final profileInsertResponse =
          await Supabase.instance.client
              .from('profiles')
              .insert({
                'id': user.id,
                'username': name.split(' ').first.toLowerCase(),
                'full_name': name,
                'email': email,
                'created_at': now,
                'updated_at': now,
              })
              .select()
              .single();

      return {
        'success': true,
        'message': 'Registration successful',
        'data': profileInsertResponse,
      };
    } on AuthException catch (e) {
      debugPrint('Auth Error Details: ${e.message}');
      return {
        'success': false,
        'message': 'Authentication error: ${e.message}',
      };
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }
}
