import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:sparqly/app/constants/App_All_list.dart';
import 'package:sparqly/app/link_controller.dart';
import 'package:sparqly/app/modules/referal/controllers/referal_controller.dart';
import 'package:sparqly/app/services/api_services/apiServices.dart';
import 'package:sparqly/app/services/location%20services/Location.dart';
import '../../../models/Home_Api_Models.dart';
import '../../../models/Post_listing_Models/nearBy_offer_models.dart';
import '../../../models/Post_listing_Models/near_You_model.dart';
import '../../../models/Post_listing_Models/trending_Home_model.dart';
import '../../splash/controllers/subscriptionCheckController.dart'; // your service file

class HomeController extends GetxController {
  var selectedTabIndex = 0.obs; // 0 = Trending, 1 = Near You

  final CarouselSliderController carouselController =
      CarouselSliderController();
  final businesses = AppAllList.categories;
  final crosalpage = 0.obs;

  var selectedLocation = 'All'.obs;
  final LocationAccesss locationService = LocationAccesss();
  final ReferalController referalController = Get.put(ReferalController());
  final subscriptionController = Get.find<SubscriptionCheckController>();

  ///  NEW: global loading state
  var isHomeLoading = true.obs;

  List<String> get allLocations {
    final locs = businesses
        .map((b) => b['location'] as String)
        .toSet()
        .toList();
    locs.sort();
    return ['All', ...locs];
  }

  // -------------------- INIT --------------------
  @override
  void onInit() {
    super.onInit();
    initData();
    //referalController.showReferralPopup();
    // 🚀 LOAD SUBSCRIPTION IMMEDIATELY
    subscriptionController.loadSubscription();
  }

  @override
  void onReady() {
    super.onReady();
    // Deep link se aane pe referral popup mat dikhao
    final linkController = Get.find<LinkController>();
    if (linkController.hasPendingDeepLink) {
      print('🔗 Deep link detected, skipping referral popup');
      return;
    }
    Future.delayed(Duration.zero, () {
      referalController.showReferralPopup();
    });
  }

  Future<void> initData() async {
    try {
      isHomeLoading.value = true;

      // Run hero + trending instantly
      await Future.wait([fetchHeroSections(), fetchTrending()]);

      // Wait for location (cached + GPS update)
      await fetchUserLocation();

      // Load APIs that require location
      await Future.wait([fetchNearbyOffers(), fetchExploreData()]);
    } finally {
      isHomeLoading.value = false;
    }
  }

  // -------------------- LOCATION --------------------
  Future<void> fetchUserLocation() async {
    try {
      await locationService.locationaccess();

      // ⚡ Only fetch GPS if lat/lng not set yet
      if (locationService.latitude.value == 0.0 &&
          locationService.longitude.value == 0.0) {
        await locationService.getposition();
      }

      if (locationService.subtitlelocation.isNotEmpty) {
        selectedLocation.value = locationService.subtitlelocation.value
            .split(",")
            .first
            .trim();
      }
    } catch (e) {
      print("❌ Location fetch failed: $e");
    }
  }

  // -------------------- HERO --------------------
  var heroIsLoading = false.obs;
  var heroSections = <HeroSection>[].obs;
  var ads = <AdSection>[].obs;
  var combinedBanners = <BannerItem>[].obs;
  var errorMessage = ''.obs;

  final ApiServices _service = ApiServices();

  Future<void> fetchHeroSections() async {
    try {
      heroIsLoading.value = true;
      errorMessage.value = '';

      final response = await _service.fetchHeroSections();
      if (response != null && response.status) {
        heroSections.assignAll(response.data.heroSection);
        ads.assignAll(response.data.ads);

        combinedBanners.assignAll([
          ...heroSections.map((h) => BannerItem.fromHero(h)),
          ...ads.map((a) => BannerItem.fromAd(a)),
        ]);

        print("✅ Loaded Banners: ${combinedBanners.length}");
      } else {
        errorMessage.value = response?.message ?? 'Failed to load data';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      heroIsLoading.value = false;
    }
  }

  // -------------------- OFFERS --------------------
  var isOffersLoading = false.obs;
  var offers = <NearbyOfferData>[].obs;
  var offersErrorMessage = "".obs;

  Future<void> fetchNearbyOffers() async {
    try {
      isOffersLoading.value = true;
      offersErrorMessage.value = "";

      final lat = locationService.latitude.value;
      final lng = locationService.longitude.value;
      print("🌍 Fetching nearby offers with lat=$lat, lng=$lng");

      final response = await ApiServices().fetchNearbyOffers(
        latitude: lat,
        longitude: lng,
      );

      if (response != null && response.success) {
        offers.assignAll(response.data.take(6).toList());
        print("✅ Nearby offers loaded: ${offers.length}");
      } else {
        offersErrorMessage.value =
            response?.message ?? "Failed to fetch offers";
      }
    } catch (e) {
      offersErrorMessage.value = "Unexpected error: $e";
    } finally {
      isOffersLoading.value = false;
    }
  }

  // -------------------- NEAR YOU --------------------
  var nearYouLoading = false.obs;
  var nearYouErrorMessage = "".obs;
  var nearYouItems = <NearYouItem>[].obs;

  Future<void> fetchExploreData() async {
    try {
      nearYouLoading.value = true;
      nearYouErrorMessage.value = "";
      final result = await ApiServices().fetchExploreData(
        latitude: locationService.latitude.value,
        longitude: locationService.longitude.value,
      );

      if (result.success && result.data.isNotEmpty) {
        nearYouItems.assignAll(result.data.take(4).toList());
        print("✅ Explore Data Loaded: ${nearYouItems.length}");
      } else {
        nearYouErrorMessage.value = "⚠️ Invalid API response";
      }
    } catch (e) {
      nearYouErrorMessage.value = e.toString();
    } finally {
      nearYouLoading.value = false;
    }
  }

  // -------------------- TRENDING --------------------
  var trendingIsLoading = false.obs;
  var trendingErrorMessage = "".obs;

  var trendingItems = <TrendingItem>[].obs;

  Future<void> fetchTrending() async {
    try {
      trendingIsLoading.value = true;
      trendingErrorMessage.value = "";

      final response = await ApiServices().fetchTrendingData();

      if (response.success && response.data.isNotEmpty) {
        // ✅ Only keep 5 items
        final limited = response.data.take(4).toList();
        trendingItems.assignAll(limited);

        print(
          "🔥 Trending Data Loaded: ${trendingItems.length} items (limited to 5)",
        );
      } else {
        trendingErrorMessage.value = "⚠️ Invalid API response";
      }
    } catch (e) {
      trendingErrorMessage.value = e.toString();
      print("❌ Trending Error: $e");
    } finally {
      trendingIsLoading.value = false;
    }
  }
}
