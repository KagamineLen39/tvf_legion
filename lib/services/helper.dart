import "package:shared_preferences/shared_preferences.dart";

class Helper{
<<<<<<< HEAD
  static String sharedPreferenceUserLoggedInKey = "isUserLoggedIn";
  static String sharedPreferenceUserNameKey = "usernameKey";
  static String sharedPreferenceUserEmailKey = "userEmailKey";

  static Future<bool> savedLoggedIn(bool isUserLoggedIn) async{
=======
  static String sharedPreferenceUserLoggedInKey = "isLoggedIn";
  static String sharedPreferenceUserNameKey = "usernameKey";
  static String sharedPreferenceUserEmailKey = "userEmailKey";

  static Future<void> savedLoggedIn(bool isUserLoggedIn) async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

<<<<<<< HEAD
  static Future<bool> savedUserName(String username) async{
=======
  static Future<void> savedUserName(String username) async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, username);
  }

<<<<<<< HEAD
  static Future<bool> savedUserEmail(String email) async{
=======
  static Future<void> savedUserEmail(String email) async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, email);
  }

<<<<<<< HEAD
  static Future<bool> getLogIn() async{
=======

  //getter
  static Future<void> getLogIn() async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey);
  }

<<<<<<< HEAD
  static Future<String> getUserName() async{
=======
  static Future<void> getUserName() async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

<<<<<<< HEAD
  static Future<String> getUserEmail() async{
=======
  static Future<void> getUserEmail() async{
>>>>>>> parent of 88b2cac... HomePage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }
}