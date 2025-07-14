import 'dart:io';
import 'package:clone_tiktok/models/user_model.dart';
import 'package:clone_tiktok/screens/login_screen.dart';
import 'package:clone_tiktok/screens/main_screen.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final AuthController authController = Get.put(AuthController());

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;
  late Rx<UserModel?> _userModel;

  File? get profileImage => _pickedImage.value;
  User? get user => _user.value;
  UserModel? get userModel => _userModel.value;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialScreen);
    getUserModel();
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => MainScreen());
    }
  }

  void pickImage(ImageSource src) async {
    final pickedImage = await ImagePicker().pickImage(source: src);

    if (pickedImage != null) {
      _pickedImage = Rx<File?>(File(pickedImage.path));
      Get.snackbar('pick image', 'Success');
    } else {
      _pickedImage = Rx<File?>(File(''));
    }
  }

  void getUserModel() async {
    final userModel = await FirebaseMethods().getUserDetails();
    _userModel = Rx<UserModel?>(userModel);
  }
}
