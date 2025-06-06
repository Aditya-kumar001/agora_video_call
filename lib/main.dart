import 'package:agora_task/app/services/agora_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as rtc;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/modules/app_binding.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final agoraEngine = rtc.createAgoraRtcEngine();
  await agoraEngine.initialize(
    rtc.RtcEngineContext(appId: AgoraService.appId),
  );
  await Firebase.initializeApp(); 

  await GetStorage.init();
  final box = GetStorage();

  // final bool isLogin = box.read('isLogged');
  // if (kDebugMode) {
  //   print(isLogin);
  // }

  final bool isLoggedIn = box.read('isLogged') ?? false;
  
  runApp(
    GetMaterialApp(
      title: "Application",
      initialBinding: AppBinding()  ,
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? Routes.HOME : Routes.LOGIN_PAGE,
      getPages: AppPages.routes,
    ),
  );
}
