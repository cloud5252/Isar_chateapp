import 'package:flutter/material.dart';
import 'package:isar_chateapp/Services/Isar_services/Isar_chat_service.dart';

import 'package:isar_chateapp/models/UserModel.dart';
import 'package:stacked/stacked.dart';

class UserChatViewModel extends BaseViewModel {
  String _chatRoomId = '';
  String get chatRoomId => _chatRoomId;

  Stream<List<ChatMessage>>? _cachedStream;
  Stream<List<ChatMessage>> get messagesStream {
    if (_chatRoomId.isEmpty) return const Stream.empty();
    _cachedStream ??= IsarChatService.watchChatMessages(_chatRoomId);
    return _cachedStream!;
  }

// UserChatViewModel.dart mein
  void updateChatRoomId(String id) {
    if (_chatRoomId == id) return;
    _chatRoomId = id;
    notifyListeners();
  }

  Future<void> initializeChatRoom(
      String currentUserId, String receiverId) async {
    setBusy(true);

    if (currentUserId.isEmpty || receiverId.isEmpty) {
      debugPrint("❌ IDs are empty!");
      setBusy(false);
      return;
    }

    try {
      await IsarChatService.getOrCreateChatRoom(
          currentUserId, receiverId);
    } catch (e) {
      debugPrint("Chat Room Error: $e");
    }

    setBusy(false);
    notifyListeners();
  }

  Future<void> sendMessage({
    required String senderId,
    required String senderEmail,
    required String receiverId,
    required String messageText,
    required TextEditingController controller,
  }) async {
    if (messageText.trim().isEmpty) return;
    controller.clear();

    // UI ko batayein ke naya message aa gaya hai
    notifyListeners();
    await IsarChatService.sendMessage(
      senderId: senderId,
      senderEmail: senderEmail,
      receiverId: receiverId,
      messageText: messageText,
    );
    // Notify karne ki zaroorat nahi kyunki StreamBuilder khud update hoga
  }
}
