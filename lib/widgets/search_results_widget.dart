import 'package:flutter/material.dart';
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
    if (isLoading) {
      return Container(
        height: ResponsiveHelper.getResponsiveSize(context, 200),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
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
              color: Colors.grey[400],
            ),
            SizedBox(height: ResponsiveHelper.getResponsiveSize(context, 8)),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 16),
                color: Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getScreenPadding(context).left,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: searchResults.length,
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
                  Container(
                    width: ResponsiveHelper.getResponsiveSize(context, 40),
                    height: ResponsiveHelper.getResponsiveSize(context, 40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            (user.isOnline ?? false)
                                ? Colors.green
                                : Colors.grey[300]!,
                        width: 2,
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
                                      backgroundColor: Colors.grey[300],
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size:
                                            ResponsiveHelper.getResponsiveSize(
                                              context,
                                              20,
                                            ),
                                      ),
                                    ),
                              ),
                            )
                            : CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: ResponsiveHelper.getResponsiveSize(
                                  context,
                                  20,
                                ),
                              ),
                            ),
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
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getFontSize(context, 16),
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (user.otherName?.isNotEmpty ?? false)
                          Text(
                            user.otherName!,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getFontSize(
                                context,
                                14,
                              ),
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Online status indicator
                  if (user.isOnline ?? false)
                    Container(
                      width: ResponsiveHelper.getResponsiveSize(context, 8),
                      height: ResponsiveHelper.getResponsiveSize(context, 8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
