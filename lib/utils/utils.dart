import 'package:clone_tiktok/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// Select image from source
pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      return await image.readAsBytes();
    } else {
      debugPrint('--- No image selected ---');
      return null;
    }
  } catch (e) {
    debugPrint('--- Error picking image: $e ---');
    return null;
  }
}

// select video from source
pickVideo(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? video = await picker.pickVideo(source: source);
    if (video != null) {
      return video;
    } else {
      debugPrint('--- No video selected ---');
      return null;
    }
  } catch (e) {
    debugPrint('--- Error picking video: $e ---');
    return null;
  }
}

showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: TextStyle(color: primaryColor)),
      backgroundColor: greyColor,
      duration: const Duration(seconds: 2),
    ),
  );
}

String formatedDate(DateTime date) {
  final outputDateFormat = DateFormat("dd/MM/yyyy HH:mm").format(date);
  return outputDateFormat;
}
