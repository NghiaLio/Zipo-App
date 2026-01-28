// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/utils/validation_utils.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';
import 'package:maintain_chat_app/widgets/friend_invite_list.dart';
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
  List<UserApp> _searchByEmailOrPhoneResults = [];
  bool _isSearching = false;
  bool _isSearchByEmailOrPhone = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchByEmailOrPhoneResults = [];
        _searchResults = [];
        _isSearching = false;
        _isSearchByEmailOrPhone = false;
      });
      widget.onSearchStateChanged?.call(false);
      return;
    }
    if (ValidationUtils.isValidEmail(query) ||
        ValidationUtils.isValidPhoneNumber(query)) {
      // If the query is a valid email or phone number, do not perform search
      try {
        final List<UserApp> results = await context
            .read<UserBloc>()
            .userRepository
            .searchUsersByEmailOrNumberPhone(query);
        setState(() {
          _searchByEmailOrPhoneResults = results;
          _searchResults = [];
          _isSearching = false;
          _isSearchByEmailOrPhone = true;
        });

        widget.onSearchStateChanged?.call(true);
        return;
      } on Exception {
        setState(() {
          _searchByEmailOrPhoneResults = [];
          _searchResults = [];
          _isSearching = false;
          _isSearchByEmailOrPhone = false;
        });

        widget.onSearchStateChanged?.call(false);
        showSnackBar.show_error(
          AppLocalizations.of(context)!.loading_error,
          context,
        );
      }
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
      _searchByEmailOrPhoneResults = [];
      _searchResults = results;
      _isSearching = false;
      _isSearchByEmailOrPhone = false;
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
        if (_isSearchByEmailOrPhone)
          FriendInviteList(listUsers: _searchByEmailOrPhoneResults),
      ],
    );
  }
}
