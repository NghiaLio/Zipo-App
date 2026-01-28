import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/themes/app_colors.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _showEmailInput = false;
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.security_menu,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.security,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.reset_password_menu,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.protect_account_subtitle,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.security_description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (_showEmailInput) ...[
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.email_label,
                        labelStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        hintText:
                            AppLocalizations.of(context)!.enter_email_hint,
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_showEmailInput) {
                          _sendResetEmail();
                        } else {
                          setState(() {
                            _showEmailInput = true;
                          });
                        }
                      },
                      icon: Icon(
                        _showEmailInput ? Icons.send : Icons.lock_reset,
                        size: 20,
                      ),
                      label: Text(
                        _showEmailInput
                            ? AppLocalizations.of(context)!.send_button
                            : AppLocalizations.of(context)!.reset_password_menu,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  if (_showEmailInput) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _showEmailInput = false;
                            _emailController.clear();
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel_action,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.security_tips_title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSecurityTip(
                    Icons.password,
                    AppLocalizations.of(context)!.strong_password_tip,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityTip(
                    Icons.update,
                    AppLocalizations.of(context)!.periodic_change_tip,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityTip(
                    Icons.no_accounts,
                    AppLocalizations.of(context)!.no_share_password_tip,
                  ),
                  const SizedBox(height: 8),
                  _buildSecurityTip(
                    Icons.verified_user,
                    AppLocalizations.of(context)!.two_factor_auth_tip,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTip(IconData icon, String text) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _sendResetEmail() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.onError),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.enter_your_email,
                style: TextStyle(color: colorScheme.onError),
              ),
            ],
          ),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.onError),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.invalid_email_error,
                style: TextStyle(color: colorScheme.onError),
              ),
            ],
          ),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.reset_email_sent_success,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );

    setState(() {
      _showEmailInput = false;
      _emailController.clear();
    });
  }
}
