import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class LoginPageController extends GetxController with GetSingleTickerProviderStateMixin {

  var UserName = TextEditingController();
  var Password = TextEditingController();
  var isLoading = false.obs;
  final box = GetStorage();
  var isLogged = false.obs;
  late AnimationController animationController;
  late Animation<double> animation;
  var rememberMe = false.obs;
  var Switch_page = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    animation = Tween<double>(begin: 0,end: 30).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    
  }

 
  // Future<void> sendToken() async {
  //   final token = box.read('Token');
  //   final partnerId = box.read('partnerId');

  //   if (token == null || partnerId == null) {
  //     log('Token or partner_id is null, skipping sendToken.');
  //     return;
  //   }

  //   final url = '${Constant.BASE_URL}${ApiEndPoints.SAVE_TOKEN}?partner_id=$partnerId&token=$token';
  //   log(url);

  //   try {
  //     final response = await http.post(Uri.parse(url));
  //     log(response.body);

  //     if(response.statusCode == 200) {
  //       log('This is the response code: $response');
  //     }
  //   } catch (e) {
  //     log('sendToken error: $e');
  //   }
  // }

  Future<void> logout () async {
    await GetStorage().erase();

    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

}