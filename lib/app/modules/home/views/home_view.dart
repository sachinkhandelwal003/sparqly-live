import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sparqly/app/constants/App_All_list.dart';
import 'package:sparqly/app/constants/App_Colors.dart';
import 'package:sparqly/app/modules/business_detail_page/controllers/business_detail_page_controller.dart';
import 'package:sparqly/app/modules/categories/controllers/categories_controller.dart';
import 'package:sparqly/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:sparqly/app/modules/influencer_detail_page/controllers/influencer_detail_page_controller.dart';
import 'package:sparqly/app/modules/influencers/controllers/influencers_controller.dart';
import 'package:sparqly/app/modules/jobs/controllers/jobs_controller.dart';
import 'package:sparqly/app/modules/jobs_detail_page/controllers/jobs_detail_page_controller.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_AppResponsive.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Container.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Scaffold.dart';
import 'package:sparqly/app/widgets/Custom_Widgets/App_Custom_Texts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/Post_listing_Models/near_You_model.dart';
import '../../../models/Post_listing_Models/trending_Home_model.dart';
import '../../../widgets/Custom_Widgets/App_Custom_Button.dart';
import '../../business/controllers/business_controller.dart';
import '../../offers/controllers/offers_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final HomeController controller = Get.put(HomeController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final categoryController = Get.put(CategoriesController());
  final OffersController offersController = Get.put(OffersController());

  // All COntroller

  final BusinessController businessController = Get.put(BusinessController());
  final JobsController jobsController = Get.put(JobsController());
  final InfluencersController influencerController = Get.put(
    InfluencersController(),
  );
  //final OffersController offersController = Get.find<OffersController>();
  //final CoursesController coursesController = Get.find<CoursesController>();
  final BusinessDetailPageController businessDetailPageController = Get.put(
    BusinessDetailPageController(),
  );
  final JobsDetailPageController jobsDetailPageController = Get.put(
    JobsDetailPageController(),
  );
  final InfluencerDetailPageController influencerDetailPageController = Get.put(
    InfluencerDetailPageController(),
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return AppCustomScaffold(
      // scaffoldbackgroundColor: AppColors.white,
      resize: true,
      BodyWidget: AppResponsive(
        builder: (context, constraints, mediaQuery) {
          return RefreshIndicator(
            color: Colors.blue,
            onRefresh: () async {
              // Call all APIs you want to reload here
              await controller.fetchHeroSections();
              await controller.fetchExploreData();
              await controller.fetchTrending();
              await controller.fetchNearbyOffers();
            },
            child: SizedBox(
              height: height,
              width: width,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildWelcomeCard(context, height, width, controller),
                          SizedBox(height: height * 0.02),
                          _buildCategories(context, height, width, constraints),
                          SizedBox(height: height * 0.02),
                          _buildTrendingNearYou(context, height, width),
                          SizedBox(height: height * 0.04),
                          _buildOffers(
                            context,
                            height,
                            width,
                            constraints,
                            controller,
                          ),
                          SizedBox(height: height * 0.03),
                          _buildGradientInfoCard(
                            context,
                            height,
                            width,
                            constraints,
                            "Amplify Your Reach. Ignite Your Growth.",
                            "Step into the spotlight. Promote your business, job, or course with our powerful advertising tools. Create a hero banner or boost your listing to connect with thousands of potential customers.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Welcome Card (Hero + Ads Carousel)
  Widget _buildWelcomeCard(
    BuildContext context,
    double height,
    double width,
    dynamic controller,
  ) {
    return Card(
      color: Colors.white,
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          height: height * 0.28, // Fixed height
          child: Obx(() {
            // ✅ Loading state
            if (controller.heroIsLoading.value) {
              return _buildShimmer(height, width);
            }

            // ✅ Error state → show shimmer instead of error message
            if (controller.errorMessage.value.isNotEmpty) {
              return _buildShimmer(height, width);
            }

            // ✅ Empty state
            if (controller.combinedBanners.isEmpty) {
              return Container(
                color: Colors.grey.shade200,
                child: const Center(
                  child: Text(
                    "No banners found",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              );
            }

            // ✅ Data state (Hero + Ads together)
            final banners = controller.combinedBanners;

            return Stack(
              children: [
                // --- Carousel ---
                CarouselSlider(
                  carouselController: controller.carouselController,
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      controller.crosalpage.value = index;
                    },
                    height: height * 0.28,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                  items: banners.map<Widget>((item) {
                    return Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // --- Gradient overlay ---
                Container(
                  height: height * 0.28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // --- Text + Button ---
                Positioned(
                  left: 20,
                  bottom: 20,
                  child: Obx(() {
                    final currentIndex = controller.crosalpage.value;
                    final item = banners[currentIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.heading,
                          style: Theme.of(Get.context!).textTheme.headlineSmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black.withOpacity(0.7),
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 6),
                        if (item.subHeading != null &&
                            item.subHeading!.isNotEmpty)
                          Text(
                            item.subHeading!,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.8),
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                          ),
                        const SizedBox(height: 12),
                        if (item.btnUrl != null && item.btnUrl!.isNotEmpty)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              final url = Uri.parse(item.btnUrl!);
                              try {
                                if (!await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                )) {
                                  Get.snackbar('Error', 'Could not launch URL');
                                }
                              } catch (e) {
                                Get.snackbar('Error', e.toString());
                              }
                            },
                            child: Text(
                              item.btnName ??
                                  (item.isHero ? "Explore" : "Learn More"),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  /// shimmer widget for loading + error state
  Widget _buildShimmer(double height, double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height * 0.28,
        width: double.infinity,
        color: Colors.white,
      ),
    );
  }

  //make this card fully responsive for all type of screen..................  //  Categories Section
  Widget _buildCategories(
    BuildContext context,
    double height,
    double width,
    BoxConstraints constraints,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppCustomTexts(
              TextName: 'Categories',
              textStyle: Theme.of(
                context,
              ).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                AppCustomTexts(
                  action: () => dashboardController.goToPage(1),
                  TextName: "See All  ",
                  textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: "Times New Roman",
                  ),
                ),
                Icon(Icons.arrow_forward, size: constraints.maxWidth * 0.045),
              ],
            ),
          ],
        ),
        SizedBox(height: height * 0.01),

        /// Horizontal scroll list
        SizedBox(
          height: height * 0.11, // same height for skeleton + real
          child: Obx(() {
            final isLoading = controller.heroIsLoading.value;

            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: isLoading ? 6 : AppAllList.categoryIcon.length,
              separatorBuilder: (_, __) => SizedBox(width: width * 0.05),
              itemBuilder: (context, index) {
                if (isLoading) {
                  // Skeleton Loader -> match real card size
                  return SizedBox(
                    width: width * 0.20, // 👈 same total width as real item
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: width * 0.08,
                          backgroundColor: Colors.grey.shade300,
                        ),
                        SizedBox(height: height * 0.01),
                        Container(
                          width: width * 0.10, // 👈 narrower like text
                          height: height * 0.015,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Real Category Item
                  //   final category = categories[index];
                  final color =
                      Colors.primaries[index % Colors.primaries.length];

                  return SizedBox(
                    width: width * 0.20, // fixed width so both match
                    child: GestureDetector(
                      onTap: () {
                        //   case 0:
                        if (index == 0) {
                          dashboardController.goToPage(11);
                        } else if (index == 1) {
                          dashboardController.goToPage(12);
                        } else if (index == 2) {
                          dashboardController.goToPage(13);
                        } else if (index == 3) {
                          dashboardController.goToPage(4);
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: width * 0.08,
                            // backgroundColor: color.withOpacity(0.2),
                            backgroundColor: AppColors.dividercolor.withOpacity(
                              0.2,
                            ),
                            child: Image.asset(
                              AppAllList.categoryIcon[index],
                              width: width * 0.07,
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          AppCustomTexts(
                            //  TextName: category.name,
                            TextName: AppAllList.categoryIconName[index],
                            textStyle: Theme.of(context).textTheme.displaySmall!
                                .copyWith(fontFamily: "Times New Roman"),
                            maxLine: 1, //  avoid text overflow
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          }),
        ),
      ],
    );
  }

  /// ----------------- Trending / Near You Toggle -----------------
  Widget _buildTrendingNearYou(
    BuildContext context,
    double height,
    double width,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Toggle Button Row
        buildCustomTabBar(
          tabs: ["Trending", "Near You"],
          selectedIndex: controller.selectedTabIndex,
          height: 45,
          borderRadius: 10,
        ),

        const SizedBox(height: 16),

        /// Show section based on selected tab
        Obx(() {
          if (controller.selectedTabIndex.value == 0) {
            return _buildTrendingSection(context, height, width);
          } else {
            return _buildNearYouSection(context, height, width);
          }
        }),
      ],
    );
  }

  Widget buildCustomTabBar({
    required List<String> tabs,
    required RxInt selectedIndex,
    double height = 45,
    double borderRadius = 8,
  }) {
    return AppCustomContainer(
      borderradius: borderRadius,
      height: height,
      color: AppColors.scaffoldBc,
      child: Obx(
        () => Row(
          children: List.generate(tabs.length, (index) {
            final isActive = selectedIndex.value == index;

            return Expanded(
              child: AppCustomContainer(
                borderradius: borderRadius,
                margin: const EdgeInsets.all(3),
                color: isActive ? AppColors.white : AppColors.scaffoldBc,
                child: GestureDetector(
                  onTap: () => selectedIndex.value = index,
                  child: Center(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      tabs[index],
                      style: Theme.of(Get.context!).textTheme.bodyLarge!
                          .copyWith(
                            fontFamily: "Times New Roman",
                            fontWeight: FontWeight.w600,
                            color: isActive ? AppColors.black : Colors.grey,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// ----------------- Trending Section -----------------
  Widget _buildTrendingSection(
    BuildContext context,
    double height,
    double width,
  ) {
    return Obx(() {
      if (controller.trendingIsLoading.value) {
        return _buildShimmerList(height, width);
      }

      if (controller.trendingItems.isEmpty) {
        return const Center(child: Text("Nothing is trending here"));
      }

      return _buildTrendingList(
        context: context,
        height: height,
        width: width,
        items: controller.trendingItems,
      );
    });
  }

  /// ----------------- List for Trending -----------------
  Widget _buildTrendingList({
    required BuildContext context,
    required double height,
    required double width,
    required List<TrendingItem> items,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return _buildBusinessCard(
          context: context,
          height: height,
          width: width,
          id: item.id,
          type: item.type,
          title: item.name,
          subtitle: item.shortDesc,
          category: item.category ?? item.type,
          imageUrl: item.image,
          extraText: item.price ?? item.location ?? "",
          showBoosted: true, //  Boosted only for Trending
        );
      },
    );
  }

  /// ----------------- Near You Section -----------------
  Widget _buildNearYouSection(
    BuildContext context,
    double height,
    double width,
  ) {
    return Obx(() {
      if (controller.nearYouLoading.value) {
        return _buildShimmerList(height, width);
      }

      if (controller.nearYouItems.isEmpty) {
        return const Center(child: Text("No businesses found near you"));
      }

      return _buildNearYouList(
        context: context,
        height: height,
        width: width,
        items: controller.nearYouItems,
      );
    });
  }

  /// ----------------- List for Near You -----------------
  Widget _buildNearYouList({
    required BuildContext context,
    required double height,
    required double width,
    required List<NearYouItem> items,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return _buildBusinessCard(
          context: context,
          height: height,
          width: width,
          id: item.id,
          type: item.type,
          title: item.name,
          subtitle: item.shortDesc,
          category: item.category,
          imageUrl: item.image,
          extraText: item.distance, // ✅ Near You → distance
          showBoosted: false,
        );
      },
    );
  }

  /// ----------------- Common Business Card -----------------
  Widget _buildBusinessCard({
    required BuildContext context,
    required double height,
    required double width,
    required int id,
    required String type,
    required String title,
    required String subtitle,
    required String category,
    required String imageUrl,
    required String extraText,
    required bool showBoosted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = constraints.maxWidth;
          final cardHeight = height * 0.14;
          final imageWidth = cardWidth * 0.28;
          final imageHeight = cardHeight * 0.85;
          final fontScale = (cardWidth / 400).clamp(0.85, 1.2);

          return SizedBox(
            height: cardHeight,
            child: InkWell(
              onTap: () {
                final typee = type.toLowerCase(); // normalize

                switch (typee) {
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

                  default:
                    dashboardController.goToPage(17);
                }
              },

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: [
                      // Thumbnail
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),

                          // Boosted tag only for Trending
                          if (showBoosted)
                            Positioned(
                              top: 6,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade400,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bolt_outlined,
                                      size: 13 * fontScale,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    AppCustomTexts(
                                      TextName: "Trending",
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                            fontSize: 11 * fontScale,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),

                      SizedBox(width: cardWidth * 0.03),

                      // Business Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.dividercolor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: const EdgeInsets.all(4.0),
                              child: AppCustomTexts(
                                TextName: category,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12 * fontScale,
                                    ),
                                maxLine: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            AppCustomTexts(
                              TextName: title,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14 * fontScale,
                                  ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppCustomTexts(
                              TextName: subtitle,
                              textStyle: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12 * fontScale,
                                    color: Colors.grey.shade800,
                                  ),
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13 * fontScale,
                                      color: Colors.black, // default
                                    ),
                                children: [
                                  if (showBoosted) ...[
                                    TextSpan(
                                      text: extraText,
                                      style: TextStyle(
                                        color: Colors
                                            .black, // highlight boosted text
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ] else ...[
                                    const TextSpan(text: "Distance: "),
                                    TextSpan(
                                      text: extraText.isNotEmpty
                                          ? "$extraText km"
                                          : "",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor, // highlight distance
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ----------------- Shimmer Loader -----------------
  Widget _buildShimmerList(double height, double width) {
    final cardHeight = height * 0.14;
    final imageWidth = width * 0.28;
    final imageHeight = cardHeight * 0.85;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            height: cardHeight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  children: [
                    /// Image shimmer
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: imageWidth,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.03),

                    /// Text shimmer
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildShimmerBox(width * 0.3, 14),
                          _buildShimmerBox(width * 0.5, 16),
                          _buildShimmerBox(width * 0.4, 12),
                          _buildShimmerBox(width * 0.2, 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerBox(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  // Offers Section
  Widget _buildOffers(
    BuildContext context,
    double height,
    double width,
    BoxConstraints constraints,
    controller,
  ) {
    final dashboardController = Get.find<DashboardController>();

    return Obx(() {
      if (controller.isOffersLoading.value) {
        // ✅ Shimmer loading effect
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: height * 0.16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          }),
        );
      }

      if (controller.offersErrorMessage.value.isNotEmpty) {
        return Align(
          alignment: Alignment.center,
          child: Text(
            controller.offersErrorMessage.value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }

      final offers = controller.offers;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppCustomTexts(
                TextName: 'Nearby Offers',
                textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  AppCustomTexts(
                    action: () {
                      dashboardController.goToPage(20);
                    },
                    TextName: "See All  ",
                    textStyle: Theme.of(context).textTheme.displaySmall!
                        .copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Times New Roman",
                        ),
                  ),
                  Icon(Icons.arrow_forward, size: constraints.maxWidth * 0.04),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.02),

          //  Offer Cards
          offers.isEmpty
              ? Column(
                  children: [
                    Icon(
                      Icons.local_offer,
                      size: constraints.maxWidth * 0.08,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: height * 0.01),
                    AppCustomTexts(
                      TextName: "Nothing special offers at this time",
                      textStyle: Theme.of(context).textTheme.displayMedium!
                          .copyWith(color: AppColors.dividercolor),
                    ),
                  ],
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: offers.length,
                  separatorBuilder: (_, __) => SizedBox(height: height * 0.02),
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // 🔑 Responsive scaling factors
                        final cardWidth = constraints.maxWidth;
                        final cardHeight = (height * 0.16).clamp(
                          120.0,
                          180.0,
                        ); // clamp min/max
                        final imageWidth = cardWidth * 0.28;
                        final imageHeight = cardHeight * 0.75;
                        final fontScale = (cardWidth / 380).clamp(
                          0.8,
                          1.3,
                        ); // scaling

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: AppColors.white,
                          child: Padding(
                            padding: EdgeInsets.all(cardWidth * 0.03),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    offer.image,
                                    width: imageWidth,
                                    height: imageHeight,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.local_offer,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                  ),
                                ),
                                SizedBox(width: cardWidth * 0.04),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      AppCustomTexts(
                                        TextName: offer.title,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14 * fontScale,
                                            ),
                                        maxLine: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: cardHeight * 0.08),
                                      AppCustomTexts(
                                        TextName: offer.description,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey.shade800,
                                              fontFamily: "Times New Roman",
                                              fontSize: 12 * fontScale,
                                            ),
                                        maxLine: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: cardHeight * 0.08),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: AppCustomButton(
                                          height: (cardHeight * 0.25).clamp(
                                            28.0,
                                            40,
                                          ),
                                          width: (cardWidth * 0.3).clamp(
                                            90.0,
                                            140.0,
                                          ),
                                          borderradius: 8,
                                          color: AppColors.buttonColor,
                                          action: () {
                                            // old: dashboardController.goToPage(20, args: offer)
                                            // ✅ FIX: pass only offer.id
                                            offersController.selectedId.value =
                                                offer.id;
                                            dashboardController.goToPage(20);
                                          },
                                          CustomName: Center(
                                            child: AppCustomTexts(
                                              TextName: "Claim Now",
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontSize: 12 * fontScale,
                                                    color: AppColors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                        "Times New Roman",
                                                  ),
                                            ),
                                          ),
                                        ),
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
                  },
                ),
        ],
      );
    });
  }

  Widget _buildGradientInfoCard(
    BuildContext context,
    double height,
    double width,
    BoxConstraints constraints,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: constraints.maxWidth * 0.9,
          //height: constraints.maxHeight * 0.45,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFB3E5FC), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: constraints.maxWidth * 0.16,
                height: constraints.maxHeight * 0.08,
                decoration: const BoxDecoration(
                  color: Color(0xFF81D4FA),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_outlined,
                    size: 40,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: height * 0.015),
              AppCustomTexts(
                TextName: title,
                textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                Textalign: TextAlign.center,
              ),
              SizedBox(height: height * 0.015),
              AppCustomTexts(
                TextName: description,
                textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                  fontFamily: "Times New Roman",
                ),
                Textalign: TextAlign.center,
              ),

              SizedBox(height: height * 0.015),
              AppCustomButton(
                borderradius: 10,
                action: () {
                  dashboardController.goToPage(10);
                },
                height: height * 0.04,
                width: width * 0.5,
                CustomName: AppCustomTexts(
                  TextName: "Start Advertising Now",
                  textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontFamily: "Times New Roman",
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showReferralPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: user can't tap outside
      builder: (context) {
        final mediaQuery = MediaQuery.of(context).size;

        // Auto dismiss after 3.5 seconds
        Future.delayed(const Duration(milliseconds: 3000), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/referal.png',
                    height: mediaQuery.height * 0.2,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '🎉 Claim Your Rewards!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                // Subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Invite friends and earn points instantly.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 20),

                // Gradient Claim button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Share.share("Use my referral code: ABC123XYZ");
                        if (Navigator.canPop(context)) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlueAccent],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Claim Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
