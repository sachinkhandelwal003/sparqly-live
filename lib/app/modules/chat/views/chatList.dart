import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sparqly/app/routes/app_pages.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../splash/controllers/subscriptionCheckController.dart';
import '../controllers/chat_controller.dart';
import 'chat_view.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  final ChatController chatController = ChatController.to;
  final DashboardController dashboardController = Get.find<DashboardController>();
  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices().fetchSubscriptionPlan();
    },
  );

  @override
  void initState() {
    super.initState();
    chatController.loadChatUsers();
  }

  @override
  Widget build(BuildContext context) {

    subscriptionController.loadData();

    return AppCustomScaffold(
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Obx(() {

            if (chatController.isChatUsersLoading.value ||
                subscriptionController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final sub = subscriptionController.data.value;
            final hasAccess = sub?.access.courseAdd ?? false;

            List<Widget> children = [];
            // if (!hasAccess) {
            //   children.add(
            //     Container(
            //       width: double.infinity,
            //       margin: const EdgeInsets.all(12),
            //       padding: const EdgeInsets.all(14),
            //       decoration: BoxDecoration(
            //         color: Colors.orange.shade50,
            //         borderRadius: BorderRadius.circular(14),
            //         border: Border.all(color: Colors.orange.shade200),
            //       ),
            //       child: Row(
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           const Icon(Icons.lock_outline, color: Colors.orange, size: 28),
            //           const SizedBox(width: 12),
            //
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: const [
            //                 Text(
            //                   "Upgrade Required",
            //                   style: TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.orange,
            //                     fontSize: 14,
            //                   ),
            //                 ),
            //                 SizedBox(height: 4),
            //                 Text(
            //                   "Buy a subscription to unlock chat features and connect with more users instantly.",
            //                   style: TextStyle(
            //                     color: Colors.orange,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //
            //           const SizedBox(width: 8),
            //
            //           ElevatedButton(
            //             onPressed: () {
            //               dashboardController.goToPage(23);
            //             },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: Colors.orange,
            //               foregroundColor: Colors.white,
            //               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //               textStyle: const TextStyle(
            //                 fontSize: 12,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             child: const Text("Upgrade"),
            //           ),
            //         ],
            //       ),
            //     ),
            //   );
            // }

            if (chatController.chatUsers.isEmpty) {
              children.add(const Center(child: Text("No chats yet.")));
            }
            else {
              children.add(
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await chatController.loadChatUsers();
                    },
                    child: ListView.builder(
                      itemCount: chatController.chatUsers.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final chat = chatController.chatUsers[index];

                        return GestureDetector(
                          // onTap: () {
                          //   if(!hasAccess)
                          //     {
                          //       Get.snackbar(
                          //         "Access Restricted",
                          //         "Buy a subscription to unlock chat features and connect seamlessly with other users.",
                          //         backgroundColor: Colors.orange.shade50,
                          //         colorText: Colors.orange.shade700,
                          //         icon: const Icon(Icons.lock_outline, color: Colors.orange),
                          //         snackPosition: SnackPosition.BOTTOM,
                          //         margin: const EdgeInsets.all(12),
                          //         duration: const Duration(seconds: 3),
                          //       );
                          //     }
                          //   else{
                          //     final receiverId = chat["user_id"];
                          //     if (receiverId != null && receiverId.toString().isNotEmpty) {
                          //       Get.to(() => ChatView(receiverId: receiverId));
                          //     } else {
                          //       Get.snackbar("Error", "User ID not found!");
                          //     }
                          //   }
                          // },
                          onTap: () {

                            final token = GetStorage().read('auth_token');

                            if(token == null || token.toString().isEmpty){

                              Get.snackbar(
                                "Login Required",
                                "Please login first to start chatting.",
                                snackPosition: SnackPosition.BOTTOM,
                              );

                              return;
                            }

                            final receiverId = chat["user_id"];

                            if (receiverId != null && receiverId.toString().isNotEmpty) {
                              Get.toNamed(Routes.CHAT, arguments: receiverId);
                            } else {
                              Get.snackbar("Error", "User ID not found!");
                            }

                          },

                          child: AppCustomContainer(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            borderradius: 12,
                            widthColor: Colors.grey.shade300,
                            widthsize: 1,
                            color: Colors.white,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage:
                                  NetworkImage(chat["profile_image"] ?? ""),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppCustomTexts(
                                        TextName: chat["name"] ?? "Unknown",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .copyWith(fontWeight: FontWeight.w400),
                                        maxLine: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      AppCustomTexts(
                                        TextName: chat["last_message"] ?? "",
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.grey[600]),
                                        maxLine: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AppCustomTexts(
                                      TextName:
                                      _formatTime(chat["last_message_time"]),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    if ((chat["unread_count"] ?? 0) > 0)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "${chat["unread_count"]}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: children,
            );
          });
        },
      ),
    );
  }

  String _formatTime(String? isoString) {
    if (isoString == null || isoString.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? "PM" : "AM";
      return "$hour:$minute $period";
    } catch (e) {
      return "";
    }
  }
}
