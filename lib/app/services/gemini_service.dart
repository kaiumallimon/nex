import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static final String _apiKey =
      dotenv.env['GEMINI_API_KEY'] ?? ''; // Replace with your actual key
  static const String _systemInstruction = '''
You are a helpful AI assistant.
Your name is Nex.
Your responses should be:
- Clear and concise
- Accurate and informative
- Professional yet friendly
- Helpful while maintaining appropriate boundaries
''';

  Future<Map<String, dynamic>> generateResponse(
    List<Map<String, String>> chatHistory,
    String newMessage,
  ) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/models/gemini-2.0-flash:generateContent?key=$_apiKey',
      );

      final headers = {'Content-Type': 'application/json'};

      // Keep last 5 messages as context
      final recentHistory =
          chatHistory.length > 5
              ? chatHistory.sublist(chatHistory.length - 5)
              : chatHistory;

      final body = jsonEncode({
        "systemInstruction": {
          "parts": [
            {"text": _systemInstruction},
          ],
        },
        "contents": [
          ...recentHistory.map(
            (message) => {
              "role": message['role'],
              "parts": [
                {"text": message['content']},
              ],
            },
          ),
          {
            "role": "user",
            "parts": [
              {"text": newMessage},
            ],
          },
        ],
        "generationConfig": {"maxOutputTokens": 2000},
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
        return {
          'success': true,
          'message': 'Response generated successfully',
          'data': aiResponse,
        };
      } else {
        return {
          'success': false,
          'message':
              'Failed to generate response: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error calling Gemini API: $e'};
    }
  }
}
