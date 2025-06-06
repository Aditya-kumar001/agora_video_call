import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


AppBar customAppBar(String title) {
  final controller = Get.find<HomeController>();
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
        if (title == 'Messages') IconButton(
          onPressed: () { 
          controller.searchBarActive();
         }, icon: Icon(Icons.search_rounded),)
      ],
      // leading: Icon(
      //   Icons.search_rounded,
      //   size: 25,  
      // ),
      // centerTitle: true,
    );
  }