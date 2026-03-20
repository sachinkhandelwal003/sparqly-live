import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:sparqly/app/services/location%20services/Detail_map.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/Custom_Widgets/AppCustomScaffold.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../business/controllers/business_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/business_detail_page_controller.dart';

class BusinessDetailPageView extends GetView<BusinessDetailPageController> {
  BusinessDetailPageView({super.key});
  // Business detail view mein
  final DashboardController dashboardController = Get.find();
  // final id = dashboardController.currentArgs.value; // deep link se aaya id  // final BusinessDetailPageController controller = Get.put(BusinessDetailPageController());
  final BusinessController businessController = Get.find<BusinessController>();

  @override
  Widget build(BuildContext context) {
    // Deep link ya normal navigation dono handle hoga
    final DashboardController dashboardController =
        Get.find<DashboardController>();

    // Agar args hai toh use karo, warna BusinessController se lo
    if (dashboardController.currentArgs.value != null) {
      final id = dashboardController.currentArgs.value;
      controller.fetchBusinessDetail(id); // ya jo bhi tumhara method hai
    }

    print("BUSINESS ID = ${businessController.selectedId.value}");

    return AppCustomScaffold(
      resize: true,
      customAppBar: AppCustomAppBar(
        title: "",
        onBackPressed: () => dashboardController.goToPage(11),
        showShare: true,
        showBookmark: true,
        type: "business",
        // id: controller.businessDetail.value?.id ?? 0
        id: businessController.selectedId.value,
        onBookmark: (type, id) async {
          await ApiServices().addBookmark(type: type, id: id);
        },
      ),
      BottomBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
        child: Row(
          children: [
            // Chat Button
            Obx(() {
              final detailId = controller.businessDetail.value;

              return Expanded(
                child: AppCustomButton(
                  color: AppColors.buttonColor,
                  action: () {
                    final receiverId = detailId?.UserId;
                    if (receiverId != null) {
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
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      AppCustomTexts(
                        TextName: " Chat",
                        textStyle: Theme.of(context).textTheme.bodyLarge!
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
            const SizedBox(width: 15),
            Expanded(
              child: AppCustomButton(
                color: AppColors.buttonColor,
                action: () {
                  final detail = controller.businessDetail.value;
                  controller.openWebsite(detail?.websiteLink);
                },
                height: 40,
                borderradius: 10,
                CustomName: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.link,
                      color: Colors.white,
                      size: 20,
                    ),
                    AppCustomTexts(
                      TextName: " Learn More",
                      textStyle: Theme.of(context).textTheme.bodyLarge!
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                            fontFamily: "Times New Roman",
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      BodyWidget: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.fetchBusinessDetail(
                    businessController.selectedId.value,
                  ),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }
        final detail = controller.businessDetail.value;
        if (detail == null) {
          return const Center(child: Text("No business details available"));
        }
        final lat = double.tryParse(detail.latitude.toString());
        final lng = double.tryParse(detail.longitude.toString());
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppCustomContainer(
            color: AppColors.white,
            borderradius: 16,
            widthColor: Colors.grey.shade300,
            widthsize: 1,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.network(
                            detail.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppCustomContainer(
                          borderradius: 6,
                          color: Colors.grey.shade100,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AppCustomTexts(
                              TextName: detail.businessCatId,
                              textStyle: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Times New Roman",
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        AppCustomTexts(
                          TextName: detail.name,
                          textStyle: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Times New Roman",
                              ),
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AppCustomTexts(
                                TextName: detail.location,
                                textStyle: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Colors.grey[700],
                                      fontFamily: "Times New Roman",
                                    ),
                                maxLine: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Obx(() {
                          final expanded = controller.isExpanded.value;
                          final description = detail.description.isNotEmpty
                              ? detail.description
                              : "No description available for this business.";
                          return RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey[800],
                                    fontFamily: "Times New Roman",
                                  ),
                              children: [
                                TextSpan(
                                  text: expanded
                                      ? description
                                      : (description.length > 120
                                            ? description.substring(0, 120) +
                                                  "..."
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
                        const SizedBox(height: 16),
                        LocationViewer(latitude: lat, longitude: lng),
                        const SizedBox(height: 20),
                        reviewCardWidget(context: context, review: {}),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppCustomTexts(
                    TextName: "Reviews & Ratings",
                    textStyle: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(
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
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
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
              final myUserId = controller.currentUserId.toString() ?? '';
              final myReview = controller.reviews.firstWhereOrNull(
                (r) => r['user_id'].toString() == myUserId,
              );
              final otherReviews = controller.reviews
                  .where((r) => r['user_id'].toString() != myUserId)
                  .toList();
              final reviewsToShow = controller.showAllReviews.value
                  ? otherReviews
                  : otherReviews.take(3).toList();

              return Column(
                children: [
                  if (myReview != null)
                    _buildReviewCard(
                      context,
                      controller,
                      myReview,
                      isMine: true,
                    ),
                  ...reviewsToShow.map(
                    (r) =>
                        _buildReviewCard(context, controller, r, isMine: false),
                  ),
                  if (otherReviews.length > 3)
                    TextButton(
                      onPressed: () {
                        controller.showAllReviews.value =
                            !controller.showAllReviews.value;
                      },
                      child: Obx(
                        () => Text(
                          controller.showAllReviews.value ? "Hide" : "See All",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, thickness: 0.8),
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
            Obx(
              () => Row(
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
              ),
            ),

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
                  borderSide: BorderSide(
                    color: AppColors.buttonColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                  child: controller.isLoadingSubmitReview.value
                      ? CupertinoActivityIndicator(
                          color: AppColors.white,
                          animating: true,
                        )
                      : AppCustomTexts(
                          TextName: isEditing
                              ? "Update Review"
                              : "Submit Review",
                          textStyle: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
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

  Widget _buildReviewCard(
    BuildContext context,
    BusinessDetailPageController controller,
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
    final String formattedDate = DateFormat(
      'dd MMM yyyy, hh:mm a',
    ).format(createdAt);

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
              backgroundImage: (userImage != null && userImage.isNotEmpty)
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
                    textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                        index < reviewRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 14,
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  AppCustomTexts(
                    maxLine: 2,
                    TextName: review['review']?.toString() ?? "",
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.black54,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    controller.startEditingReview(review);
                  } else if (value == 'delete') {}
                },
                itemBuilder: (BuildContext context) {
                  return const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ];
                },
              ),
          ],
        ),
      ),
    );
  }
}
