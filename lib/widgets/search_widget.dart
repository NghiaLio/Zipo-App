import 'package:flutter/material.dart';
import '../models/userModels.dart';
import '../utils/responsive_helper.dart';
import 'search_bar_widget.dart';
import 'search_results_widget.dart';

class SearchWidget extends StatefulWidget {
  final List<UserApp> allUsers;
  final Function(UserApp)? onUserSelected;
  final Function(bool)? onSearchStateChanged;

  const SearchWidget({
    super.key,
    required this.allUsers,
    this.onUserSelected,
    this.onSearchStateChanged,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<UserApp> _searchResults = [];
  bool _isSearching = false;

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      widget.onSearchStateChanged?.call(false);
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simple search implementation - you can make this more sophisticated
    final results =
        widget.allUsers.where((user) {
          final userName = user.userName.toLowerCase();
          final otherName = user.otherName?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();

          return userName.contains(searchQuery) ||
              otherName.contains(searchQuery);
        }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });

    widget.onSearchStateChanged?.call(_searchResults.isNotEmpty);
  }

  void _onUserTap(UserApp user) {
    widget.onUserSelected?.call(user);
    // Clear search after selection
    setState(() {
      _searchResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBarWidget(onSearchChanged: _onSearchChanged),
        if (_searchResults.isNotEmpty || _isSearching)
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveHelper.getResponsiveSize(context, 8),
            ),
            child: SearchResultsWidget(
              searchResults: _searchResults,
              onUserTap: _onUserTap,
              isLoading: _isSearching,
            ),
          ),
      ],
    );
  }
}
