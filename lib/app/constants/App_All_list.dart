import 'package:flutter/material.dart';
import 'package:sparqly/app/constants/App_Assets.dart';

class AppAllList {
  static const List<String> homecategoryName = [
    " Business",
    " Jobs",
    " Influencers",
    " Courses",
  ];
  static List<String> homecategory = [
    AppAssets.buisness,
    AppAssets.jobs,
    AppAssets.influ,
    AppAssets.course,
  ];

  static const List<Map<String, dynamic>> createNewListing = [
    {
      "title": "Business",
      "subtitle": "Promote your business to a wider audience.",
      "icon": Icons.business,
    },
    {
      "title": "Jobs",
      "subtitle": "Find the perfect candidate for your team.",
      "icon": Icons.work,
    },
    {
      "title": "Influencers",
      "subtitle": "Showcase your profile to brands and get discoverd.",
      "icon": Icons.people,
    },
    {
      "title": "Courses",
      "subtitle": "Share your knowledge and teach a course.",
      "icon": Icons.school,
    },
    {
      "title": "Offers",
      "subtitle": "Create special deals and promotions.",
      "icon": Icons.local_offer,
    },
    {
      "title": "Ad",
      "subtitle": "advertise a product, services, or event.",
      "icon": Icons.campaign,
    },
  ];


  static List<String> categoryImg = [
    AppAssets.buisness,
    AppAssets.jobs,
    AppAssets.influ,
  ];
  static const List<String> categoryListIcon = [
    AppAssets.categoryBusiness,
    AppAssets.catejobs,
    AppAssets.cateinflu,
  ];

  static const List<String> categoryList = [
    " Business",
    " Jobs",
    " Influencers",
  ];
  static const List<String> categoryIconName = [
    "Business",
    "Jobs",
    "Influencer",
    "Course",
  ];

  static const List<String> categoryIcon = [
    AppAssets.catebusiness,
    AppAssets.catejobs,
    AppAssets.cateinflu,
    AppAssets.catecourse,
  ];
  static List<Map<String, dynamic>> categories = [
    {
      "title": "Spice Delight",
      "category": "Restaurant",
      "owner": "Rajesh Kumar",
      "location": "Mumbai, India",
      "description":
      "Authentic Indian cuisine with a modern twist. Famous for biryanis and curries.",
      "image":
      "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=600&h=400&fit=crop",
      "boosted": true,
      "isTrending": true,
      "price": "₹500 - ₹1500", // ✅ Added price
    },
    {
      "title": "Glamour Studio",
      "category": "Salon",
      "owner": "Priya Sharma",
      "location": "Delhi, India",
      "description":
      "Premium beauty and wellness services with expert stylists.",
      "image":
      "https://images.unsplash.com/photo-1585747860715-2ba37e788b70?w=600&h=400&fit=crop",
      "boosted": false,
      "isTrending": false,
      "price": "₹800 - ₹2000", // ✅ Added price
    },
    {
      "title": "FitLife Gym",
      "category": "Fitness",
      "owner": "Amit Verma",
      "location": "Bangalore, India",
      "description":
      "State-of-the-art fitness center offering personal training and group classes.",
      "image":
      "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&h=400&fit=crop",
      "boosted": true,
      "isTrending": true,
      "price": "₹1200 / month", // ✅ Added price
    },
    {
      "title": "Urban Trends",
      "category": "Shopping",
      "owner": "Neha Kapoor",
      "location": "Hyderabad, India",
      "description":
      "Trendy clothing and accessories store for all age groups.",
      "image":
      "https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=600&h=400&fit=crop",
      "boosted": false,
      "isTrending": false,
      "price": "₹500 - ₹3000", // ✅ Added price
    },
    {
      "title": "Wanderlust Travels",
      "category": "Travel",
      "owner": "Ravi Singh",
      "location": "Chennai, India",
      "description":
      "Travel agency specializing in curated holiday packages and adventure tours.",
      "image":
      "https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?w=600&h=400&fit=crop",
      "boosted": true,
      "isTrending": true,
      "price": "₹15,000 - ₹60,000", // ✅ Added price
    },
  ];



}
