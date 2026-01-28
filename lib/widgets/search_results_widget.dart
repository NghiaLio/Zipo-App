import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/userModels.dart';
import '../utils/responsive_helper.dart';

class SearchResultsWidget extends StatelessWidget {
  final List<UserApp> searchResults;
  final Function(UserApp) onUserTap;
  final bool isLoading;

  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.onUserTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return Container(
        height: ResponsiveHelper.getResponsiveSize(context, 200),
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: colorScheme.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (searchResults.isEmpty) {
      return Container(
        height: ResponsiveHelper.getResponsiveSize(context, 200),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: ResponsiveHelper.getResponsiveSize(context, 48),
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
            Text(
              AppLocalizations.of(context)!.no_results_message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 16),
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: ResponsiveHelper.getResponsiveSize(context, 300),
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getScreenPadding(context).left,
        vertical: 8,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: searchResults.length,
          separatorBuilder:
              (context, index) => Divider(
                height: 1,
                indent: 68,
                color: theme.dividerColor.withOpacity(0.05),
              ),
          itemBuilder: (context, index) {
            final user = searchResults[index];
            return InkWell(
              onTap: () => onUserTap(user),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsiveSize(context, 16),
                  vertical: ResponsiveHelper.getResponsiveSize(context, 12),
                ),
                child: Row(
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          width: ResponsiveHelper.getResponsiveSize(
                            context,
                            40,
                          ),
                          height: ResponsiveHelper.getResponsiveSize(
                            context,
                            40,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.onSurface.withOpacity(0.05),
                              width: 1,
                            ),
                          ),
                          child:
                              user.avatarUrl?.isNotEmpty ?? false
                                  ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.avatarUrl!,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => CircleAvatar(
                                            backgroundColor: colorScheme
                                                .onSurface
                                                .withOpacity(0.05),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: colorScheme.primary,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => CircleAvatar(
                                            backgroundColor: colorScheme
                                                .onSurface
                                                .withOpacity(0.05),
                                            child: Icon(
                                              Icons.person,
                                              color: theme.disabledColor,
                                              size: 20,
                                            ),
                                          ),
                                    ),
                                  )
                                  : CircleAvatar(
                                    backgroundColor: colorScheme.onSurface
                                        .withOpacity(0.05),
                                    child: Icon(
                                      Icons.person,
                                      color: theme.disabledColor,
                                      size: 20,
                                    ),
                                  ),
                        ),
                        if (user.isOnline ?? false)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      width: ResponsiveHelper.getResponsiveSize(context, 12),
                    ),

                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.userName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                16,
                              ),
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (user.otherName?.isNotEmpty ?? false)
                            Text(
                              user.otherName!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: ResponsiveHelper.getFontSize(
                                  context,
                                  13,
                                ),
                                color: colorScheme.onSurface.withOpacity(0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: theme.disabledColor,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
