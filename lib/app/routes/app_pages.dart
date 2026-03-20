import 'package:get/get.dart';

import '../modules/ad_listings/bindings/ad_listings_binding.dart';
import '../modules/ad_listings/views/ad_listings_view.dart';
import '../modules/business/bindings/business_binding.dart';
import '../modules/business/views/business_view.dart';
import '../modules/business_detail_page/bindings/business_detail_page_binding.dart';
import '../modules/business_detail_page/views/business_detail_page_view.dart';
import '../modules/business_listings/bindings/business_listings_binding.dart';
import '../modules/business_listings/views/business_listings_view.dart';
import '../modules/categories/bindings/categories_binding.dart';
import '../modules/categories/views/categories_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chatList.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/courseDetailUi/bindings/course_detail_ui_binding.dart';
import '../modules/courseDetailUi/views/course_detail_ui_view.dart';
import '../modules/course_listings/bindings/course_listings_binding.dart';
import '../modules/course_listings/views/course_listings_view.dart';
import '../modules/course_webview_screen/bindings/course_webview_screen_binding.dart';
import '../modules/course_webview_screen/views/course_webview_screen_view.dart';
import '../modules/courses/bindings/courses_binding.dart';
import '../modules/courses/views/courses_view.dart';
import '../modules/create/bindings/create_binding.dart';
import '../modules/create/views/create_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/influencer_detail_page/bindings/influencer_detail_page_binding.dart';
import '../modules/influencer_detail_page/views/influencer_detail_page_view.dart';
import '../modules/influencers/bindings/influencers_binding.dart';
import '../modules/influencers/views/influencers_view.dart';
import '../modules/influencers_listings/bindings/influencers_listings_binding.dart';
import '../modules/influencers_listings/views/influencers_listings_view.dart';
import '../modules/jobs/bindings/jobs_binding.dart';
import '../modules/jobs/views/jobs_view.dart';
import '../modules/jobs_detail_page/bindings/jobs_detail_page_binding.dart';
import '../modules/jobs_detail_page/views/jobs_detail_page_view.dart';
import '../modules/jobs_listings/bindings/jobs_listings_binding.dart';
import '../modules/jobs_listings/views/jobs_listings_view.dart';
import '../modules/myCourses/bindings/my_courses_binding.dart';
import '../modules/myCourses/views/my_courses_view.dart';
import '../modules/offers/bindings/offers_binding.dart';
import '../modules/offers/views/offers_view.dart';
import '../modules/offers_listings/bindings/offers_listings_binding.dart';
import '../modules/offers_listings/views/offers_listings_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/referal/bindings/referal_binding.dart';
import '../modules/referal/views/referal_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/subscription/bindings/subscription_binding.dart';
import '../modules/subscription/views/subscription_view.dart';

part 'app_routes.dart';

class AppPage {
  AppPage._();

  final String initialpage = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(name: Routes.HOME, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.CATEGORIES,
      page: () => CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: Routes.CREATE,
      page: () => CreateView(),
      binding: CreateBinding(),
    ),
    GetPage(
      name: Routes.OFFERS,
      page: () => OffersView(),
      binding: OffersBinding(),
    ),
    GetPage(
      name: Routes.COURSES,
      page: () => CoursesView(),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: Routes.BUSINESS_LISTINGS,
      page: () => BusinessListingsView(),
      binding: BusinessListingsBinding(),
    ),
    GetPage(
      name: Routes.JOBS_LISTINGS,
      page: () => JobsListingsView(),
      binding: JobsListingsBinding(),
    ),
    GetPage(
      name: Routes.INFLUENCERS_LISTINGS,
      page: () => InfluencersListingsView(),
      binding: InfluencersListingsBinding(),
    ),
    GetPage(
      name: Routes.COURSE_LISTINGS,
      page: () => CourseListingsView(),
      binding: CourseListingsBinding(),
    ),
    GetPage(
      name: Routes.OFFERS_LISTINGS,
      page: () => OffersListingsView(),
      binding: OffersListingsBinding(),
    ),
    GetPage(
      name: Routes.AD_LISTINGS,
      page: () => AdListingsView(),
      binding: AdListingsBinding(),
    ),
    GetPage(
      name: '/business-list', // ✅ change
      page: () => BusinessView(),
      binding: BusinessBinding(),
    ),
    GetPage(name: Routes.JOBS, page: () => JobsView(), binding: JobsBinding()),
    GetPage(
      name: Routes.INFLUENCERS,
      page: () => InfluencersView(),
      binding: InfluencersBinding(),
    ),
    GetPage(
      name: Routes.COURSE_DETAIL_UI,
      page: () => CourseDetailView(),
      binding: CourseDetailUiBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.BUSINESS_DETAIL_PAGE,
      page: () => BusinessDetailPageView(),
      binding: BusinessDetailPageBinding(),
    ),
    GetPage(
      name: Routes.JOBS_DETAIL_PAGE,
      page: () => JobsDetailPageView(),
      binding: JobsDetailPageBinding(),
    ),
    GetPage(
      name: Routes.INFLUENCER_DETAIL_PAGE,
      page: () => InfluencerDetailPageView(),
      binding: InfluencerDetailPageBinding(),
    ),
    // GetPage(
    //   name: Routes.OFFERS_DETAIL_PAGE,
    //   page: () => OffersDetailPageView(),
    //   binding: OffersDetailPageBinding(),
    // ),
    GetPage(
      name: Routes.CHAT_LIST,
      page: () => ChatListScreen(),
      binding: ChatBinding(),
    ),
    GetPage(name: Routes.CHAT, page: () => ChatView(), binding: ChatBinding()),
    GetPage(
      name: Routes.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    // GetPage(
    //   name: Routes.REVIEW_RATING,
    //   page: () =>  ReviewRatingView(),
    //   binding: ReviewRatingBinding(),
    // ),
    GetPage(
      name: Routes.SUBSCRIPTION,
      page: () => SubscriptionView(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: Routes.REFERAL,
      page: () => ReferalView(),
      binding: ReferalBinding(),
    ),
    GetPage(
      name: Routes.MY_COURSES,
      page: () => const MyCoursesView(),
      binding: MyCoursesBinding(),
    ),
    GetPage(
      name: Routes.COURSE_WEBVIEW_SCREEN,
      page: () => const CourseWebviewScreenView(),
      binding: CourseWebviewScreenBinding(),
    ),
  ];
}
