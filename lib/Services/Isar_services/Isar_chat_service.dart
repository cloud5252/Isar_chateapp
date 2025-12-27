import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:isar_chateapp/models/UserModel.dart';
import 'package:isar_chateapp/Services/Isar_services/Isar_service.dart';

class IsarChatService {
  static Isar get isar => IsarService.isar;

  // ==================== USER OPERATIONS ====================

  static Stream<List<UserModel>> watchUsers() {
    return isar.userModels.where().watch(fireImmediately: true);
  }

  static Future<void> saveUser(UserModel user) async {
    await isar.writeTxn(() => isar.userModels.put(user));
  }

  // ======= ======== CHAT ROOM OPERATIONS ========= =======

  static Future<ChatRoom> getOrCreateChatRoom(
      String currentUserId, String otherUserId) async {
    final ids = [currentUserId, otherUserId]..sort();

    // Check if exists
    final existingRoom = await isar.chatRooms
        .where()
        .filter()
        .participant1IdEqualTo(ids[0])
        .and()
        .participant2IdEqualTo(ids[1])
        .findFirst();

    if (existingRoom != null) return existingRoom;

    // Create new if not exists
    final newRoom = ChatRoom()
      ..participant1Id = ids[0]
      ..participant2Id = ids[1]
      ..lastMessageTime = DateTime.now();

    await isar.writeTxn(() => isar.chatRooms.put(newRoom));
    return newRoom;
  }

  // ==================== MESSAGE OPERATIONS ====================

  static Future<void> sendMessage({
    required String senderEmail,
    required String senderId,
    required String receiverId,
    required String messageText,
  }) async {
    try {
      // 1. Pehle instance check karein
      final db = IsarService.isar;

      List<String> ids = [senderId, receiverId]..sort();
      String generatedRoomId = ids.join('_');

      final message = ChatMessage()
        ..chatRoomId = generatedRoomId
        ..senderId = senderId
        ..senderEmail = senderEmail
        ..receiverId = receiverId
        ..messageText = messageText
        ..timestamp = DateTime.now()
        ..isDelivered = true;

      await db.writeTxn(() async {
        await db.chatMessages.put(message);

        final chatRoom = await db.chatRooms
            .filter()
            .participant1IdEqualTo(ids[0])
            .and()
            .participant2IdEqualTo(ids[1])
            .findFirst();

        if (chatRoom != null) {
          chatRoom.lastMessage = messageText;
          chatRoom.lastMessageTime = DateTime.now();
          await db.chatRooms.put(chatRoom);
        }
      });

      debugPrint("✅ Message Sent Successfully!");
    } catch (e) {
      // Agar Isar ready nahi hoga toh yahan error print hoga, crash nahi
      debugPrint("❌ Send Message Failed: $e");
    }
  }

  static Stream<List<ChatMessage>> watchChatMessages(
      String chatRoomId) {
    return isar.chatMessages
        .filter()
        .chatRoomIdEqualTo(chatRoomId)
        .sortByTimestampDesc()
        .watch(fireImmediately: true);
  }

  static Future<int> getUnreadCount(
      String chatRoomId, String currentUserId) async {
    return await isar.chatMessages
        .filter()
        .chatRoomIdEqualTo(chatRoomId)
        .and()
        .receiverIdEqualTo(currentUserId)
        .and()
        .isReadEqualTo(false)
        .count();
  }
}
