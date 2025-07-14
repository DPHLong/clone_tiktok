import 'dart:io';
import 'package:clone_tiktok/controller/upload_video_controller.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/widgets/custom_text_button.dart';
import 'package:clone_tiktok/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({
    required this.videoFile,
    required this.videoPath,
    super.key,
  });

  final File videoFile;
  final String videoPath;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController _videoController;
  final TextEditingController _songController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();
  final _uploadVideoController = Get.put(UploadVideoController());
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _videoController = VideoPlayerController.file(widget.videoFile);
    });
    _videoController.initialize();
    _videoController.play();
    _videoController.setVolume(1);
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(_videoController),
            ),
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
              child: InputTextField(
                controller: _songController,
                labelText: 'Song Name',
                hintText: 'Enter a song Name',
                prefixIcon: Icon(Icons.music_note_outlined),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width - 20,
              child: InputTextField(
                controller: _captionController,
                labelText: 'Caption',
                hintText: 'Enter a Caption',
                prefixIcon: Icon(Icons.closed_caption),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomTextButton(
                backgroundColor: primaryColor,
                borderColor: secondaryColor,
                function: () {
                  if (_songController.text.isEmpty ||
                      _captionController.text.isEmpty) {
                    Get.snackbar('Error', 'Please fill all fields');
                    return;
                  }
                  setState(() => _isLoading = true);
                  _uploadVideoController
                      .uploadVideo(
                        _songController.text,
                        _captionController.text,
                        widget.videoPath,
                      )
                      .then((_) {
                        setState(() => _isLoading = false);
                        Navigator.of(context).pop();
                      });
                },
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Share!',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
