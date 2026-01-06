import 'package:flutter/material.dart';
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
    final height = ResponsiveHelper.getResponsiveSize(
      context,
      40,
    ).clamp(36.0, 48.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: TextField(
        controller: _controller,
        style: TextStyle(fontSize: ResponsiveHelper.getFontSize(context, 15)),
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: ResponsiveHelper.getFontSize(context, 15),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: ResponsiveHelper.getFontSize(context, 22),
          ),
          suffixIcon:
              _controller.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[600],
                      size: ResponsiveHelper.getFontSize(context, 20),
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
