import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/controller/cubit/signup/sign_up_cubit.dart';
import 'package:instgram_clone/utils/constants.dart';
import 'package:instgram_clone/view/screens/home_screen.dart';
import 'package:instgram_clone/view/screens/login_screen.dart';
import 'package:instgram_clone/view/widgets/textfiled_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static const String route = "signupScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController bioController = TextEditingController();

  bool loading = false;
  String res = "";
  Uint8List? _image;

  selectImage() async {
    Uint8List im = await Constants.pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is SignUpLoading) {
          loading = true;
        } else if (state is SignUpSuccess) {
          Navigator.pushReplacementNamed(context, HomeScreen.route);
          loading = false;
        } else if (state is SignUpFailure) {
          Constants.getSnackBar(context, state.error, Colors.red);
          loading = false;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: ModalProgressHUD(
            inAsyncCall: loading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        SvgPicture.asset(
                          'assets/images/instgram_background.svg',
                          color: Constants.primaryColor,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            _image == null
                                ? const CircleAvatar(
                                    maxRadius: 50,
                                    backgroundImage: AssetImage(
                                        "assets/images/socia happy.jpg"),
                                  )
                                : CircleAvatar(
                                    maxRadius: 50,
                                    backgroundImage: MemoryImage(_image!),
                                  ),
                            InkWell(
                              child: const Icon(Icons.add_a_photo),
                              onTap: () {
                                selectImage();
                              },
                            ),
                          ],
                        ),
                        TextFieldInput(
                          textEditingController: usernameController,
                          hintText: "Enter your username",
                          textInputType: TextInputType.emailAddress,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return "user name must not be empty";
                            }
                          },
                        ),
                        TextFieldInput(
                          textEditingController: emailController,
                          hintText: "Enter your email",
                          textInputType: TextInputType.emailAddress,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return "email must not be empty";
                            }
                          },
                        ),
                        TextFieldInput(
                          textEditingController: passwordController,
                          hintText: "Enter your password",
                          textInputType: TextInputType.text,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return "password must not be empty";
                            }
                          },
                        ),
                        TextFieldInput(
                          textEditingController: bioController,
                          hintText: "Enter your bio",
                          textInputType: TextInputType.emailAddress,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return "bio must not be empty";
                            }
                          },
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  SignUpCubit.get(context).signUp(
                                      emailAddress: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              child: const Text("Sign up"),
                            )),
                        Text.rich(
                          TextSpan(text: "Already have an account ", children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacementNamed(
                                        context, LoginScreen.route);
                                  },
                                text: "Login",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline)),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
