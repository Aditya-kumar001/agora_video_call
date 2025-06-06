import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_pages.dart';

// This needs to be a top-level function for Firebase background message handling
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();
  
  // Parse call data from the message
  final callData = message.data;
  
  // Store call data in shared preferences for retrieval when app is opened
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('pending_call', jsonEncode(callData));
  
  // Show a high-priority notification that can wake up the device
  await _showIncomingCallNotification(callData);
}

Future<void> _showIncomingCallNotification(Map<String, dynamic> callData) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();
  
  // Initialize notification settings
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'call_channel_id',
    'Incoming Calls',
    channelDescription: 'Notifications for incoming calls',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
    sound: RawResourceAndroidNotificationSound('ringtone'),
    playSound: true,
    ongoing: true,
    autoCancel: false,
  );
  
  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'ringtone.aiff',
    interruptionLevel: InterruptionLevel.critical,
  );
  
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
    iOS: iosDetails,
  );
  
  // Show the notification
  await flutterLocalNotificationsPlugin.show(
    0,
    'Incoming ${callData['isVideo'] == 'true' ? 'Video' : 'Audio'} Call',
    'From ${callData['callerName'] ?? 'Unknown'}',
    notificationDetails,
    payload: jsonEncode(callData),
  );
}

class CallBackgroundService extends GetxService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Stream controller for call events
  final _callStreamController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get callStream => _callStreamController.stream;
  
  // Initialize the service
  Future<CallBackgroundService> init() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    
    // Request notification permissions
    await requestNotificationPermissions();
    
    // Initialize local notifications
    await initializeLocalNotifications();
    
    // Set up Firebase Messaging handlers
    setupFirebaseMessaging();
    
    // Check for pending calls (app was terminated with an incoming call)
    _checkPendingCalls();
    
    return this;
  }
  
  Future<void> requestNotificationPermissions() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true, // For critical notifications like calls
      announcement: true,
    );
    
    print('User notification permission status: ${settings.authorizationStatus}');
    
    // Request additional permissions on iOS
    if (Platform.isIOS) {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
  
  Future<void> initializeLocalNotifications() async {
    // Initialize Android settings
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // Initialize iOS settings
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      requestCriticalPermission: true,
    );
    
    // Initialize settings for all platforms
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    // Initialize the plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Create notification channel for Android
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'call_channel_id',
        'Incoming Calls',
        description: 'Notifications for incoming calls',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('ringtone'),
        enableVibration: true,
      );
      
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }
  
  void setupFirebaseMessaging() {
    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      
      if (message.data.containsKey('callType')) {
        // This is a call notification
        handleIncomingCall(message.data);
      }
    });
    
    // Handle when a notification is tapped and the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A notification was tapped and the app was in the background!');
      if (message.data.containsKey('callType')) {
        handleIncomingCall(message.data);
      }
    });
    
    // Get the FCM token for this device
    _firebaseMessaging.getToken().then((token) {
      print('FCM Token: $token');
      // TODO: Send this token to your server to enable push notifications
    });
  }
  
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final callData = jsonDecode(response.payload!) as Map<String, dynamic>;
        handleIncomingCall(callData);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }
  
  Future<void> _checkPendingCalls() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingCallJson = prefs.getString('pending_call');
      
      if (pendingCallJson != null) {
        // Clear the pending call immediately to prevent multiple handling
        await prefs.remove('pending_call');
        
        // Parse and handle the call
        final callData = jsonDecode(pendingCallJson) as Map<String, dynamic>;
        handleIncomingCall(callData);
      }
    } catch (e) {
      print('Error checking pending calls: $e');
    }
  }
  
  void handleIncomingCall(Map<String, dynamic> callData) {
    // Broadcast the call data to listeners
    _callStreamController.add(callData);
    
    // Navigate to the incoming call screen
    Get.toNamed(
      Routes.AUDIO_CALLING,
      arguments: callData,
    );
  }
  
  // Register a device for push notifications
  Future<void> registerDevice(String userId) async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      // TODO: Send this token to your server along with the user ID
      print('Registering device token for user $userId: $token');
      
      // This would typically be an API call to your backend
      // await apiService.registerDeviceToken(userId, token);
    }
  }
  
  // Clean up resources
  @override
  void onClose() {
    _callStreamController.close();
    super.onClose();
  }
}