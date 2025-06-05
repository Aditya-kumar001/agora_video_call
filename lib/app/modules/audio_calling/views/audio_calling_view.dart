import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/app_color.dart';
import '../../../common/app_fontWeight.dart';
import '../../../common/app_fontsize.dart';
import '../controllers/audio_calling_controller.dart';

class AudioCallingView extends GetView<AudioCallingController> {
  const AudioCallingView({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          SizedBox.expand(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
          Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width * 0.65,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1, 
                            color: AppColorList.AppText),
                        ),
                        child: ClipOval(
                          child: controller.photoUrl.value.isNotEmpty
                              ? Image.network(controller.photoUrl.value, fit: BoxFit.cover)
                              : Image.asset('assets/images/young-men.png', fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        'Calling...',
                        style: TextStyle(
                          fontSize: AppFontSize.size1,
                          fontWeight: AppFontWeight.font3,
                          color: AppColorList.WhiteText,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        controller.userName.value,
                        style: TextStyle(
                          fontSize: AppFontSize.size1,
                          fontWeight: AppFontWeight.font3,
                          color: AppColorList.WhiteText,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    callButton(
                      context,
                      icon: Icons.volume_up_outlined,
                      // label: "Audio Call",
                      onTap: () {
                        
                      },
                    ),
                    callButtonCut(
                      context,
                      icon: Icons.phone_disabled,
                      // label: "Video Call",
                      onTap: () {

                      },
                    ),
                    callButton(
                      context,
                      icon: Icons.mic_off,
                      // label: "Video Call",
                      onTap: () {
                        
                      },
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
        ]
      )),
    );
  }

  Widget callButton(BuildContext context, {required IconData icon,required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: AppColorList.MainShadow,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1),
            ),
            child: Icon(icon, color: AppColorList.WhiteText , size: 30),
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: AppFontSize.size2,
        //     color: AppColorList.AppBackGroundColor,
        //   ),
        // ),
      ],
    );
  }
  Widget callButtonCut(BuildContext context, {required IconData icon,required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.13,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              color: AppColorList.MainShadow,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1),
            ),
            child: Icon(icon, color: AppColorList.Star3 , size: 50),
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        // Text(
        //   label,
        //   style: TextStyle(
        //     fontSize: AppFontSize.size2,
        //     color: AppColorList.AppBackGroundColor,
        //   ),
        // ),
      ],
    );
  }
}
