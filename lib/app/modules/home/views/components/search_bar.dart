import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

Padding searchBar(BuildContext context, HomeController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      // width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.5,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search users',
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: (value) {
          controller.searchUsers(value.trim());
        },
      ),
    ),
  );
}