import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instgram_clone/controller/cubit/login/login_cubit.dart';
import 'package:instgram_clone/utils/constants.dart';
import 'package:instgram_clone/view/screens/reset_password_screen.dart';
import 'package:instgram_clone/view/screens/signup_screen.dart';
import 'package:instgram_clone/view/widgets/textfiled_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String route = "loginScreen";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is LoginLoading) {
            loading = true;
          } else if (state is LoginSuccess) {
            loading = false;
            Navigator.pushReplacementNamed(context, HomeScreen.route);
          } else if (state is LoginFailure) {
            loading = false;
            Constants.getSnackBar(context, state.error, Colors.red);
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(flex: 2),
                                SvgPicture.asset(
                                  'assets/images/instgram_background.svg',
                                  color: Constants.primaryColor,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                TextFieldInput(
                                  textEditingController: emailController,
                                  hintText: "Enter your email",
                                  textInputType: TextInputType.emailAddress,
                                  validate: (value) {
                                    if (value.toString().isEmpty) {
                                      return "email must not be empty";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFieldInput(
                                  textEditingController: passwordController,
                                  hintText: "Enter your password",
                                  textInputType: TextInputType.text,
                                  validate: (value) {
                                    if (value.toString().isEmpty) {
                                      return "password must not be empty";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, ResetPasswordScreen.route);
                                        },
                                        child: const Text(
                                          "Reset Password?",
                                          style: TextStyle(color: Colors.blue),
                                        )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            BlocProvider.of<LoginCubit>(context)
                                                .login(
                                                    emailAddress:
                                                        emailController.text,
                                                    password:
                                                        passwordController.text);
                                          }
                                        },
                                        child: const Text("Log in"))),
                                const Spacer(flex: 2),
                                Text.rich(
                                  TextSpan(
                                      text: "I don't have an account ",
                                      children: [
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigator.pushReplacementNamed(
                                                    context, SignUpScreen.route);
                                              },
                                            text: "Sign Up",
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ]),
                                ),
                                const SizedBox(
                                  height: 10,
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
