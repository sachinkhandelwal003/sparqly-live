import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/AppCustomScaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Button.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/api_services/apiServices.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../chat/views/chat_view.dart';
import '../../courses/controllers/courses_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/course_detail_ui_controller.dart';

class CourseDetailView extends GetView<CourseDetailUiController> {
  CourseDetailView({super.key});

  final controller = Get.put(CourseDetailUiController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final CoursesController coursesController = Get.find<CoursesController>();

  // ✅ Subscription controller for feature check
  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices()
          .fetchSubscriptionPlan();
    },
  );

  @override
  Widget build(BuildContext context) {
    subscriptionController.loadData();
    return AppCustomScaffold(
      customAppBar: AppCustomAppBar(
        title: "Course",
        onBackPressed: () {
          dashboardController.goToPage(4);
        },
        showShare: true,
        showBookmark: true,
        type: "course",
        id: coursesController.selectedId.value,
        onBookmark: (type, id) async {
          await ApiServices().addBookmark(type: type, id: id);
        },
      ),
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.courseDetail.value == null) {
              return Center(
                child: Text(
                  controller.errorMessage.value.isEmpty
                      ? "No data found"
                      : controller.errorMessage.value,
                ),
              );
            }

            final course = controller.courseDetail.value!.data;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: mediaQuery.size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              course.image,
                              width: double.infinity,
                              height: mediaQuery.size.height * 0.25,
                              fit: BoxFit.cover,
                            ),
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.02),

                          // Title
                          AppCustomTexts(
                            TextName: course.courseTitle,
                            textStyle: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Times New Roman",
                                ),
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.01),

                          // Instructor
                          AppCustomTexts(
                            TextName: "By ${course.instructor}",
                            textStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[700],
                                  fontFamily: "Times New Roman",
                                ),
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.025),

                          // Duration + Level + Difficulty
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoBox(
                                context,
                                Icons.access_time,
                                course.duration,
                              ),
                              _buildInfoBox(
                                context,
                                Icons.bar_chart,
                                course.level,
                              ),
                              _buildInfoBox(context, Icons.school, "Beginner"),
                            ],
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.025),

                          // Description
                          Obx(() {
                            final expanded = controller.isExpanded.value;
                            final description = course.description;

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
                                      onTap: () =>
                                          controller.isExpanded.toggle(),
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

                          SizedBox(height: mediaQuery.size.height * 0.03),

                          if (course.courseCategory != null ||
                              course.language != null) ...[
                            AppCustomTexts(
                              TextName: "Course Info",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Times New Roman",
                                  ),
                            ),
                            const SizedBox(height: 10),

                            if (course.courseCategory != null)
                              _buildInfoBox(
                                context,
                                Icons.category,
                                course.courseCategory,
                              ),
                            SizedBox(height: mediaQuery.size.height * 0.015),
                            if (course.language != null)
                              _buildInfoBox(
                                context,
                                Icons.language,
                                course.language,
                              ),

                            SizedBox(height: mediaQuery.size.height * 0.025),
                          ],

                          // Curriculum
                          AppCustomTexts(
                            TextName: "Curriculum",
                            textStyle: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Times New Roman",
                                ),
                          ),

                          SizedBox(height: mediaQuery.size.height * 0.015),

                          // Expansion Tiles
                          ..._buildCurriculum(course),
                          SizedBox(height: mediaQuery.size.height * 0.015),
                          reviewCardWidget(context: context, review: {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),

      BottomBar: Row(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 10, right: 10),
              child: Obx(() {
                final price = controller.courseDetail.value?.data.price;

                return AppCustomButton(
                  action: () {
                    final course = controller.courseDetail.value?.data;
                    if (course == null) return;
                    controller.startCoursePayment(course: course);
                  },
                  height: 40,
                  width: double.infinity,
                  borderradius: 8,
                  color: AppColors.buttonColor,
                  ButtonName: price == null
                      ? "Buy Now"
                      : "Buy Now  ₹$price",
                );
              }),
            ),
          ),

          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, right: 10),
              child: IconButton(

                icon: const Icon(Icons.chat_bubble_outline, size: 30),

                onPressed: () {

                  // ✅ ONLY LOGIN CHECK
                  final token = GetStorage().read('auth_token');

                  if (token == null || token.toString().isEmpty) {

                    Get.snackbar(
                      "Login Required",
                      "Please login first to chat.",
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    return;
                  }

                  // ✅ CORRECT USER ID
                  final receiverId = controller.courseDetail.value?.data.UserId;

                  if (receiverId != null && receiverId > 0) {

                    Get.toNamed(Routes.CHAT, arguments: receiverId);

                  } else {

                    Get.snackbar("Error", "Instructor not found!");

                  }

                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Info Box Helper
  Widget _buildInfoBox(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 19, color: Theme.of(context).primaryColor),
        const SizedBox(width: 7),
        AppCustomTexts(
          TextName: text,
          textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontFamily: "Times New Roman",
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Curriculum builder with ExpansionTile
  List<Widget> _buildCurriculum(course) {
    final chapters = course.chapters;

    return chapters.map<Widget>((chapter) {
      return AppCustomContainer(
        borderradius: 12,
        widthColor: Colors.grey.shade300,
        widthsize: 1,
        margin: const EdgeInsets.only(bottom: 10),
        child: ExpansionTile(
          title: AppCustomTexts(
            TextName: chapter.chapterTitle,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          children: chapter.modules.map<Widget>((module) {
            final documentPath = module.details.documentPath;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module Title Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill,
                        size: 18,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppCustomTexts(
                          TextName: module.moduleTitle,
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // Docx Download (only if available)
                if (documentPath != null && documentPath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 16,
                      bottom: 8,
                    ),
                    child: AppCustomButton(
                      action: () {
                        launchUrl(
                          Uri.parse(documentPath),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      height: 35,
                      width: double.infinity,
                      borderradius: 6,
                      color: Colors.blueAccent,
                      ButtonName: "Download Material",
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      );
    }).toList();
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
              final myReview = controller.reviews.firstWhereOrNull(
                (r) => r['user_id'].toString() == myUserId,
              );

              // Separate current user review and others
              final otherReviews = controller.reviews
                  .where((r) => r['user_id'].toString() != myUserId)
                  .toList();

              // Determine how many to show if not expanded
              final reviewsToShow = controller.showAllReviews.value
                  ? otherReviews
                  : otherReviews.take(3).toList();

              return Column(
                children: [
                  // Current user's review at top if exists
                  if (myReview != null)
                    _buildReviewCard(
                      context,
                      controller,
                      myReview,
                      isMine: true,
                    ),

                  // Other users reviews
                  ...reviewsToShow.map(
                    (r) =>
                        _buildReviewCard(context, controller, r, isMine: false),
                  ),

                  // See All / Hide button if more than 3 other reviews
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

  /// Reusable Review Card
  Widget _buildReviewCard(
    BuildContext context,
    CourseDetailUiController controller,
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
