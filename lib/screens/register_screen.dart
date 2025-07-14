import 'package:clone_tiktok/screens/login_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/utils/utils.dart';
import 'package:clone_tiktok/widgets/custom_text_button.dart';
import 'package:clone_tiktok/widgets/input_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _bioController = TextEditingController();
  final _firebaseMethods = FirebaseMethods();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  bool _isLoading = false;

  selectImageFromGallery() async {
    final Uint8List img = await pickImage(ImageSource.gallery);
    setState(() => _image = img);
  }

  selectImageFromCamera() async {
    final Uint8List img = await pickImage(ImageSource.camera);
    setState(() => _image = img);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TikTok Clone',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: greyColor,
                      backgroundImage: _image != null
                          ? MemoryImage(_image!)
                          : null,
                      child: _image == null
                          ? Icon(Icons.person, size: 80)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text('Take a photo from'),
                                children: [
                                  SimpleDialogOption(
                                    padding: const EdgeInsets.all(20),
                                    child: const Text('Camera'),
                                    onPressed: () {
                                      selectImageFromCamera();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  SimpleDialogOption(
                                    padding: const EdgeInsets.all(20),
                                    child: const Text('Gallery'),
                                    onPressed: () {
                                      selectImageFromGallery();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  SimpleDialogOption(
                                    padding: const EdgeInsets.all(20),
                                    child: const Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.photo,
                          size: 32,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InputTextField(
                  controller: _nameController,
                  labelText: 'Username',
                  hintText: 'Enter an username',
                  prefixIcon: Icon(Icons.person),
                  shouldValidate: true,
                ),
                SizedBox(height: 20),
                InputTextField(
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                  labelText: 'Email',
                  hintText: 'Enter an Email',
                  prefixIcon: Icon(Icons.email),
                  isEmail: true,
                  shouldValidate: true,
                ),
                SizedBox(height: 20),
                InputTextField(
                  controller: _passController,
                  labelText: 'Password',
                  hintText: 'Enter an Password',
                  prefixIcon: Icon(Icons.lock),
                  isPassword: true,
                  shouldValidate: true,
                ),
                SizedBox(height: 20),
                InputTextField(
                  controller: _bioController,
                  labelText: 'Bio (optional)',
                  hintText: 'Enter your bio',
                  prefixIcon: null,
                ),
                SizedBox(height: 20),
                CustomTextButton(
                  backgroundColor: primaryColor,
                  borderColor: secondaryColor,
                  function: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() => _isLoading = true);
                      final res = await _firebaseMethods.registerUser(
                        email: _emailController.text,
                        password: _passController.text,
                        username: _nameController.text,
                        bio: _bioController.text,
                        image: _image,
                      );
                      if (res == 'success') {
                        setState(() => _isLoading = false);
                        Get.snackbar(
                          'Register successfully',
                          'Please login now!',
                        );
                        Get.offAll(LoginScreen());
                      } else {
                        Get.snackbar('Error Register', 'Please try again.');
                      }
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: secondaryColor)
                      : Text(
                          'Register',
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? '),
                    InkWell(
                      onTap: () {
                        Get.offAll(() => LoginScreen());
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
