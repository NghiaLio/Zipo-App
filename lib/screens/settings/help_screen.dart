import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          AppLocalizations.of(context)!.help_menu,
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
                          Icons.help_outline,
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
                              AppLocalizations.of(context)!.help_support_title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.help_support_subtitle,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(
              AppLocalizations.of(context)!.faq_section,
              context,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFAQItem(
                    AppLocalizations.of(context)!.faq_how_to_send_msg_q,
                    AppLocalizations.of(context)!.faq_how_to_send_msg_a,
                    Icons.message_outlined,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    AppLocalizations.of(context)!.faq_how_to_delete_msg_q,
                    AppLocalizations.of(context)!.faq_how_to_delete_msg_a,
                    Icons.delete_outline,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    AppLocalizations.of(context)!.faq_how_to_change_avatar_q,
                    AppLocalizations.of(context)!.faq_how_to_change_avatar_a,
                    Icons.account_circle_outlined,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildFAQItem(
                    AppLocalizations.of(context)!.faq_how_to_disable_notif_q,
                    AppLocalizations.of(context)!.faq_how_to_disable_notif_a,
                    Icons.notifications_off_outlined,
                    context,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle(
              AppLocalizations.of(context)!.contact_support_section,
              context,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactItem(
                    Icons.email_outlined,
                    'Email',
                    'support@chatapp.com',
                    AppLocalizations.of(context)!.contact_email_desc,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.phone_outlined,
                    AppLocalizations.of(context)!.contact_hotline_label,
                    '1900 xxxx',
                    AppLocalizations.of(context)!.contact_hotline_desc,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.chat_bubble_outline,
                    'Live Chat',
                    AppLocalizations.of(context)!.contact_livechat_label,
                    AppLocalizations.of(context)!.contact_livechat_desc,
                    context,
                  ),
                  const Divider(height: 1),
                  _buildContactItem(
                    Icons.language,
                    'Website',
                    'www.chatapp.com/help',
                    AppLocalizations.of(context)!.contact_website_desc,
                    context,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.average_response_time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildFAQItem(
    String question,
    String answer,
    IconData icon,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 20),
      ),
      title: Text(
        question,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answer,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String value,
    String subtitle,
    BuildContext context,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 22),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: () {
        // Handle contact action
      },
    );
  }
}
