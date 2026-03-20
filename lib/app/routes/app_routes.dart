part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Path.SPLASH;
  static const DASHBOARD = '/dashboard';
  static const HOME = '/home';
  static const CATEGORIES = '/categories';
  static const CREATE = '/create';
  static const OFFERS = '/offers';
  static const COURSES = '/courses';
  static const BUSINESS_LISTINGS = '/business-listings';
  static const JOBS_LISTINGS = '/jobs-listings';
  static const INFLUENCERS_LISTINGS = '/influencers-listings';
  static const COURSE_LISTINGS = '/course-listings';
  static const OFFERS_LISTINGS = '/offers-listings';
  static const AD_LISTINGS = '/ad-listings';
  static const BUSINESS = '/business-list';
  static const JOBS = '/jobs';
  static const INFLUENCERS = '/influencers';
  static const COURSE_DETAIL_UI = '/course-detail-ui';
  static const PROFILE = '/profile';
  static const BUSINESS_DETAIL_PAGE = '/business-detail-page';
  static const JOBS_DETAIL_PAGE = '/jobs-detail-page';
  static const INFLUENCER_DETAIL_PAGE = '/influencer-detail-page';
  static const OFFERS_DETAIL_PAGE = '/offers-detail-page';
  static const CHAT_LIST = '/chatList';
  static const CHAT = '/chat';
  static const OTP = '/otp';
  static const EDIT_PROFILE = '/edit-profile';
  static const REVIEW_RATING = '/review-rating';
  static const SUBSCRIPTION = '/subscription';
  static const REFERAL = '/referal';
  static const UNKNOWN = '/unknown';
  static const MY_COURSES = '/my-courses';
  static const COURSE_WEBVIEW_SCREEN = '/course-webview-screen';
}

abstract class _Path {
  _Path._();
  static const SPLASH = '/splash';
}

abstract class PageIndex {
  static const HOME = 0;
  static const CATEGORIES = 1;
  static const CREATE = 2;
  static const OFFERS = 3;
  static const COURSES = 4;
  static const BUSINESS_LISTINGS = 5;
  static const JOBS_LISTINGS = 6;
  static const INFLUENCERS_LISTINGS = 7;
  static const COURSE_LISTINGS = 8;
  static const OFFERS_LISTINGS = 9;
  static const AD_LISTINGS = 10;
  static const BUSINESS = 11;
  static const JOBS = 12;
  static const INFLUENCERS = 13;
  static const PROFILE = 14;
  static const CHAT_LIST = 15;
  static const CHAT = 16;

  //  Detail pages
  static const BUSINESS_DETAIL = 17;
  static const JOBS_DETAIL = 18;
  static const INFLUENCER_DETAIL = 19;
  static const OFFERS_DETAIL = 20;
  static const COURSE_DETAIL = 21;
  static const EDIT_PROFILE = 22;
}
