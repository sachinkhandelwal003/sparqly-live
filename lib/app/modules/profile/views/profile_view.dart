import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sparqly/app/models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import 'package:sparqly/app/modules/courseDetailUi/controllers/course_detail_ui_controller.dart';
import 'package:sparqly/app/modules/referal/controllers/referal_controller.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/App_Colors.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/Custom_Widgets/App_AppResponsive.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Container.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Texts.dart';
import '../../../widgets/Custom_Widgets/feature_Access.dart';
import '../../business/controllers/business_controller.dart';
import '../../business_detail_page/controllers/business_detail_page_controller.dart';
import '../../categories/controllers/categories_controller.dart';
import '../../courses/controllers/courses_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../influencer_detail_page/controllers/influencer_detail_page_controller.dart';
import '../../influencers/controllers/influencers_controller.dart';
import '../../jobs/controllers/jobs_controller.dart';
import '../../jobs_detail_page/controllers/jobs_detail_page_controller.dart';
import '../../offers/controllers/offers_controller.dart';
import '../../offers_detail_page/controllers/offers_detail_page_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {

  final ProfileController controller = Get.put(ProfileController());
  final DashboardController dashboardController = Get.find<DashboardController>();
  final token = GetStorage().read('auth_token');

  final categoryController = Get.put(CategoriesController());
  final OffersController offersController = Get.put(OffersController());

  final BusinessController businessController = Get.put(BusinessController());
  final JobsController jobsController = Get.put(JobsController());
  final InfluencersController influencerController = Get.put(InfluencersController());
  final BusinessDetailPageController businessDetailPageController = Get.put(BusinessDetailPageController());
  final JobsDetailPageController jobsDetailPageController = Get.put(JobsDetailPageController());
  final InfluencerDetailPageController influencerDetailPageController = Get.put(InfluencerDetailPageController());
  final OffersDetailPageController offersDetailPageController = Get.put(OffersDetailPageController());
  final CoursesController coursesController = Get.put(CoursesController());
  final CourseDetailUiController couseDetailPageController = Get.put(CourseDetailUiController());
  final ReferalController referralController = Get.put(ReferalController());

  final subscriptionController = GenericController<SubscriptionPlanActive>(
    fetchFunction: () async {
      return await ApiServices()
          .fetchSubscriptionPlan();
    },
  );


  @override
  Widget build(BuildContext context) {
    subscriptionController.loadData();

    void handleItemNavigation(String type, int id) {
      Get.back();

      switch (type.toLowerCase()) {
        case "business":
          dashboardController.goToPage(17);
          businessController.selectedId.value = id;
          businessDetailPageController.fetchBusinessDetail(id);
          break;

        case "job":
          dashboardController.goToPage(18);
          jobsController.selectedId.value = id;
          jobsDetailPageController.fetchJobDetail(id);
          break;

        case "influencer":
          dashboardController.goToPage(19);
          influencerController.selectedId.value = id;
          influencerDetailPageController.fetchInfluencerDetail(id);
          break;

        case "offer":
          dashboardController.goToPage(20);
          offersController.selectedId.value = id;
          offersDetailPageController.fetchOfferDetail(id);
          break;

        case "course":
          dashboardController.goToPage(21);
          coursesController.selectedId.value = id;
          couseDetailPageController.fetchCourseDetail(id);
          break;

        default:
          dashboardController.goToPage(17);
      }
    }


    final mediaQuery = MediaQuery.of(context);

    return SafeArea(
      child: SizedBox(
        width: mediaQuery.size.width < 600
            ? mediaQuery.size.width
            : 400,
        child: Drawer(
          backgroundColor: AppColors.white,
          child: Column(
            children: [
              Container(
                color: AppColors.scaffoldBc,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 16,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 23),
                      onPressed: () => Navigator.pop(context), // close drawer
                    ),
                    const SizedBox(width: 8),
                    AppCustomTexts(
                      TextName: "Profile",
                      textStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
          ]
        )
      ),

              Expanded(
                child: AppResponsive(
                  builder: (context, constraints, mediaQuery) {
                    final theme = Theme.of(context).textTheme;
                    return RefreshIndicator(
                      color: AppColors.buttonColor,
                      onRefresh:() async {
                            await controller.loadBookmarks();
                            await controller.fetchUserProfile();
                            await controller.loadBookmarks();
                            await controller.fetchListings();
                            await controller.fetchInvitationPoints();
                            await controller.fetchListingViews();
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(), //  add this
                        child: Column(
                          children: [
                            _buildProfileCard(theme, mediaQuery, constraints),
                            buildCustomTabBar(
                              tabs: ["Listings", "Saved", "Analytics","Insights"],
                              selectedIndex: controller.selectedTab,
                            ),
                            SizedBox(height: mediaQuery.size.height * 0.01),
                            Obx(() {
                              switch (controller.selectedTab.value) {
                                case 0:
                                  return Obx(() {
                                    if (controller.isLoading.value) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    if (controller.errorMessage.isNotEmpty) {
                                      return Center(child: Text(
                                          controller.errorMessage.value));
                                    }

                                    final listings = controller.listings;

                                    return listings.isEmpty
                                        ? const Center(
                                        child: Text("No listings available"))
                                        : GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                      ),
                                      itemCount: listings.length,
                                      itemBuilder: (context, index) {
                                        final item = listings[index];
                                        return GestureDetector(
                                          onTap: () => handleItemNavigation(item.category, item.id),
                                          child: Card(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(12),
                                            ),
                                            elevation: 3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(12)),
                                                  child: Stack(
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio: 16 / 10,
                                                        child: Image.network(
                                                          item.image ?? '',
                                                          width: double
                                                              .infinity,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __, ___) =>
                                                              Image.asset("assets/placeholder.jpg", fit: BoxFit.cover,),
                                                          loadingBuilder: (context, child, progress) {
                                                            if (progress == null) return child;
                                                            return Container(
                                                              color: Colors.grey.shade200,
                                                              child: const Center(
                                                                child: CircularProgressIndicator(strokeWidth: 2),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),

                                                      Positioned(
                                                        top: 8,
                                                        right: 8,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                Color(0xFFFF9800),
                                                                Color(0xFFFFC107)
                                                              ],
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                            ),
                                                            borderRadius: BorderRadius
                                                                .circular(8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.2),
                                                                blurRadius: 4,
                                                                offset: const Offset(1, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize
                                                                .min,
                                                            children: [
                                                              const Icon(Icons
                                                                  .local_offer_rounded,
                                                                  size: 11,
                                                                  color: Colors
                                                                      .white),
                                                              const SizedBox(
                                                                  width: 3),
                                                              Text(
                                                                item.category ?? "",
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 10.5,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 8),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        item.name ?? "",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14,
                                                          fontFamily: "Times New Roman",
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        item.shortDesc ?? "",
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          fontFamily: "Times New Roman",
                                                          color: Colors.black87,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  );

                              case 1:
                                  final items = controller.bookmarks;
                                  if (items.isEmpty) {
                                    return const Center(child: Text("No saved content"));
                                  }

                                  return GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                   padding: const EdgeInsets.all(10),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                       crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final data = items[index];

                                      return GestureDetector(
                                        onTap: () => handleItemNavigation(data.category, data.id),
                                        child: Card(
                                          color: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child:
                                                ClipRRect(
                                                  borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(12)),
                                                  child: Stack(
                                                    children: [
                                                      AspectRatio(
                                                        aspectRatio: 16 / 10,
                                                        child: Image.network(
                                                          data.image,
                                                          width: double
                                                              .infinity,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (_, __,
                                                              ___) =>
                                                              Image.asset("assets/placeholder.jpg", fit: BoxFit.cover,),
                                                          loadingBuilder: (context, child, progress) {
                                                            if (progress == null)
                                                              return child;
                                                            return Container(
                                                              color: Colors.grey.shade200,
                                                              child: const Center(
                                                                child: CircularProgressIndicator(
                                                                    strokeWidth: 2),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),

                                                      Positioned(
                                                        top: 8,
                                                        right: 8,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient: const LinearGradient(
                                                              colors: [
                                                                Color(0xFFFF9800),
                                                                Color(0xFFFFC107)
                                                              ],
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                            ),
                                                            borderRadius: BorderRadius.circular(8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black.withOpacity(0.2),
                                                                blurRadius: 4,
                                                                offset: const Offset(1, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const Icon(Icons.local_offer_rounded, size: 11,
                                                                  color: Colors.white),
                                                              const SizedBox(width: 3),
                                                              Text(
                                                            data.category,
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 10.5,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  data.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    fontFamily: "Times New Roman",
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // 1-line description
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(
                                                  data.desc,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87,
                                                    fontFamily: "Times New Roman",
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                case 2:
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Obx(() {
                                      if (subscriptionController.isLoading.value) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      final hasPremium = subscriptionController.data.value?.access.analyticsAccess ?? false;

                                      if (!hasPremium) {
                                        return Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(12),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: Colors.orange.shade200),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.lock_outline, color: Colors.orange, size: 28),
                                              const SizedBox(width: 12),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "Upgrade Required",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.orange,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Buy a subscription to view listing analytics and invitation insights.",
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                    dashboardController.goToPage(23);
                                                  });
                                                },

                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.orange,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                child: const Text("Upgrade"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }


                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Listing Views Card
                                          Expanded(
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: const [
                                                        Text(
                                                          "Listing Views",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 12),
                                                        ),
                                                        Icon(Icons.remove_red_eye, size: 15),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      controller.listingViews['total_views']?.toString() ?? "0",
                                                      style: const TextStyle(
                                                          fontSize: 17, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      controller.listingViews['from_last_month'] ?? "+0% from last month",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Invitation Points Card
                                          Expanded(
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(15)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: const [
                                                        Text(
                                                          "Invitation Points",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold, fontSize: 12),
                                                        ),
                                                        Icon(Icons.card_giftcard, size: 15),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      controller.invitationPoints['points']?.toString() ?? "0",
                                                      style: const TextStyle(
                                                          fontSize: 17, fontWeight: FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      controller.invitationPoints['change_text'] ?? "+0% from last month",
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                          color: Colors.green),
                                                      softWrap: true,
                                                      overflow: TextOverflow.visible,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  );

                                case 3:
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Obx(() {

                                      if (subscriptionController.isLoading.value) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      final bool hasAnalyticsAccess =
                                          subscriptionController.data.value?.access.advanceAnalytics ?? false;

                                      if (!hasAnalyticsAccess) {
                                        return Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(12),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.shade50,
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(color: Colors.orange.shade200),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              const Icon(Icons.lock_outline, color: Colors.orange, size: 28),
                                              const SizedBox(width: 12),

                                              const Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Upgrade Required",
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.orange,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      "Upgrade to Pro to unlock advanced analytics, graphs and insights.",
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(width: 8),

                                              ElevatedButton(
                                                onPressed: () {
                                                  Get.back();
                                                  Future.delayed(const Duration(milliseconds: 200), () {
                                                    dashboardController.goToPage(23);
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.orange,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                child: const Text("Upgrade"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }


                                      /// ---------- ANALYTICS LOADING ----------
                                      if (controller.isAnalyticsLoading.value) {
                                        return const Center(child: CircularProgressIndicator());
                                      }

                                      final analytics = controller.analyticsData.value;

                                      if (analytics == null) {
                                        return const Center(child: Text("No analytics data available"));
                                      }

                                      final int totalViews = analytics.summary.totalViews;

                                      /// ---------- PREMIUM ANALYTICS UI ----------
                                      return Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            /// ---------------- TITLE ----------------
                                            Text(
                                              "Performance Overview",
                                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Times New Roman",
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            /// ---------------- SUMMARY CARD ----------------
                                            Container(
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.05),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const Text(
                                                    "Total Views (30 Days)",
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                  Text(
                                                    totalViews.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            /// ---------------- DAILY VIEWS GRAPH ----------------
                                            Container(
                                              height: 220,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.05),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Daily Views Trend",
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 12),

                                                  Expanded(
                                                    child: Row(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: analytics.dailyViews.map((item) {
                                                        return Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Text(
                                                                item.views.toString(),
                                                                style: const TextStyle(fontSize: 10),
                                                              ),
                                                              const SizedBox(height: 4),
                                                              Container(
                                                                height: (item.views * 6).toDouble(),
                                                                width: 10,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.blue.shade400,
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 6),
                                                              Text(
                                                                item.date.substring(8),
                                                                style: const TextStyle(fontSize: 10),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            /// ---------------- TYPE DISTRIBUTION ----------------
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Views by Listing Type",
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  ...analytics.typeDistribution.map((item) {
                                                    final double percent = totalViews == 0
                                                        ? 0.0
                                                        : (item.views / totalViews).clamp(0.0, 1.0);

                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 8),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              item.dataType.toUpperCase(),
                                                              style: const TextStyle(fontSize: 11),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: LinearProgressIndicator(
                                                              value: percent,
                                                              minHeight: 8,
                                                              backgroundColor: Colors.grey.shade200,
                                                              valueColor: AlwaysStoppedAnimation(
                                                                Colors.orange.shade400,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 8),
                                                          Text(
                                                            item.views.toString(),
                                                            style: const TextStyle(fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            /// ---------------- TOP LISTINGS ----------------
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(14),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Top Performing Listings",
                                                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                  ),
                                                  const SizedBox(height: 10),

                                                  ...analytics.topListings.asMap().entries.map((entry) {
                                                    final index = entry.key + 1;
                                                    final item = entry.value;

                                                    return Padding(
                                                      padding: const EdgeInsets.only(bottom: 6),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "#$index",
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              "${item.dataType.toUpperCase()} • ID ${item.dataId}",
                                                              style: const TextStyle(fontSize: 12),
                                                            ),
                                                          ),
                                                          Text(
                                                            "${item.views} views",
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  );







                                default:
                                  return const SizedBox();
                              }
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  // ♻️ Profile Card widget
  Widget _buildProfileCard(TextTheme theme, MediaQueryData mediaQuery, BoxConstraints constraints ) {
    return Card(
      elevation: 2,
      color: AppColors.white,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: mediaQuery.size.height * 0.02),
            Obx(() {

              return CircleAvatar(
                radius: mediaQuery.size.width < 600 ? 55 : 70,
                backgroundImage: controller.userImage.value.isNotEmpty
                    ? NetworkImage(controller.userImage.value)
                    : const AssetImage("assets/profile.jpg") as ImageProvider,
              );
            }),



            SizedBox(height: mediaQuery.size.height * 0.03),

// ✅ Display Name
            Obx(() {
              final bool isPremiumUser =
                  subscriptionController.data.value?.access.verifiedBadge == true;

              final String userName = controller.userName.value.isNotEmpty
                  ? controller.userName.value
                  : "Guest Explorer 🧭";

              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AppCustomTexts(
                      TextName: userName,
                      textStyle: theme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                        color: Colors.black87,
                      ),
                      maxLine: 1,
                      Textalign: TextAlign.center,
                    ),
                  ),

                  // ✅ VERIFIED BADGE AFTER NAME
                  if (isPremiumUser) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                  ],
                ],
              );
            }),


            SizedBox(height: mediaQuery.size.height * 0.02),

// ✅ Profession
            Obx(() => AppCustomTexts(
              TextName: controller.userProfession.value.isNotEmpty
                  ? controller.userProfession.value
                  : "Dream Chaser ✨", // inspiring fallback
              textStyle: theme.displayMedium!.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
                fontFamily: "Times New Roman",
              ),
            ),
            ),

            SizedBox(height: mediaQuery.size.height * 0.02),

// ✅ Bio
            Obx(() => AppCustomTexts(
              TextName: controller.userBio.value.isNotEmpty
                  ? controller.userBio.value
                  : "\"Every profile has a story... start writing yours.\"", // elegant quote
              textStyle: theme.displaySmall!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              //  fontStyle: FontStyle.italic,
                fontFamily: "Times New Roman",
              ),
              Textalign: TextAlign.center,
            ),
            ),

            SizedBox(height: mediaQuery.size.height * 0.025),

// ✅ Website (Clickable Link)
            Obx(() {
              final website = controller.userWebsite.value.trim();

              // Limit display length to keep it short
              String displayText = website.isNotEmpty
                  ? (website.length > 25
                  ? '${website.substring(0, 25)}...'
                  : website)
                  : "🚀 Showcase your portfolio or favorite link";

              return InkWell(
                onTap: () async {
                  if (website.isNotEmpty) {
                    final formattedUrl =
                    website.startsWith('http') ? website : 'https://$website';
                    await launchUrl(
                      Uri.parse(formattedUrl),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: AppCustomTexts(
                  TextName: displayText,
                  textStyle: theme.displaySmall!.copyWith(
                    color: website.isNotEmpty
                        ? Colors.blue.shade700
                        : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                    decoration: website.isNotEmpty
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                  Textalign: TextAlign.center,
                  maxLine: 1,
                ),
              );
            }),




            SizedBox(height: mediaQuery.size.height * 0.015),
            Divider(color: AppColors.dividercolor, thickness: 0.3),
            SizedBox(height: mediaQuery.size.height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.note_alt_outlined,
                  "Edit Profile",
                  constraints,
                      () {
                    Get.back(); //  closes the drawer
                    token == null ?  Get.snackbar(
                      "Login Required",
                      "Please login first to access Edit Profile",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: AppColors.buttonColor,
                      colorText: Colors.white,
                    ) : dashboardController.goToPage(22);
                  },
                    AppColors.scaffoldBc,
                    Colors.black,
                    Colors.black
                ),


                _buildActionButton(Icons.subscriptions_outlined, "Subscriptions", constraints,() {
                  Get.back();
                   dashboardController.goToPage(23);
                },
                    AppColors.scaffoldBc,Colors.black,
                    Colors.black),
              ],
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  Icons.share_outlined,
                  "Invite",
                  constraints,
                      () async {
                    if (token == null) {
                      Get.snackbar(
                        "Login Required",
                        "Please login first to invite someone",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: AppColors.buttonColor,
                        colorText: Colors.white,
                      );
                    } else {
                      //  Fetch message before sharing
                      await controller.sendInvite();

                      if (controller.inviteMessage.value.isNotEmpty) {
                        Share.share(
                          controller.inviteMessage.value,
                          subject: "Invite to My App",
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Unable to fetch invite message. Please try again.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppColors.buttonColor,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                    AppColors.scaffoldBc,
                    Colors.black,
                    Colors.black
                ),


                _buildActionButton(
                  Icons.video_library_outlined,
                  "My Courses",
                  constraints,
                      () async {
                    Get.toNamed(Routes.MY_COURSES);
                  },
                    AppColors.scaffoldBc,
                    Colors.black,
                    Colors.black
                ),
              ],
            ),

            SizedBox(height: mediaQuery.size.height * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                _buildActionButton(Icons.logout, "Logout", constraints, () {
                  token == null ?   Get.snackbar(
                    "Login Required",
                    "Please login first to logout",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.buttonColor,
                    colorText: Colors.white,
                  ) : showDialog(
                    context: Get.context!,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Center(
                        child: Material(
                          color: Colors.transparent,
                          child: AppCustomContainer(
                            borderradius: 16,
                            color: AppColors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout, size: 50, color: Colors.redAccent),
                                  const SizedBox(height: 16),
                                  AppCustomTexts(
                                    TextName: "Logout",
                                    textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  AppCustomTexts(
                                    TextName: "Are you sure you want to logout?",
                                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.grey.shade700,
                                    ),
                                    Textalign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 28),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppCustomButton(
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          borderradius: 10,
                                          color: Colors.grey.shade300,
                                          action: () {
                                            Navigator.of(context).pop(); //  replace Get.back()
                                          },
                                          CustomName: AppCustomTexts(
                                            TextName: "Cancel",
                                            textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              color: AppColors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: AppCustomButton(
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          borderradius: 10,
                                          color: Colors.redAccent,
                                          action: () async{
                                            Navigator.of(context).pop(); // close dialog
                                            controller.logout();
                                            // 🔑 Logout logic
                                            final storage = GetStorage(); // or any storage you use
                                            storage.erase();
                                            await storage.remove('auth_token'); // make sure to await it// remove all keys
                                            Navigator.of(context).pushReplacementNamed(Routes.OTP); // go to OTP/login
                                          },
                                          CustomName: AppCustomTexts(
                                            TextName: "Logout",
                                            textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                    AppColors.scaffoldBc,
                    Colors.black,
                    Colors.black
                ),

                _buildActionButton(
                  Icons.delete_outline,
                  "Delete",
                  constraints,
                      () async {
                      showDeleteAccountDialog(controller);
                      },
                  Colors.redAccent,
                  Colors.white,
                  Colors.white
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }

  void showDeleteAccountDialog(ProfileController controller) {
    Get.defaultDialog(
      title: "Delete Account",
      middleText: "This action cannot be undone. Are you sure?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.deleteUserAccount();
      },
    );
  }

  //  Action Button
  Widget _buildActionButton(IconData icon, String label, BoxConstraints constraints, VoidCallback onTap ,Color color,Color textColor,Color iconColor) {
    return AppCustomButton(
      action: onTap,
      height: constraints.maxHeight * 0.05,
      width: constraints.maxWidth * 0.39,
      color:color ?? AppColors.scaffoldBc,
      borderradius: 10,
      CustomName: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20,color: iconColor ?? AppColors.black,),
          const SizedBox(width: 6),
          AppCustomTexts(
            TextName: label,
            textStyle: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
              color: textColor ?? AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomTabBar({
    required List<String> tabs,
    required RxInt selectedIndex,
    double height = 45,
    double borderRadius = 8,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: AppCustomContainer(
        height: height,
        borderradius: borderRadius,
        color: AppColors.scaffoldBc,
        child: Obx(
              () => Row(
            children: List.generate(tabs.length, (index) {
              final isActive = selectedIndex.value == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => selectedIndex.value = index,
                  child: AppCustomContainer(
                    margin: const EdgeInsets.all(3),
                    borderradius: borderRadius,
                    color:
                    isActive ? AppColors.white : AppColors.scaffoldBc,
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tabs[index],
                          maxLines: 1,
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            fontFamily: "Times New Roman",
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
