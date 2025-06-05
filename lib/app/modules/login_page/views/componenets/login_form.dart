import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../../../../common/app_color.dart';
// import '../../../../common/app_fontWeight.dart';
// import '../../../../common/app_fontsize.dart';
// import '../../../../routes/app_pages.dart';

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
                shadowColor: Colors.black26,
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    // icon: Image.asset("assets/images/google_icon.png", height: 24),
                    label: const Text("Sign in with Google"),
                    onPressed: controller.signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ))
        ],
      ),
    ),
  );
}
