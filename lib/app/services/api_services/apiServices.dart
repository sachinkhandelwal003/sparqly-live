import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as _dio;
import 'package:http_parser/http_parser.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sparqly/app/models/Post_listing_Models/course_Listing_models.dart';
import '../../models/Get_Models_All/All_Detail_ui_models/course_model.dart';
import '../../models/Get_Models_All/Subscription_Plan_Activation_model.dart';
import '../../models/Get_Models_All/adOfferPrice.dart';
import '../../models/Get_Models_All/analytics_model.dart';
import '../../models/Get_Models_All/bookmark_model.dart';
import '../../models/Get_Models_All/course_Get_Models.dart';
import '../../models/Get_Models_All/priority_search_request.dart';
import '../../models/Get_Models_All/profile_user_listing_model.dart';
import '../../models/Get_Models_All/subscription_model.dart';
import '../../models/Home_Api_Models.dart';
import '../../models/Post_listing_Models/Ad_Listing_model.dart';
import '../../models/Post_listing_Models/nearBy_offer_models.dart';
import '../../models/Post_listing_Models/near_You_model.dart';
import '../../models/Post_listing_Models/trending_Home_model.dart';

class ApiServices {
  // final String baseUrl = "https://sparkly.kotiboxskillxacademy.com/api";
  final String baseUrl = "https://backend.sparqly.in/api";


  void addCurriculumFields(
      http.MultipartRequest request,
      List<dynamic> curriculum,
      ) {
    for (int i = 0; i < curriculum.length; i++) {
      final chapter = curriculum[i];

      request.fields["curriculum[$i][chapter_title]"] =
          chapter["chapter_title"].toString();

      final modules = chapter["modules"] as List;

      for (int j = 0; j < modules.length; j++) {
        final module = modules[j];

        request.fields["curriculum[$i][modules][$j][type]"] =
            module["type"].toString();

        request.fields["curriculum[$i][modules][$j][module_title]"] =
            module["module_title"].toString();

        final details = module["details"] as Map<String, dynamic>;

        if (details["description"] != null) {
          request.fields[
          "curriculum[$i][modules][$j][details][description]"] =
              details["description"].toString();
        }

        if (details["video_link"] != null) {
          request.fields[
          "curriculum[$i][modules][$j][details][video_link]"] =
              details["video_link"].toString();
        }
      }
    }
  }


