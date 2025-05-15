import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nex/app/models/conversation_model.dart';
import 'package:nex/app/models/profile_model.dart';
import 'package:nex/app/services/conversation_service.dart';
import 'package:nex/app/views/widgets/custom_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversationProvider extends ChangeNotifier {
  final ConversationService _conversationService = ConversationService();

  List<Conversation> _conversations = [];
  bool _isLoading = false;
  bool _isInitialized = false;
  String _searchQuery = '';

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Filtered conversations based on search query
  List<Conversation> get filteredConversations {
    if (_searchQuery.isEmpty) return _conversations;
    return _conversations.where((conversation) =>
        conversation.title.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  // Method to update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchConversations(BuildContext context) async {
    if (_isInitialized) return; // prevent re-fetching
    _isInitialized = true;

    try {
      _isLoading = true;
      notifyListeners();

      final uid = Supabase.instance.client.auth.currentUser!.id;
      final response = await _conversationService.getConversations(uid);

      if (!response['success']) {
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          customDialog(context, "Error", response['message']);
        }
        return;
      }

      _conversations = response['data'];
    } catch (e) {
      if (context.mounted) {
        customDialog(context, "Error", e.toString());
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Profile? _profile;

  Profile? get profile => _profile;

  Future<void> fetchProfileData(BuildContext context) async {
    try {
      final profileBox = await Hive.openBox('user');
      final userProfile = profileBox.get('userProfile');
      
      if (userProfile != null) {
        _profile = Profile.fromJson(userProfile);
        notifyListeners();
      }
    } on Exception catch (e) {
      if (context.mounted) {
        customDialog(context, "Error", e.toString());
      }
    }
  }

  Conversation? _selectedConversation;

  Conversation? get selectedConversation => _selectedConversation;

  void addConversation(Conversation conversation) {
    _conversations.add(conversation);
    // sort by createdAt descending
    _conversations.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }
}
