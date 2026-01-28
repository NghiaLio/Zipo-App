// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authBloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/auth/authStates.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

import '../../widgets/Loading.dart';
import '../../widgets/TopSnackBar.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFieldEmpty = false;
  bool passVisible = true;
  bool confirmPassVisible = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void backBtn() {
    Navigator.pop(context);
  }

  void tapToSignIn() {
    Navigator.pop(context);
  }

  void passVisibleBtn() {
    setState(() {
      passVisible = !passVisible;
    });
  }

  void confirmPassVisibleBtn() {
    setState(() {
      confirmPassVisible = !confirmPassVisible;
    });
  }

  void tapToRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      context.read<AuthBloc>().add(
        RegisterEvent(
          nameController.text.trim(),
          emailController.text.trim(),
          passController.text.trim(),
        ),
      );
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }

  //check Empty
  void checkEmpty() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passController.text.isEmpty ||
        confirmPassController.text.isEmpty) {
      setState(() {
        isFieldEmpty = false;
      });
    } else {
      setState(() {
        isFieldEmpty = true;
      });
    }
  }

  //validated
  String? validatedEmail(String? value) {
    final bool emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(value!);
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.enter_email;
    }
    if (!emailValid) {
      return AppLocalizations.of(context)!.email_not_correct;
    }
    return null;
  }

  String? validatedName(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.enter_name;
    }
    if (value.length < 4) {
      return AppLocalizations.of(context)!.name_too_short;
    }
    return null;
  }

  String? validatedPass(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.enter_password;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.password_too_short;
    }
    return null;
  }

  String? validatedConfirmpass(String? value) {
    if (value!.isEmpty) {
      return AppLocalizations.of(context)!.enter_confirm_password;
    }
    if (value != passController.text.trim()) {
      return AppLocalizations.of(context)!.confirm_password_not_match;
    }
    return null;
  }

  @override
  void initState() {
    nameController.addListener(checkEmpty);
    emailController.addListener(checkEmpty);
    passController.addListener(checkEmpty);
    confirmPassController.addListener(checkEmpty);
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.message != null &&
            state.message!.isNotEmpty &&
            !state.isAuthenticated) {
          showSnackBar.show_error(
            _getTranslatedMessage(context, state.message!),
            context,
          );
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              Expanded(flex: 3, child: _buildHeader(size)),
              const Spacer(),
              Expanded(flex: 5, child: _buildFormCard(size)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
        ),
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(100)),
      ),
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Text(
          AppLocalizations.of(context)!.create_account_title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNameField(),
                const SizedBox(height: 18),
                _buildEmailField(),
                const SizedBox(height: 18),
                _buildPasswordField(),
                const SizedBox(height: 18),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildSignUpButton(size),
              ],
            ),
            const SizedBox(height: 18),
            _buildSignInLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      validator: (value) => validatedName(value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF0288D1)),
        hintText: AppLocalizations.of(context)!.full_name,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => validatedEmail(value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0288D1)),
        hintText: AppLocalizations.of(context)!.phone_or_email,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passController,
      obscureText: passVisible,
      validator: (value) => validatedPass(value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0288D1)),
        hintText: AppLocalizations.of(context)!.password,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        suffixIcon: IconButton(
          onPressed: passVisibleBtn,
          icon: Icon(
            passVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPassController,
      obscureText: confirmPassVisible,
      validator: (value) => validatedConfirmpass(value),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0288D1)),
        hintText: AppLocalizations.of(context)!.confirm_password,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        suffixIcon: IconButton(
          onPressed: confirmPassVisibleBtn,
          icon: Icon(
            confirmPassVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey.shade600,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildSignUpButton(Size size) {
    return GestureDetector(
      onTap: tapToRegister,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF0288D1),
          borderRadius: BorderRadius.circular(28),
        ),
        child:
            isLoading
                ? Loading(heightWidth: size.width * 0.08, color: Colors.white)
                : Text(
                  AppLocalizations.of(context)!.signup_button,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.already_have_account,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        GestureDetector(
          onTap: tapToSignIn,
          child: Text(
            AppLocalizations.of(context)!.signin_link,
            style: const TextStyle(
              color: Color(0xFF0288D1),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  String _getTranslatedMessage(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    switch (message) {
      case 'auth_error_user_not_found':
        return l10n.auth_error_user_not_found;
      case 'auth_error_wrong_password':
        return l10n.auth_error_wrong_password;
      case 'auth_error_invalid_email':
        return l10n.auth_error_invalid_email;
      case 'auth_error_user_disabled':
        return l10n.auth_error_user_disabled;
      case 'auth_error_too_many_requests':
        return l10n.auth_error_too_many_requests;
      case 'auth_error_network_failed':
        return l10n.auth_error_network_failed;
      case 'auth_error_invalid_credential':
        return l10n.auth_error_invalid_credential;
      case 'auth_error_email_already_in_use':
        return l10n.auth_error_email_already_in_use;
      case 'auth_error_weak_password':
        return l10n.auth_error_weak_password;
      case 'auth_error_operation_not_allowed':
        return l10n.auth_error_operation_not_allowed;
      case 'auth_login_failed':
        return l10n.auth_login_failed;
      case 'auth_register_failed':
        return l10n.auth_register_failed;
      case 'auth_check_failed':
        return l10n.auth_check_failed;
      case 'auth_reset_failed':
        return l10n.auth_reset_failed;
      case 'auth_error_default':
        return l10n.auth_error_default;
      default:
        return message;
    }
  }
}
