import 'package:flutter/material.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import '../utils/responsive_helper.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final String? initialValue;

  const SearchBarWidget({super.key, this.onSearchChanged, this.initialValue});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final height = ResponsiveHelper.getResponsiveSize(
      context,
      40,
    ).clamp(36.0, 48.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: TextField(
        controller: _controller,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: ResponsiveHelper.getFontSize(context, 15),
          color: colorScheme.onSurface,
        ),
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search_hint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.5),
            fontSize: ResponsiveHelper.getFontSize(context, 15),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.onSurface.withOpacity(0.5),
            size: ResponsiveHelper.getFontSize(context, 20),
          ),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: colorScheme.onSurface.withOpacity(0.5),
                      size: ResponsiveHelper.getFontSize(context, 18),
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearchChanged?.call('');
                    },
                  )
                  : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.25),
        ),
      ),
    );
  }
}
