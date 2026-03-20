import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/modules/profile/controllers/profile_controller.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';

class ChatController extends GetxController {

  static ChatController get to => Get.put(ChatController(), permanent: true);
  final ProfileController profileController = Get.put(ProfileController());
  var isSending = false.obs;
  var isLoading = false.obs;
  final TextEditingController messageController = TextEditingController();
  var messages = <Map<String, dynamic>>[].obs;
  var chatUsers = <Map<String, dynamic>>[].obs;
  var isChatUsersLoading = false.obs;
  Timer? _refreshTimer;
  int? _currentReceiverId;

  Future<void> loadMessages({required int receiverId}) async {
    try {
      isLoading.value = true;
      _currentReceiverId = receiverId;
      final senderId = profileController.userId.value;

      final fetched = await ApiServices().fetchMessages(
        senderId: senderId,
        receiverId: receiverId,
      );

      messages.assignAll(fetched);
      await markMessagesAsRead(receiverId: receiverId);

    } catch (e) {
      print("loadMessages(): $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkNewMessages() async {
    if (_currentReceiverId == null) return;
    try {
      final senderId = profileController.userId.value;
      final fetched = await ApiServices().fetchMessages(
        senderId: senderId,
        receiverId: _currentReceiverId!,
      );

      if (fetched.isEmpty) return;

      if (messages.isEmpty) {
        messages.assignAll(fetched);
      } else {
        final lastId = messages.last["id"];
        final newOnes = fetched.where((m) => m["id"] > lastId).toList();
        if (newOnes.isNotEmpty) {
          messages.addAll(newOnes);
          messages.refresh();
          print(" Added ${newOnes.length} new messages");
          await loadChatUsers();
        }
      }
    } catch (e) {
      print("checkNewMessages(): $e");
    }
  }

  void startAutoRefresh({required int receiverId}) {
    stopAutoRefresh();
    _currentReceiverId = receiverId;
    loadMessages(receiverId: receiverId);
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await checkNewMessages();
    });

    print(" Auto-refresh started for receiver $receiverId");
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    print("Auto-refresh stopped");
  }

  Future<void> sendMessage({
    required int receiverId,
    required String message,
  }) async {
    if (message.trim().isEmpty) return;

    isSending.value = true;
    final senderId = profileController.userId.value;

    final tempMessage = {
      "id": DateTime.now().millisecondsSinceEpoch,
      "sender_id": senderId,
      "receiver_id": receiverId,
      "message": message,
      "created_at_ist": DateTime.now().toIso8601String(),
      "pending": true,
    };
    messages.add(tempMessage);
    messages.refresh();

    try {
      final result = await ApiServices().sendMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );

      if (result != null) {
        final index = messages.indexWhere((m) => m["id"] == tempMessage["id"]);
        if (index != -1) {
          messages[index] = {
            "id": result["id"],
            "sender_id": senderId,
            "receiver_id": receiverId,
            "message": message,
            "created_at_ist":
            result["created_at_ist"] ?? DateTime.now().toIso8601String(),
          };
          messages.refresh();
        }

        await loadChatUsers();

      } else {
        print(" Failed to send message.");
      }
    } catch (e) {
      print(" sendMessage(): $e");
    } finally {
      isSending.value = false;
    }
  }

  Future<void> markMessagesAsRead({required int receiverId}) async {
    try {
      final response = await ApiServices().markMessagesAsRead(receiverId: receiverId);

      if (response != null && response["status"] == true) {
        final index = chatUsers.indexWhere((c) => c["user_id"] == receiverId);
        if (index != -1) {
          chatUsers[index]["unread_count"] = 0;
          chatUsers.refresh();
        }
        print("Messages marked as read");
      }
    } catch (e) {
      print("markMessagesAsRead(): $e");
    }
  }

  Future<void> loadChatUsers() async {
    try {
      isChatUsersLoading.value = true;
      final fetched = await ApiServices().fetchChatUsers();
      chatUsers.assignAll(fetched);
    } catch (e) {
      print("loadChatUsers(): $e");
    } finally {
      isChatUsersLoading.value = false;
    }
  }

  @override
  void onClose() {
    stopAutoRefresh();
    messageController.dispose();
    super.onClose();
  }
}
