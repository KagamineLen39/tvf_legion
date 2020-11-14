import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async{
  serviceLocator.registerLazySingleton(() => FirebaseAuth.instance);
  serviceLocator.registerLazySingleton(() => Firestore.instance);
  serviceLocator.registerLazySingleton(() => FirebaseStorage.instance);
  serviceLocator.registerLazySingleton(() => FirebaseMessaging());
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final androidInitializationSettings = AndroidInitializationSettings('logo');
  final iosInitializationSettings = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
      androidInitializationSettings, iosInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  serviceLocator.registerLazySingleton(() => flutterLocalNotificationsPlugin);

}