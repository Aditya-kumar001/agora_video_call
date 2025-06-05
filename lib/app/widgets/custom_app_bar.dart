import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

AppBar customAppBar(String title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          ),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () { 
          Get.toNamed(Routes.SEARCH_USER);
         }, icon: Icon(Icons.search_rounded),)
      ],
      leading: Icon(
        Icons.search_rounded,
        size: 25,  
      ),
      // centerTitle: true,
    );
  }