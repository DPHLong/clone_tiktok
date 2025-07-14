import 'dart:io';

import 'package:clone_tiktok/screens/confirm_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({super.key});

  @override
  State<AddVideoScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddVideoScreen> {
  _pickVideo(ImageSource src) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: src);
      if (video != null) {
        Get.to(
          () =>
              ConfirmScreen(videoFile: File(video.path), videoPath: video.path),
        );
      } else {
        debugPrint('--- No video selected ---');
      }
    } catch (e) {
      debugPrint('--- Error picking video: $e ---');
    }
  }

  _showOptionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          SimpleDialogOption(
            onPressed: () {
              // Handle camera option
              _pickVideo(ImageSource.camera);
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.camera_alt_outlined),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Camera', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              // Handle gallery option
              _pickVideo(ImageSource.gallery);
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.photo),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Gallery', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.cancel),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Cancel', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () {
            _showOptionDialog(context);
          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Add Video',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
