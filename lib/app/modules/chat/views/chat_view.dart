import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/AppCustomScaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../controllers/chat_controller.dart';

class ChatView extends StatefulWidget {
  late final int receiverId;

  ChatView({super.key}) {
    receiverId = Get.arguments as int;
  }


  @override
  State<ChatView> createState() => _ChatViewState();
}


class _ChatViewState extends State<ChatView> {

  // final ChatController chatController = Get.put(ChatController());
  // final DashboardController dashboardController = Get.find<DashboardController>();
  final ChatController chatController = ChatController.to;
  final DashboardController dashboardController = Get.find();



  @override
  void initState() {
    super.initState();

    // ✅ load ONLY once
    chatController.loadMessages(receiverId: widget.receiverId);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receiverId != null) {
      chatController.loadMessages(receiverId: widget.receiverId!);
    }
    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(
        title: "Chat",
        backIcon: const Icon(Icons.arrow_back),
        onBackPressed: () => Get.back(),
      ),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return RefreshIndicator(
            onRefresh: () async {
              await chatController.loadMessages(receiverId: widget.receiverId!);
            },
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (chatController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (chatController.messages.isEmpty) {
                      return const Center(
                        child: Text("No messages yet", style: TextStyle(color: Colors.grey)),
                      );
                    }

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      itemCount: chatController.messages.length,
                      itemBuilder: (context, index) {
                        final msg = chatController.messages[
                        chatController.messages.length - 1 - index];
                        final isMe = msg["sender_id"] == chatController.profileController.userId.value;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment:
                            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? AppColors.dividercolor.withOpacity(0.9)
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: isMe
                                        ? const Radius.circular(16)
                                        : const Radius.circular(0),
                                    bottomRight: isMe
                                        ? const Radius.circular(0)
                                        : const Radius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  msg["message"] ?? "",
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black87,
                                    fontSize: 15,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg["created_at_ist"] != null
                                    ? msg["created_at_ist"].toString().substring(11, 16)
                                    : "",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),


                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, -1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatController.messageController,
                            onChanged: (v) {},
                            decoration: InputDecoration(
                              hintText: "Type a message...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Obx(() => AppCustomButton(
                          action: () {
                            final msg = chatController.messageController.text.trim();
                            if (msg.isNotEmpty && widget.receiverId != null) {
                              chatController.sendMessage(
                                receiverId: widget.receiverId!,
                                message: msg,
                              );
                              chatController.messageController.clear();
                            }
                          },
                          height: 45,
                          width: 45,
                          borderradius: 25,
                          color: AppColors.dividercolor,
                          CustomName: chatController.isSending.value
                              ? const CupertinoActivityIndicator(color: Colors.white)
                              : const Icon(Icons.send, color: Colors.white, size: 22),
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
