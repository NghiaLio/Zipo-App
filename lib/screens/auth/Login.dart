// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/auth/authStates.dart';
import 'package:maintain_chat_app/screens/auth/ResetPass.dart';
import 'package:maintain_chat_app/screens/auth/register.dart';

import '../../bloc/auth/authBloc.dart';
import '../../widgets/Loading.dart';
import '../../widgets/TopSnackBar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLoading = false;
  bool isFieldEmpty = false;
  bool passVisible = true;

  void tapToLogin() async {
    String email = emailController.text.trim();
    String pass = passController.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      showSnackBar.show_error('Nhập thông tin', context);
    } else {
      setState(() {
        isLoading = true;
      });
      context.read<AuthBloc>().add(LoginEvent(email, pass));
      setState(() {
        isLoading = false;
      });
      // context.read<HomeChatCubit>().getListUser();
      // context.read<HomeChatCubit>().getAllChat();
    }
  }

  void _onFieldChange() {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      setState(() {
        isFieldEmpty = false;
      });
    } else {
      setState(() {
        isFieldEmpty = true;
      });
    }
  }

  void tapToResetPass() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => ResetPass()));
  }

  void tapToRegister() {
    Navigator.push(context, MaterialPageRoute(builder: (c) => Register()));
  }

  void visiblePass() {
    setState(() {
      passVisible = !passVisible;
    });
  }

  @override
  void initState() {
    emailController.addListener(_onFieldChange);
    passController.addListener(_onFieldChange);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
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
          showSnackBar.show_error(state.message!, context);
        }
      },
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
        child: const Text(
          'HELLO SIGN IN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
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
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildEmailField(),
              const SizedBox(height: 22),
              _buildPasswordField(),
              const SizedBox(height: 14),
              _buildForgotPasswordButton(),
              SizedBox(height: size.height * 0.2),
              _buildSignInButton(size),
            ],
          ),
          const SizedBox(height: 18),
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF0288D1)),
        hintText: 'Joydeo@gmail.com',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        suffixIcon:
            isFieldEmpty
                ? const Icon(Icons.check, color: Color(0xFF0288D1))
                : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passController,
      obscureText: passVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF0288D1)),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFB3E5FC)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF0288D1)),
        ),
        suffixIcon: IconButton(
          onPressed: visiblePass,
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

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: tapToResetPass,
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: Color(0xFF0288D1),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(Size size) {
    return GestureDetector(
      onTap: tapToLogin,
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
                : const Text(
                  'SIGN IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have account? ",
          style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
        ),
        GestureDetector(
          onTap: tapToRegister,
          child: const Text(
            'Sign up',
            style: TextStyle(
              color: Color(0xFF0288D1),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget itemLogin(String iconPath) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.15,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(shape: BoxShape.circle, border: Border()),
      child: Image(image: AssetImage(iconPath), fit: BoxFit.cover),
    );
  }
}
