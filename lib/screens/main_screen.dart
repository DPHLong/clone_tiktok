import 'package:clone_tiktok/screens/account_screen.dart';
import 'package:clone_tiktok/screens/add_video_screen.dart';
import 'package:clone_tiktok/screens/videos_screen.dart';
import 'package:clone_tiktok/screens/messages_screen.dart';
import 'package:clone_tiktok/screens/search_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/widgets/custom_icon.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    VideosScreen(),
    SearchScreen(),
    AddVideoScreen(),
    MessagesScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        backgroundColor: mobileBackgroundColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        onTap: (value) {
          setState(() {
            _pageIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_rounded),
            label: 'Videos',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: CustomIcon(), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
