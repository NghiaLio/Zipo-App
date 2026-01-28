import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/screens/profiles/friends_tab.dart';
import 'package:maintain_chat_app/screens/profiles/friend_requests_tab.dart';
import '../../utils/responsive_helper.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
          AppLocalizations.of(context)!.friends_title,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontSize: ResponsiveHelper.getFontSize(context, 24),
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.search_hint,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    suffixIcon:
                        _searchQuery.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: colorScheme.onSurface.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurface.withOpacity(0.4),
                labelStyle: theme.textTheme.titleMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                ),
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.friends_title),
                  Tab(text: AppLocalizations.of(context)!.friend_requests_tab),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FriendsTab(searchQuery: _searchQuery),
          FriendRequestsTab(searchQuery: _searchQuery),
        ],
      ),
    );
  }
}
