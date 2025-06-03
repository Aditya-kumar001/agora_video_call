import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/app_color.dart';
import '../../../../common/app_fontWeight.dart';
import '../../../../common/app_fontsize.dart';
import '../../../../routes/app_pages.dart';

Center loginForm(dynamic controller) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: controller.animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -controller.animation.value),
                child: child,
              );
            },
            child: SizedBox(
              height: 150,
              width: 150,
              child: Material(
                elevation: 20.0,
                shadowColor: AppColorList.MainShadow,
                borderRadius: BorderRadius.circular(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/app_icon.png'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Welcome to Agora Caller Mobile App",
            style: TextStyle(
              fontSize: AppFontSize.size1,
              fontWeight: AppFontWeight.font2,
              color: AppColorList.AppText
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Username",
              style: TextStyle(
                fontWeight: AppFontWeight.font2,
                fontSize: AppFontSize.size3,
                color: AppColorList.AppText
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.UserName,
            decoration: InputDecoration(
              labelText: 'Enter your username',
              labelStyle: TextStyle(
                color: AppColorList.AppText,
                fontSize: AppFontSize.size3,
                fontWeight: AppFontWeight.font1
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Password",
              style: TextStyle(
                fontWeight: AppFontWeight.font2,
                fontSize: AppFontSize.size3,
                color: AppColorList.AppText
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller.Password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter your password',
              labelStyle: TextStyle(
                color: AppColorList.AppText,
                fontSize: AppFontSize.size3,
                fontWeight: AppFontWeight.font1
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Login button
          Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator()
            : SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColorList.AppButtonColor,
                    ),
                    shadowColor: WidgetStateProperty.all(
                      AppColorList.MainShadow, // Or any color you want for the shadow
                    ),
                    elevation: WidgetStateProperty.all(12)
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: AppFontSize.size1,
                      fontWeight: AppFontWeight.font2,
                      color: AppColorList.WhiteText,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    ),
  );
}