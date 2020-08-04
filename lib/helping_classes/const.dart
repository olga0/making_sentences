import 'package:flutter/services.dart';

class Constants {
  // Ads
  static const String APP_ID = 'ca-app-pub-7846904536906450~7367143226';
  static const String UNIT_ID = 'ca-app-pub-7846904536906450/7175571531';

  // Shared prefs
  static const String CHOSEN_LANGUAGE_KEY = 'chosen language';
  static const String LOCALE_LANGUAGE_KEY = 'locale language';
  static const String IS_AD_REMOVED_KEY = 'is ad removed';

  // native code
  static const PLATFORM = const MethodChannel('com.olgam.makingsentences/install_language');

  // In-app purchases
  static const String PRODUCT_ID = 'remove_ads';
}