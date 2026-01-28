// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/bloc/auth/authEvent.dart';
import 'package:maintain_chat_app/bloc/auth/authStates.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

import '../../bloc/auth/authBloc.dart';
import '../../widgets/TopSnackBar.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  bool isFieldEmpty = false;
  final emailController = TextEditingController();
  void sendEmail() {
    final String email = emailController.text.trim();
    if (email.isEmpty) {
      showSnackBar.show_error(
        AppLocalizations.of(context)!.enter_your_email,
        context,
      );
    } else {
      context.read<AuthBloc>().add(ResetPasswordEvent(email));
    }
  }

  @override
  void initState() {
    emailController.addListener(() {
      if (emailController.text.isEmpty) {
        setState(() {
          isFieldEmpty = false;
        });
      } else {
        setState(() {
          isFieldEmpty = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.message != null && state.message!.isNotEmpty) {
              if (state.message == emailController.text.trim()) {
                showDialog(
                  context: context,
                  builder: (context) => dialogSuccess(),
                );
              } else {
                showSnackBar.show_error(
                  _getTranslatedMessage(context, state.message!),
                  context,
                );
              }
            }
          },
          child: Column(
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
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_reset, size: 60, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.reset_password_title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.enter_email_to_reset,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(Size size) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.email_address,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 12),
          _buildEmailField(),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.reset_instructions,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildSendButton(size),
          const SizedBox(height: 20),
          _buildBackToLoginButton(),
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
        hintText: AppLocalizations.of(context)!.email_hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0288D1), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildSendButton(Size size) {
    return GestureDetector(
      onTap: isFieldEmpty ? sendEmail : null,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient:
              isFieldEmpty
                  ? const LinearGradient(
                    colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isFieldEmpty ? null : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              isFieldEmpty
                  ? [
                    BoxShadow(
                      color: const Color(0xFF0288D1).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          AppLocalizations.of(context)!.send_reset_link,
          style: TextStyle(
            color: isFieldEmpty ? Colors.white : Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLoginButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        AppLocalizations.of(context)!.back_to_login,
        style: const TextStyle(
          color: Color(0xFF0288D1),
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget dialogSuccess() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF0288D1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read,
                size: 40,
                color: Color(0xFF0288D1),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.email_sent,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF424242),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.email_sent_details,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0288D1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.got_it,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
