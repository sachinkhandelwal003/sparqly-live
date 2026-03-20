import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../constants/App_Colors.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../chat/views/chat_view.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../offers/controllers/offers_controller.dart';
import '../controllers/offers_detail_page_controller.dart';

class OffersDetailPageView extends GetView<OffersDetailPageController> {

  OffersDetailPageView({super.key});



  final DashboardController dashboardController =
  Get.find<DashboardController>();
  final OffersDetailPageController controller =
  Get.put(OffersDetailPageController());
  final OffersController offersController = Get.put(OffersController());


  // ✅ Subscription controller for feature check
  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices()
          .fetchSubscriptionPlan();
    },
  );

  @override
  Widget build(BuildContext context) {
    //  Trigger API fetch when page loads
    subscriptionController.loadData();

    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(
        title: "",
        onBackPressed: () {
          dashboardController.goToPage(3);
        },
        showShare: true,
        showBookmark: true,
        type: "offer",
        id: offersController.selectedId.value,
        onBookmark: (type, id) async {
          await ApiServices().addBookmark(type: type, id: id);
        },
      ),
      BottomBar:   Padding(
        padding: const EdgeInsets.only(bottom: 30 , left: 10,right: 10),
        child: Row(
          children: [
            // Learn More Button
            Obx(() {
              final detailId = controller.offerDetail.value;

              return Expanded(
                child: AppCustomButton(
                  color: AppColors.buttonColor,
                  // action: () {
                  //
                  //   // ✅ Get subscription data
                  //   final hasChatAccess = subscriptionController.data.value?.access.chatAccess
                  //       ??
                  //       false;
                  //
                  //   if (!hasChatAccess) {
                  //     // ⚠️ Same warning as ChatList
                  //     Get.snackbar(
                  //       "Access Restricted",
                  //       "Buy a subscription to unlock chat features and connect seamlessly with other users.",
                  //       backgroundColor: Colors.orange.shade50,
                  //       colorText: Colors.orange.shade700,
                  //       icon: const Icon(Icons.lock_outline, color: Colors.orange),
                  //       snackPosition: SnackPosition.BOTTOM,
                  //       margin: const EdgeInsets.all(12),
                  //       duration: const Duration(seconds: 3),
                  //     );
                  //     return;
                  //   }
                  //
                  //
                  //   final receiverId = detailId?.UserId;
                  //   if (receiverId != null) {
                  //     Get.toNamed(Routes.CHAT, arguments: receiverId);
                  //   } else {
                  //     Get.snackbar("Error", "User ID not found!");
                  //   }
                  // },
                  action: () {

                    // ✅ LOGIN CHECK ONLY
                    final token = GetStorage().read('auth_token');

                    if (token == null || token.toString().isEmpty) {

                      Get.snackbar(
                        "Login Required",
                        "Please login first to chat.",
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      return;
                    }

                    final receiverId = controller.offerDetail.value?.UserId;

                    if (receiverId != null && receiverId > 0) {

                      Get.toNamed(Routes.CHAT, arguments: receiverId);

                    } else {

                      Get.snackbar("Error", "User ID not found!");

                    }
                  },

                  height: 40,
                  borderradius: 10,
                  CustomName: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          color: Colors.white, size: 20),
                      AppCustomTexts(
                        TextName: "  Chat",
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                          fontFamily: "Times New Roman",
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Obx(() {
            if (controller.isLoading.value) {
              //  Loading state
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.isNotEmpty) {
              //  Error state
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 60),
                    const SizedBox(height: 12),
                    Text(
                      controller.errorMessage.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AppCustomButton(
                      color: AppColors.buttonColor,
                      action: () {
                          //  controller.fetchOfferDetail(controller.offerId)
                      },
                      height: 42,
                      width: 160,
                      borderradius: 8,
                      CustomName: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, color: Colors.white),
                          AppCustomTexts(
                            TextName: " Retry",
                            textStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }

            final offer = controller.offerDetail.value;
            if (offer == null) {
              return const Center(child: Text("No offer details available"));
            }

            //  Success state: Render UI
            return SingleChildScrollView(
              padding: const EdgeInsets.all(4),
              child: AppCustomContainer(
                color: AppColors.white,
                borderradius: 16,
                widthColor: Colors.grey.shade300,
                widthsize: 1,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: mediaQuery.size.height * 0.24,
                        color: Colors.grey[200],
                        child: Image.network(
                          offer.image ?? "",
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image,
                                size: 60, color: Colors.grey),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                    // Title
                    AppCustomTexts(
                      TextName: offer.title ?? "No Title",
                      textStyle:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.01),

                    // Description
                    Obx(() {
                      final expanded = controller.isExpanded.value;
                      final description =
                          offer.description ?? "No Description available";

                      return RichText(
                        text: TextSpan(
                          style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[800],
                            fontFamily: "Times New Roman",
                          ),
                          children: [
                            TextSpan(
                              text: expanded
                                  ? description
                                  : (description.length > 120
                                  ? description.substring(0, 120) + "..."
                                  : description),
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () => controller.isExpanded.toggle(),
                                child: Text(
                                  expanded ? " Read less" : " Read more",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: mediaQuery.size.height * 0.015),

                    // Price
                    AppCustomTexts(
                      TextName: "₹ ${offer.discountValue ?? "0"}",
                      textStyle:
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                        fontFamily: "Times New Roman",
                      ),
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.01),

                    // Validity
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 20),
                        AppCustomTexts(
                          TextName: "  ${offer.offerValidity ?? "N/A"}",
                          textStyle: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Times New Roman",
                          ),
                        ),
                      ],
                    ),

                    const Divider(thickness: 1, height: 30),

                    // How to Redeem
                    AppCustomTexts(
                      TextName: "How to Redeem",
                      textStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    AppCustomTexts(
                      TextName: offer.onlineRedemptionInstructions ??
                          "No additional details.",
                      textStyle:
                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.grey[700],
                        height: 1.5,
                        fontFamily: "Times New Roman",
                      ),
                      maxLine: null,
                    ),

                    SizedBox(height: mediaQuery.size.height * 0.02),

                    // Terms & Conditions
                    AppCustomTexts(
                      TextName: "Terms & Conditions",
                      textStyle:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(height: mediaQuery.size.height * 0.01),
                    AppCustomTexts(
                      TextName: offer.termsConditions ??
                          "No specific terms & conditions provided.",
                      textStyle:
                      Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.grey[700],
                        height: 1.5,
                        fontFamily: "Times New Roman",
                      ),
                      maxLine: null,
                    ),



                    SizedBox(height: mediaQuery.size.height * 0.02),
                    reviewCardWidget(context: context, review:{} ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget reviewCardWidget({
    required BuildContext context,
    required Map<String, dynamic> review,
    bool isMine = false,
    VoidCallback? onEdit,
    VoidCallback? onDelete,

  }) {
    return SingleChildScrollView(
      child: AppCustomContainer(
        borderradius: 16,
        widthColor: Colors.grey.shade300,
        widthsize: 1,
        color: AppColors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title + Average rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppCustomTexts(
                    TextName: "Reviews & Ratings",
                    textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Times New Roman",
                      color: Colors.black87,
                      fontSize: 18,
                    ),
                  ),
                ),
                Obx(() {
                  final avg = controller.averageRating;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        avg == 0.0 ? "-" : avg.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonColor,
                          fontFamily: "Times New Roman",
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          final filled = i < avg.round();
                          return Icon(
                            filled ? Icons.star : Icons.star_border,
                            size: 16,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      Text(
                        "(${controller.reviews.length} reviews)",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey.shade300, thickness: 0.8),

            /// Reviews List
            const SizedBox(height: 8),
            Obx(() {
              if (controller.reviews.isEmpty) {
                return AppCustomTexts(
                  TextName: "No reviews yet.",
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontFamily: "Times New Roman",
                    fontSize: 14,
                  ),
                );
              }

              final myUserId = controller.currentUserId?.toString() ?? '';
              final myReview = controller.reviews.firstWhereOrNull((r) => r['user_id'].toString() == myUserId);

              // Separate current user review and others
              final otherReviews = controller.reviews.where((r) => r['user_id'].toString() != myUserId).toList();

              // Determine how many to show if not expanded
              final reviewsToShow = controller.showAllReviews.value ? otherReviews : otherReviews.take(3).toList();

              return Column(
                children: [
                  // Current user's review at top if exists
                  if (myReview != null)
                    _buildReviewCard(context, controller, myReview, isMine: true),

                  // Other users reviews
                  ...reviewsToShow.map((r) => _buildReviewCard(context, controller, r, isMine: false)),

                  // See All / Hide button if more than 3 other reviews
                  if (otherReviews.length > 3)
                    TextButton(
                      onPressed: () {
                        controller.showAllReviews.value = !controller.showAllReviews.value;
                      },
                      child: Obx(() => Text(
                        controller.showAllReviews.value ? "Hide" : "See All",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.buttonColor,
                        ),
                      )),
                    ),
                ],
              );
            }),

            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 0.8),

            /// Leave a Review
            const SizedBox(height: 5),
            AppCustomTexts(
              TextName: "Leave a Review",
              textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "Times New Roman",
                color: Colors.black87,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 8),
            AppCustomTexts(
              TextName: "Your Rating",
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: "Times New Roman",
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Obx(() => Row(
              children: List.generate(5, (index) {
                return IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => controller.updateRating(index + 1),
                  icon: Icon(
                    index < controller.rating.value
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 25,
                  ),
                );
              }),
            )),

            const SizedBox(height: 5),
            AppCustomTexts(
              TextName: "Your Comment",
              textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontFamily: "Times New Roman",
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller.commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Share your experience...",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  BorderSide(color: AppColors.buttonColor, width: 1.5),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),

            const SizedBox(height: 12),
            Obx(() {
              final isEditing = controller.isEditing.value;
              return AppCustomButton(
                color: AppColors.buttonColor,
                action: controller.submitReview,
                height: 44,
                width: double.infinity,
                borderradius: 10,
                CustomName: Center(
                  child:controller.isLoadingSubmitReview.value ? CupertinoActivityIndicator(color: AppColors.white,animating: true,) :  AppCustomTexts(
                    TextName:
                    isEditing ? "Update Review" : "Submit Review",
                    textStyle:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontFamily: "Times New Roman",
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Reusable Review Card
  Widget _buildReviewCard(
      BuildContext context,
      OffersDetailPageController controller,
      Map<String, dynamic> review, {
        required bool isMine,
      }) {
    final int reviewRating =
        int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
    final String name = review['user']?.toString() ?? "User";
    final String initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final String? userImage = review['user_image']?.toString();
    final DateTime createdAt = review['created_at'] != null
        ? DateTime.tryParse(review['created_at'].toString()) ?? DateTime.now()
        : DateTime.now();
    final String formattedDate =
    DateFormat('dd MMM yyyy, hh:mm a').format(createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppCustomContainer(
        borderradius: 12,
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppColors.buttonColor,
              backgroundImage:
              (userImage != null && userImage.isNotEmpty)
                  ? NetworkImage(userImage)
                  : null,
              child: (userImage == null || userImage.isEmpty)
                  ? Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCustomTexts(
                    TextName: name,
                    textStyle:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFamily: "Times New Roman",
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < reviewRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 14,
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  AppCustomTexts(
                    maxLine: 2,
                    TextName: review['review']?.toString() ?? "",
                    textStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                      fontFamily: "Times New Roman",
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (isMine)
              PopupMenuButton<String>(
                color: AppColors.white,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.more_vert,
                    size: 20, color: Colors.black54),
                onSelected: (value) {
                  if (value == 'edit') {

                  } else if (value == 'delete') {

                  }
                },
                itemBuilder: (BuildContext context) {
                  return const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                  ];
                },
              ),
          ],
        ),
      ),
    );
  }
}