  // Category Dropdown API
  Future<dynamic> getRequest(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    print("🌍 [API REQUEST] → GET $url");

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException("⏳ [TIMEOUT] Request to $url timed out");
        },
      );

      print("📩 [API RESPONSE] Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          print("✅ [API SUCCESS] Data: $jsonData");
          return jsonData;
        } on FormatException catch (e) {
          print("⚠️ [JSON ERROR] Failed to parse response from $url");
          print("📄 Raw Body: ${response.body}");
          throw Exception("Invalid JSON format: $e");
        }
      } else {
        print("❌ [SERVER ERROR] ${response.statusCode} → ${response.reasonPhrase}");
        print("📄 Response Body: ${response.body}");
        throw HttpException(
          "Server error ${response.statusCode}: ${response.reasonPhrase}",
          uri: url,
        );
      }
    } on SocketException catch (e) {
      print("⚠️ [NETWORK ERROR] No Internet for $url → $e");
      throw Exception("No Internet Connection. Please check your network.");
    } on TimeoutException catch (e) {
      print("⚠️ [TIMEOUT ERROR] $url → $e");
      throw Exception("API request to $url timed out.");
    } catch (e, stackTrace) {
      print("⚠️ [UNEXPECTED ERROR] at $url");
      print("   Error: $e");
      print("   StackTrace: $stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }



  Future<T?> postItem<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    String? imagePath,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/$endpoint");
      var request = http.MultipartRequest("POST", uri);

      final token = GetStorage().read('auth_token');
      if (token != null && token.isNotEmpty) {
        request.headers.addAll({
          "Authorization": "Bearer $token",
        });
      }

      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      if (imagePath != null && imagePath.isNotEmpty) {
        print("📷 Uploading image: $imagePath");
        request.files.add(
          await http.MultipartFile.fromPath("image", imagePath),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Raw Response: ${response.body}");
      print("📩 Status Code: ${response.statusCode}");

      final decoded = json.decode(response.body);

      // ✅ SUCCESS
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return fromJson(decoded);
      }

      // ❌ ERROR → THROW BACKEND MESSAGE
      final message = decoded is Map && decoded['message'] != null
          ? decoded['message']
          : "Request failed with status ${response.statusCode}";

      throw Exception(message);

    } catch (e) {
      print("❌ postItem Error: $e");
      rethrow; // 🔥 THIS IS CRITICAL
    }
  }




  // Hero Section Api (Home SlideBar)

  Future<HeroSectionResponse?> fetchHeroSections() async {
    try {
      var uri = Uri.parse("$baseUrl/get-hero-section"); // replace with your endpoint
      print("🌍 API Request: $uri");

      var response = await http.get(uri);

      print("📩 Status Code: ${response.statusCode}");
      print("📩 Raw Response: ${response.body}");

      if (response.statusCode == 201) { // ✅ changed to 200
        final jsonData = json.decode(response.body);
        print("✅ Parsed JSON: $jsonData");
        return HeroSectionResponse.fromJson(jsonData);
      } else {
        print("❌ API Error: ${response.statusCode}");
        print("❌ Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }





  // Send OTP
  Future<http.Response> sendOtp(String mobile) async {
    var url = Uri.parse("$baseUrl/send-otp");

    return await http.post(
      url,
      body: {
        "mobile": mobile,
      },
    );
  }



  /// ✅ Verify OTP
  Future<http.Response> verifyOtp(String mobile, String otp) async {
    var url = Uri.parse("$baseUrl/verify-otp");

    return await http.post(
      url,
      body: {
        "mobile": mobile,
        "otp": otp,
      },
    );
  }


  // Get Item Get Reusable Api For all (business , jobs , influencer , course , offer)

   Future<T?> getItem<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/$endpoint");

      // ✅ token from GetStorage (optional)
      final token = GetStorage().read('auth_token');
      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        print("❌ GET Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ GET Exception: $e");
      return null;
    }

  }



  // Get Detail page Item  Reusable Api For all (business , jobs , influencer , course , offer)

  Future<T?> getDetailItem<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/$endpoint");

      // ✅ token from GetStorage (optional)
      final token = GetStorage().read('auth_token');
      final headers = {
        "Content-Type": "application/json",
        if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);

        // Pass whole JSON, not just data
        return fromJson(jsonData);
      } else {
        print("❌ GET Failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ GET Exception: $e");
      return null;
    }
  }




   // Post Api Course Course Listing

  Future<T?> postCourse<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    String? imagePath, // main course image
    Map<String, File>? extraFiles, // document files
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/$endpoint");
      var request = http.MultipartRequest("POST", uri);

      // Add token
      final token = GetStorage().read('auth_token');
      if (token != null && token.isNotEmpty) {
        request.headers.addAll({"Authorization": "Bearer $token"});
      }

      // Add all fields including curriculum as JSON string
      body.forEach((key, value) {
        if (value == null) return;

        if (key == "curriculum") {
          addCurriculumFields(request, value as List);
        } else {
          request.fields[key] = value.toString();
        }
      });


      // Add main image
      if (imagePath != null && imagePath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath("image", imagePath));
      }

      // Add extra files (documents)
      if (extraFiles != null) {
        for (var entry in extraFiles.entries) {
          request.files.add(await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
            contentType: MediaType("application", "octet-stream"),
          ));
        }
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📩 Raw Response: ${response.body}");
      print("📩 Status Code: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        try {
          final err = json.decode(response.body);
          print("❌ API Error Body: $err");
        } catch (_) {
          print("❌ API Error (non-JSON): ${response.body}");
        }
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }





  Future<List<CourseCategory>> fetchCourseDropdown() async {
    final token = GetStorage().read('auth_token');
    final response = await http.get(Uri.parse("$baseUrl/get-course-category"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print("Full API Response: $data");

      if (data["status"] == true) {
        final List list = data["data"];
        return list.map((e) => CourseCategory.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response from API: ${data['message']}");
      }
    } else {
      throw Exception("Failed to load categories: ${response.statusCode}");
    }
    // fetch reviews

  }





    //  Near By Offer

  Future<NearbyOfferModels?> fetchNearbyOffers({
    required double latitude,
    required double longitude,
  }) async {
    try {
      // 🔹 Try JSON request first
      var response = await http.post(
        Uri.parse("$baseUrl/get-near-by-offer"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
        }),
      ).timeout(const Duration(seconds: 15));

      print("📡 JSON Request -> lat=$latitude, lng=$longitude");
      print("📩 Response JSON -> ${response.statusCode}: ${response.body}");

      var jsonData = json.decode(response.body);

      //  If response empty, retry with form-data
      if (jsonData["data"] == null || (jsonData["data"] as List).isEmpty) {
        response = await http.post(
          Uri.parse("$baseUrl/get-near-by-offer"),
          body: {
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
          },
        ).timeout(const Duration(seconds: 15));

        print("📡 Form Request -> lat=$latitude, lng=$longitude");
        print("📩 Response Form -> ${response.statusCode}: ${response.body}");

        jsonData = json.decode(response.body);
      }

      return NearbyOfferModels.fromJson(jsonData);
    } catch (e) {
      print("❌ Error fetching offers: $e");
      return null;
    }
  }


  // Course Get Api

  Future<List<CoursePage>> fetchCourses() async {
    try {
      final token = GetStorage().read('auth_token'); // your saved token
      final uri = Uri.parse("$baseUrl/get-courses");

      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token", // Add the token here
        "Accept": "application/json"
      }).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException("Request to $uri timed out after 15 seconds.");
        },
      );

      print("✅ API Response [Status ${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final courseResponse = CourseGetModels.fromJson(data);

        if (courseResponse.status && courseResponse.data.isNotEmpty) {
          return courseResponse.data;
        } else {
          throw Exception(
              "API returned empty data or status=false. Message: ${courseResponse.message}");
        }
      } else if (response.statusCode == 401) {
        throw Exception("Unauthorized. Please login again.");
      } else {
        throw HttpException(
            "Failed to load courses. Status Code: ${response.statusCode}, Body: ${response.body}");
      }
    } on TimeoutException catch (e) {
      print("⏱ Timeout Error: $e");
      throw Exception("Request timed out. Please try again.");
    } on SocketException catch (e) {
      print("📡 Network Error: $e");
      throw Exception("No internet connection. Please check your network.");
    } on FormatException catch (e, stack) {
      print("📄 Format Error: $e\nStack: $stack");
      throw Exception("Bad response format. Unable to parse data.");
    } catch (e, stack) {
      print("❌ Unexpected Error: $e\nStack: $stack");
      throw Exception("Unexpected error occurred: $e");
    }

  }


  Future<CourseDetailPageModel?> fetchCourseDetail(int courseId, String token) async {
    try {
      final uri = Uri.parse("$baseUrl/course-details").replace(
        queryParameters: {
          "course_id": courseId.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      // Log full response for debugging
      print("API Request: GET $uri");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CourseDetailPageModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        print("Error: Unauthorized (401). Token may be invalid or expired.");
        return null;
      } else if (response.statusCode == 404) {
        print("Error: Not Found (404). Check your endpoint.");
        return null;
      } else if (response.statusCode >= 500) {
        print("Server Error: ${response.statusCode}. Try again later.");
        return null;
      } else {
        print("Unexpected Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      // Catch any other errors such as network issues or JSON parsing errors
      print("Exception in fetchCourseDetail: $e");
      return null;
    }
  }






  //  Home Near You Api

  Future<NearYouResponse> fetchExploreData({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse("$baseUrl/get-near-by"); // adjust endpoint
    print("🌍 API Request → $url | lat=$latitude lng=$longitude");

    try {
      final response = await http
          .post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        }),
      )
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException("⏳ API request timed out");
      });

      print("📩 API Response Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        print("✅ API Response Data: $jsonData");

        return NearYouResponse.fromJson(jsonData);
      } else {
        print("❌ Server Error: ${response.body}");
        throw HttpException(
            "Server error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on SocketException {
      print("⚠️ No Internet Connection");
      throw Exception("No Internet Connection. Please check your network.");
    } on TimeoutException {
      print("⚠️ API request timed out");
      throw Exception("API request timed out. Try again.");
    } on FormatException catch (e) {
      print("⚠️ JSON Parsing Error: $e");
      throw Exception("Invalid response format. Please contact support.");
    } catch (e, stackTrace) {
      print("⚠️ Unexpected Error: $e\n$stackTrace");
      throw Exception("Unexpected error: $e");
    }
  }

  // Trending api
   Future<TrendingResponse> fetchTrendingData() async {
    final url = Uri.parse("${baseUrl}/tranding-lists");

    try {
      final response = await http
          .get(url, headers: {"Accept": "application/json"})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("✅ API Response Data: $jsonData");
        return TrendingResponse.fromJson(jsonData);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No internet connection");
    } on TimeoutException {
      throw Exception("Request timed out");
    } on FormatException {
      throw Exception("Invalid response format");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }



  // Reviwes Api

  Future<Map<String, dynamic>> submitReview({
    required String endpoint,
    required String idField,
    required int idValue,
    required int rating,
    required String review,
    int? reviewId, // optional for edit
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final token = GetStorage().read('auth_token');

    final headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    };

    final body = {
      idField: idValue.toString(),
      "rating": rating.toString(),
      "review": review,
    };

    if (reviewId != null) {
      body['review_id'] = reviewId.toString();
    }

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception("Failed to submit review: ${response.body}");
    }
  }




  /// ✅ Fetch Reviews
  Future<List<Map<String, dynamic>>> fetchReviewData({
    required String endpoint,
    required String idKey,   // e.g. "business_id", "user_id", "category_id"
    required int idValue,
  }) async {
    final uri = Uri.parse("$baseUrl/$endpoint")
        .replace(queryParameters: {idKey: idValue.toString()});

    final token = GetStorage().read('auth_token');

    final headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    };

    print("📤 Fetching Data: $uri");

    final response = await http.get(uri, headers: headers);

    print("📥 Response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data'] ?? [];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("❌ Failed to fetch data: ${response.body}");
    }
  }



  /// Delete Review by review ID
  Future<void> deleteReview({
    required String endpoint,
    required int reviewId, // 👈 use review id instead of businessId
  }) async {
    final url = Uri.parse("$baseUrl/$endpoint");
    final token = GetStorage().read('auth_token');

    final headers = {
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    };

    final body = {
      "review_id": reviewId.toString(), // 👈 pass the review id
    };

    print("🗑️ Deleting Review: $body to $url");

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    print("📥 Response (${response.statusCode}): ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print("✅ Review deleted successfully");
    } else {
      throw Exception("❌ Failed to delete review: ${response.body}");
    }
  }



  // Ad User Listing code
  Future<AdUserListingResponse?> fetchUserListings() async {
    final url = Uri.parse("$baseUrl/user-listing"); // your endpoint
    final token = GetStorage().read('auth_token');
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token", // <-- Add auth token here
          "Content-Type": "application/json",
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("Error: Request timed out");
          throw Exception("Request timed out");
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        // Validate JSON structure
        if (jsonData is Map<String, dynamic>) {
          return AdUserListingResponse.fromJson(jsonData);
        } else {
          print("Error: Unexpected JSON format");
          throw Exception("Unexpected JSON format");
        }
      } else if (response.statusCode == 401) {
        print("Error: Unauthorized access (401)");
        throw Exception("Unauthorized access – please check your token");
      } else if (response.statusCode == 403) {
        print("Error: Forbidden (403)");
        throw Exception("Forbidden – you don’t have permission");
      } else if (response.statusCode == 404) {
        print("Error: Endpoint not found (404)");
        throw Exception("Endpoint not found");
      } else {
        print("Error: Server returned status ${response.statusCode}");
        throw Exception("Server error: ${response.statusCode}");
      }
    } on SocketException {
      print("Error: No internet connection");
      throw Exception("No internet connection");
    } on FormatException {
      print("Error: Bad response format");
      throw Exception("Bad response format");
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception("Unexpected error: $e");
    }
  }




  // Logout Api

  Future<Map<String, dynamic>?> logoutUser() async {
    try {

      final token = GetStorage().read('auth_token');

      final response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Logout failed with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error during logout: $e");
      return null;
    }
  }



  Future<bool> addBookmark({required String type, required int id}) async {
    try {
      final token = GetStorage().read('auth_token'); // optional token auth
      if (token == null) {
        print("User not logged in. Token is null.");
        return false;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/bookmark"), // replace with your endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "type": type,
          "id": id,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == true) {
          fetchBookmarks();
          print("Bookmark added successfully: ${jsonData['message']}");
          return true;
        } else {
          print("Failed to add bookmark: ${jsonData['message']}");
          return false;
        }
      } else {
        print("Failed to add bookmark. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e, stackTrace) {
      print("Exception occurred while adding bookmark: $e");
      print(stackTrace);
      return false;
    }
  }

  // BookMark Api
  Future<BookmarkResponse?> fetchBookmarks() async {
    const debugTag = "🔖🟢[Bookmark API]";
    final url = Uri.parse("$baseUrl/get-user-bookmarks");
    final token = GetStorage().read("auth_token");

    try {
      print("$debugTag 🚀 Starting API call...");
      print("$debugTag 🌍 URL: $url");
      print("$debugTag 🔑 Token: $token");

      final response = await http
          .get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      )
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException("Request to $url timed out after 15 seconds");
      });

      print("$debugTag 📡 Status Code: ${response.statusCode}");
      print("$debugTag 📦 Raw Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          print("$debugTag ✅ Parsed JSON: $jsonData");
          return BookmarkResponse.fromJson(jsonData);
        } on FormatException catch (fe) {
          print("$debugTag ❌ JSON FormatException: $fe");
          return null;
        }
      } else if (response.statusCode == 401) {
        print("$debugTag 🔒 Unauthorized! Token may be invalid.");
        return null;
      } else if (response.statusCode == 404) {
        print("$debugTag 🚫 Endpoint not found: $url");
        return null;
      } else {
        print("$debugTag ⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on TimeoutException catch (te) {
      print("$debugTag ⏳ Timeout: $te");
      return null;
    } on SocketException catch (se) {
      print("$debugTag 🌐 No Internet: $se");
      return null;
    } catch (e, stackTrace) {
      print("$debugTag ❌ Unknown Exception: $e");
      print("$debugTag StackTrace: $stackTrace");
      return null;
    }
  }

  // Profile User Listing Get model
   Future<ProfileUserListingModel?> fetchListings() async {
    try {
      final uri = Uri.parse("$baseUrl/get-user-listing");
      final token = GetStorage().read("auth_token");
      final response = await http.get(uri, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          return ProfileUserListingModel.fromJson(jsonData);
        } else {
          print("API returned success=false: ${jsonData['message'] ?? 'No message'}");
          return null;
        }
      } else {
        print("HTTP Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } on SocketException {
      print("Network Error: Please check your internet connection");
      return null;
    } on HttpException {
      print("HTTP Exception: Failed to fetch data");
      return null;
    } on FormatException {
      print("Format Exception: Bad response format");
      return null;
    } on TimeoutException {
      print("Timeout Exception: Request took too long to complete");
      return null;
    } catch (e) {
      print("Unexpected Exception: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> sendInvite() async {
    final url = Uri.parse("$baseUrl/invite/store");
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.post(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          return data;
        } else {
          print("❌ API Error: ${data['message']}");
          return {"status": false, "message": data['message']};
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return {"status": false, "message": "Server returned ${response.statusCode}"};
      }
    } catch (e) {
      print("⚠️ Exception during API call: $e");
      return {"status": false, "message": "Something went wrong: $e"};
    }
  }

  Future<Map<String, dynamic>?> applyReferral(String referralCode) async {
    final url = Uri.parse("$baseUrl/apply-referral");
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json", // ✅ Add this
        },
        body: json.encode({
          "referral_code": referralCode,
        }),
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Referral Response: $data");
        return data;
      } else {
        print("❌ Failed response: ${response.statusCode} - ${response.body}");
        return {
          "status": false,
          "message": "Failed with status code ${response.statusCode}"
        };
      }
    } catch (e) {
      print("⚠️ Exception in Referral API: $e");
      return {"status": false, "message": "Error occurred: $e"};
    }
  }


  Future<Map<String, dynamic>?> sendMessage({
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    final url = Uri.parse("$baseUrl/chat/send"); // your API endpoint
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "sender_id": senderId,
          "receiver_id": receiverId,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["status"] == true) {
          return jsonData["data"]; // return message data
        } else {
          print("❌ API Error: ${jsonData["message"]}");
          return null;
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Exception in sendMessage(): $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMessages({
    required int senderId,
    required int receiverId,
  }) async {
    final url = Uri.parse("$baseUrl/chat/$receiverId");
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true) {
          final List messages = jsonData["data"];
          // Ensure each item is Map<String, dynamic>
          return messages.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e)).toList();
        } else {
          print("⚠️ API Error: ${jsonData["message"]}");
          return [];
        }
      } else {
        print("⚠️ HTTP Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Exception in fetchMessages(): $e");
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchChatUsers() async {
    final url = Uri.parse("$baseUrl/chat-users"); // ✅ your endpoint: {{base_url}}/chat
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true && jsonData["data"] != null) {
          return List<Map<String, dynamic>>.from(jsonData["data"]);
        } else {
          print("⚠️ No chat users found: ${jsonData["message"] ?? "Unknown error"}");
          return [];
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("❌ Exception in fetchChatUsers(): $e");
      return [];
    }
  }


  Future<dynamic> markMessagesAsRead({required int receiverId}) async {
    try {
      final url = Uri.parse("$baseUrl/chat/mark-read");
      final token = GetStorage().read("auth_token");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "user_id": receiverId, // Send in body
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("✅ Messages marked as read: ${jsonData}");
        return jsonData;
      } else {
        print("⚠️ HTTP Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in markMessagesAsRead(): $e");
      return null;
    }
  }



  Future<SubscriptionPlanResponse?> fetchPlans() async {
    try {
      final token = GetStorage().read("auth_token");
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/get-subscription-plan"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return SubscriptionPlanResponse.fromJson(jsonData);
      } else {
        print("⚠️ Failed to fetch plans: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔥 Error fetching plans: $e");
      return null;
    }
  }

  Future<Map<String, String>?> fetchRazorpayKeys() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/razorpay/keys")).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true && data["data"] != null) {
          return {

            "key": data["data"]["key"],
            "secret": data["data"]["secret"] ?? "",
          };
        }
      }
      return null;
    } catch (e) {
      print("🔥 Error fetching Razorpay keys: $e");
      return null;
    }
  }


  // Create a new subscription
  Future<Map<String, dynamic>?> createSubscription({
    required int planId,
    required String billingType, // "monthly" or "yearly"
  }) async {
    final url = Uri.parse('$baseUrl/subscription/create');
    final token = GetStorage().read("auth_token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "plan_id": planId,        // ✅ send plan_id instead of plan_name
          "billing_type": billingType,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("❌ Create subscription failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Error in createSubscription(): $e");
      return null;
    }
  }

  // Verify Razorpay subscription payment
  Future<Map<String, dynamic>?> verifySubscription({
    required String paymentId,
    required String subscriptionId,
    required String signature,
  }) async {
    final url = Uri.parse('$baseUrl/subscription/verify');
    final token = GetStorage().read("auth_token");
    print("🔹 Verify API called with:");
    print("Payment ID: $paymentId");
    print("Subscription ID: $subscriptionId");
    print("Signature: $signature");
    print("Token: $token");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "razorpay_payment_id": paymentId,
          "razorpay_subscription_id": subscriptionId,
          "razorpay_signature": signature,
        }),
      );

      print("🔹 Verify API response (status ${response.statusCode}): ${response.body}");

      final data = jsonDecode(response.body);
      fetchSubscriptionPlan();
      return data;
    } catch (e) {
      print("🔥 Error in verifySubscription(): $e");
      return null;
    }
  }


  // Cancel subscription
  Future<Map<String, dynamic>?> cancelSubscription({
    required String subscriptionId,
  }) async {
    final url = Uri.parse('$baseUrl/subscription/cancel');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "razorpay_subscription_id": subscriptionId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("❌ Cancel subscription failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Error in cancelSubscription(): $e");
      return null;
    }
  }




  Future<dynamic> fetchOffersByLocation({
    required double latitude,
    required double longitude,
    required double radius,
    required String type,
  }) async {

    final Uri url = Uri.parse("$baseUrl/get-data-by-location"); // endpoint

    try {
      print("📡 Sending location filter request to: $url");
      print("➡️ Body: { latitude: $latitude, longitude: $longitude, radius: $radius, type: $type }");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "radius": radius.toString(),
          "type": type,
        }),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded;
      } else {
        print("⚠️ Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("❌ Exception while fetching offers: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> getData(String endpoint) async {
    try {
      final token = GetStorage().read("auth_token"); // optional auth token
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: token != null ? {"Authorization": "Bearer $token"} : {},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print("API Error: ${response.statusCode} -> ${response.body}");
        return null;
      }
    } catch (e) {
      print("API Exception: $e");
      return null;
    }
  }


  Future<Map<String, dynamic>?> postData(Map<String, dynamic> body) async {
    try {
       final token = GetStorage().read("auth_token"); // optional auth token
      final response = await http.post(
        Uri.parse("$baseUrl/analytics/store"),
        headers: {
          "Content-Type": "application/json",
           "Authorization": "Bearer $token",
        },
        body: json.encode(body),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;

        // Print API response in yellow
        const yellow = '\x1B[33m'; // ANSI escape code for yellow
        const reset = '\x1B[0m';   // Reset color
        print("$yellow✅ API Response: $decoded$reset");

        return decoded;
      } else {
        print("API Error: ${response.statusCode} -> ${response.body}");
        return null;
      }
    } catch (e) {
      print("API Exception: $e");
      return null;
    }
  }


  Future<SubscriptionPlanActive?> fetchSubscriptionPlan() async {
    try {
      print("🔍 [Subscription] Starting API Call...");

      final token = GetStorage().read("auth_token");

      if (token == null) {
        throw Exception("User token not found");
      }

      final apiUrl = "$baseUrl/feature-access";

      final response = await http
          .get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 15));

      print("📡 Status Code → ${response.statusCode}");
      print("📥 Raw Response → ${response.body}");

      final decoded = json.decode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception("Invalid server response");
      }

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        return SubscriptionPlanActive.fromJson(decoded);
      }

      // ❌ ERROR → THROW BACKEND MESSAGE
      final message = decoded['message'] ?? 'Something went wrong';
      throw Exception(message);

    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      print("💥 Subscription API Error: $e");
      rethrow; // 🔥 IMPORTANT
    }
  }


  Future<Map<String, dynamic>?> createAdRazorpayOrder({
    required int amount,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/ads/order/create");
      final token = GetStorage().read("auth_token");

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "amount": amount.toString(),
        },
      ).timeout(const Duration(seconds: 20));

      print("📤 Request → ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["status"] == true) {
          return {
            "order_id": data["order_id"],
            "key": data["key"],
            "amount": data["data"]["amount"],
          };
        }
      }

      return null;
    } catch (e) {
      print("❌ Error creating Razorpay order: $e");
      return null;
    }
  }


  Future<AnalyticsResponse?> fetchAnalytics() async {
    try {
      final token = GetStorage().read("auth_token");
      if (token == null) return null;

      final response = await http.get(
        Uri.parse("$baseUrl/analytics/advanced"),
        headers: {
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AnalyticsResponse.fromJson(jsonData);
      } else {
        print("⚠️ Failed to fetch analytics: ${response.statusCode}");
        print("❌ Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔥 Error fetching analytics: $e");
      return null;
    }
  }


  Future<dynamic> prioritySearch(
      PrioritySearchRequest request) async {
    try {
      print("🔍 [Priority Search] Starting API Call...");

      final token = GetStorage().read("auth_token");

      final uri = Uri.parse("$baseUrl/priority-search")
          .replace(queryParameters: request.toQueryParams());

      final response = await http
          .get(
        uri,
        headers: {
          if (token != null) "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 15));

      print("📡 Status Code → ${response.statusCode}");
      print("📥 Raw Response → ${response.body}");

      final decoded = json.decode(response.body);

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        return decoded; // 🔥 No model, raw JSON
      }

      // ❌ ERROR MESSAGE FROM BACKEND
      final message =
      decoded is Map ? decoded['message'] : 'Something went wrong';
      throw Exception(message);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      print("💥 Priority Search API Error: $e");
      rethrow;
    }
  }


  Future<dynamic> createCourseOrder(int courseId) async {
    try {
      print("🧾 [Create Course Order] Starting API Call...");

      final token = GetStorage().read("auth_token");

      final uri = Uri.parse("$baseUrl/course/create-order");

      final response = await http
          .post(
        uri,
        headers: {
          if (token != null) "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "course_id": courseId,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print("📡 Status Code → ${response.statusCode}");
      print("📥 Raw Response → ${response.body}");

      final decoded = json.decode(response.body);

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        return decoded; // 🔥 raw JSON
      }

      // ❌ BACKEND ERROR MESSAGE
      final message =
      decoded is Map ? decoded['message'] : 'Failed to create order';
      throw Exception(message);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      print("💥 Create Course Order API Error: $e");
      rethrow;
    }
  }


  Future<dynamic> verifyCoursePayment({
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    try {
      print("🔐 [Verify Course Payment] Starting API Call...");

      final token = GetStorage().read("auth_token");

      final uri = Uri.parse("$baseUrl/course/verify-payment");

      final response = await http
          .post(
        uri,
        headers: {
          if (token != null) "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_order_id": razorpayOrderId,
          "razorpay_signature": razorpaySignature,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print("📡 Status Code → ${response.statusCode}");
      print("📥 Raw Response → ${response.body}");

      final decoded = json.decode(response.body);

      // ✅ SUCCESS
      if (response.statusCode == 200) {
        return decoded; // 🔥 raw JSON
      }

      // ❌ BACKEND ERROR MESSAGE
      final message =
      decoded is Map ? decoded['message'] : 'Payment verification failed';
      throw Exception(message);
    } on TimeoutException {
      throw Exception("Request timeout. Please try again.");
    } catch (e) {
      print("💥 Verify Course Payment API Error: $e");
      rethrow;
    }
  }


  Future<List<dynamic>> fetchAllCourses() async {

    final token = GetStorage().read("auth_token");

    final response = await http.get(
      Uri.parse("${baseUrl}/user/courses"),
      headers: {
        if (token != null) "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data'] ?? [];
    } else {
      throw Exception("Failed to load courses");
    }
  }


  Future<List<dynamic>> fetchStates() async {
    final response = await http.get(
      // Uri.parse("https://sparkly.kotiboxskillxacademy.com/api/get-state"),
      Uri.parse("https://backend.sparqly.in/api/get-state"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data'] ?? [];
    } else {
      throw Exception("Failed to load states");
    }
  }

  Future<List<dynamic>> fetchDistricts(int stateId) async {
    final response = await http.get(
      Uri.parse(
          // "https://sparkly.kotiboxskillxacademy.com/api/get-district/$stateId"),
          "https://backend.sparqly.in/api/get-district/$stateId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['data'] ?? [];
    } else {
      throw Exception("Failed to load districts");
    }
  }


  Future<List<OfferPrice>> fetchOfferPrices() async {
    final token = GetStorage().read("auth_token");

    final response = await http.get(
      Uri.parse("$baseUrl/get-offer-price"),
      headers: {
        if (token != null) "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == true && jsonData['data'] != null) {
        return (jsonData['data'] as List)
            .map((e) => OfferPrice.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load offer prices");
    }
  }


  Future<bool> deleteAccount() async {
    final token = GetStorage().read("auth_token");

    final response = await http.delete(
      Uri.parse("$baseUrl/account/delete"),
      headers: {
        if (token != null) "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['status'] == true;
    } else {
      throw Exception("Failed to delete account");
    }
  }


  // Future<Map<String, dynamic>?> shareItem({
  //   required String type,
  //   required int id,
  // }) async {
  //
  //   try {
  //
  //     final token = GetStorage().read("auth_token");
  //
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/share"),
  //       headers: {
  //         if (token != null) "Authorization": "Bearer $token",
  //         "Accept": "application/json",
  //       },
  //       body: {
  //         "type": type,
  //         "id": id.toString(),
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //
  //       final data = jsonDecode(response.body);
  //
  //       print("✅ SHARE RESPONSE = $data");
  //
  //       return data;
  //
  //     } else {
  //
  //       print("❌ SHARE FAILED ${response.statusCode}");
  //       print(response.body);
  //
  //       return null;
  //     }
  //
  //   } catch (e) {
  //
  //     print("❌ Share API error: $e");
  //
  //     return null;
  //   }
  // }

}

