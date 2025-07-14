import 'package:clone_tiktok/controller/search_controller.dart' as controller;
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/widgets/user_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final searchController = Get.put(controller.SearchController());

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textController = TextEditingController();
    final size = MediaQuery.of(context).size;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: TextFormField(
            controller: _textController,
            decoration: const InputDecoration(
              filled: false,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                searchController.searchUsers(value);
              }
            },
          ),
        ),
        body: searchController.searchResults.isEmpty
            ? Center(
                child: Text(
                  'Search for users',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SizedBox(
                height: size.height,
                width: size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (context, index) {
                    final user = searchController.searchResults[index];
                    return UserListTile(user: user);
                  },
                ),
              ),
      );
    });
  }
}
