import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instgram_clone/controller/cubit/forgot_password/reset_password_cubit.dart';
import 'package:instgram_clone/utils/constants.dart';
import 'package:instgram_clone/view/screens/login_screen.dart';
import '../widgets/textfiled_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  static const String route = "resetPasswordScreen";

  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScreen.route);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              Navigator.pushReplacementNamed(context, LoginScreen.route);
              Constants.getSnackBar(
                  context,
                  "Link for reset password send to you email, please check your email.",
                  Colors.green);
            } else if (state is ResetPasswordFailure) {
              Constants.getSnackBar(context, state.error, Colors.red);
            }
          },
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please enter your email for reset password.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
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
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        ResetPasswordCubit.get(context)
                            .resetPassword(email: emailController.text);
                      }
                    },
                    child: const Text("Reset Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
