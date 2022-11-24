import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  static SignUpCubit get(context) => BlocProvider.of(context);

  signUp({required String emailAddress, required String password}) async {
    emit(SignUpLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      emit(SignUpSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpFailure("The password provided is too weak."));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpFailure('The account already exists for that email.'));
      }
      else{
        emit(SignUpFailure(e.message.toString()));
      }
    } catch (error) {
      emit(SignUpFailure(error.toString()));
    }
  }
}
