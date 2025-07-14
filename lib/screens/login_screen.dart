import 'package:clone_tiktok/constants/asset.dart';
import 'package:clone_tiktok/screens/main_screen.dart';
import 'package:clone_tiktok/screens/register_screen.dart';
import 'package:clone_tiktok/utils/colors.dart';
import 'package:clone_tiktok/utils/firebase_methods.dart';
import 'package:clone_tiktok/widgets/custom_text_button.dart';
import 'package:clone_tiktok/widgets/input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _firebaseMethods = FirebaseMethods();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.icTiktok),
              SizedBox(height: 20),
              InputTextField(
                controller: _emailController,
                textInputType: TextInputType.emailAddress,
                labelText: 'Email',
                hintText: 'Enter your Email',
                prefixIcon: Icon(Icons.email),
                isPassword: false,
                isEmail: true,
                shouldValidate: true,
              ),
              SizedBox(height: 20),
              InputTextField(
                controller: _passController,
                labelText: 'Password',
                hintText: 'Enter your Password',
                prefixIcon: Icon(Icons.lock),
                isPassword: true,
                isEmail: false,
                shouldValidate: true,
              ),
              SizedBox(height: 20),
              CustomTextButton(
                backgroundColor: primaryColor,
                borderColor: secondaryColor,
                function: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _isLoading = true);
                    final res = await _firebaseMethods.loginUser(
                      email: _emailController.text,
                      password: _passController.text,
                    );
                    if (res == 'success') {
                      setState(() => _isLoading = false);
                      Get.snackbar('Login successfully', 'Welcome back!');
                      Get.offAll(() => MainScreen());
                    } else {
                      Get.snackbar('Error Login', 'Please try again.');
                    }
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: secondaryColor)
                    : Text(
                        'Login',
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
                  Text('Need an account? '),
                  InkWell(
                    onTap: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 16,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
