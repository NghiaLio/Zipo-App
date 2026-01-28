// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maintain_chat_app/l10n/app_localizations.dart';
import 'package:maintain_chat_app/bloc/users/userBloc.dart';
import 'package:maintain_chat_app/constants/storagePath.dart';
import 'package:maintain_chat_app/bloc/users/userEvent.dart';
import 'package:maintain_chat_app/bloc/users/userState.dart';
import 'package:maintain_chat_app/models/userModels.dart';
import 'package:maintain_chat_app/models/message_models.dart';
import 'package:maintain_chat_app/services/fileService.dart';
import 'package:maintain_chat_app/widgets/TopSnackBar.dart';
import '../../utils/responsive_helper.dart';

class ProfileDetailPage extends StatefulWidget {
  final UserApp user;
  final bool isViewOnly;

  const ProfileDetailPage({
    super.key,
    required this.user,
    this.isViewOnly = false,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  bool _isEditing = false;
  bool _isUploadingImage = false;
  late TextEditingController _userNameController;
  late TextEditingController _otherNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _originalAvatarUrl;
  String? _currentAvatarPath;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
    _otherNameController = TextEditingController(
      text: widget.user.otherName ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.user.phoneNumber ?? '',
    );
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _originalAvatarUrl = widget.user.avatarUrl;
    _currentAvatarPath = null;
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _otherNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _currentAvatarPath = image.path;
        });

        showSnackBar.show_success(
          AppLocalizations.of(context)!.image_selected_success,
          context,
        );
      }
    } catch (e) {
      showSnackBar.show_error(
        '${AppLocalizations.of(context)!.image_pick_error}: $e',
        context,
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Cancel - reset về giá trị ban đầu
        _userNameController.text = widget.user.userName;
        _otherNameController.text = widget.user.otherName ?? '';
        _phoneController.text = widget.user.phoneNumber ?? '';
        _addressController.text = widget.user.address ?? '';
        _currentAvatarPath = null;
      }
    });
  }

  void _saveProfile() async {
    if (_userNameController.text.trim().isEmpty) {
      showSnackBar.show_error(
        AppLocalizations.of(context)!.name_empty_error,
        context,
      );
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    String? avatarUrl = _originalAvatarUrl;
    if (_currentAvatarPath != null) {
      try {
        avatarUrl = await FileService.processFilePicked(
          XFile(_currentAvatarPath!),
          MessageType.Image,
          '$AVATAR_PATH${widget.user.id}',
          'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
          AVATAR_IMAGE_BUCKET,
        );
      } catch (e) {
        showSnackBar.show_error(
          '${AppLocalizations.of(context)!.error_occurred}: $e',
          context,
        );
        setState(() {
          _isUploadingImage = false;
        });
        return;
      }
    }

    final updatedUser = widget.user.copyWith(
      userName: _userNameController.text.trim(),
      otherName:
          _otherNameController.text.trim().isEmpty
              ? null
              : _otherNameController.text.trim(),
      phoneNumber:
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
      address:
          _addressController.text.trim().isEmpty
              ? null
              : _addressController.text.trim(),
      avatarUrl: avatarUrl,
    );

    context.read<UserBloc>().add(UpdateUserProfileEvent(updatedUser));

    setState(() {
      _isEditing = false;
      _isUploadingImage = false;
    });

    showSnackBar.show_success(
      AppLocalizations.of(context)!.info_saved_success,
      context,
    );

    Navigator.pop(context);
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
          onPressed: () {
            if (_isEditing) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      backgroundColor: colorScheme.surface,
                      title: Text(
                        AppLocalizations.of(context)!.cancel_edit_title,
                        style: theme.textTheme.titleLarge,
                      ),
                      content: Text(
                        AppLocalizations.of(context)!.cancel_edit_message,
                        style: theme.textTheme.bodyMedium,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppLocalizations.of(context)!.stay_button,
                            style: TextStyle(color: colorScheme.primary),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.confirm_cancel_button,
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.personal_info_title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.isViewOnly && !_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: colorScheme.onSurface),
              onPressed: _toggleEditMode,
            ),
          if (!widget.isViewOnly && _isEditing)
            IconButton(
              icon: Icon(Icons.close, color: colorScheme.error),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            showSnackBar.show_error(
              '${AppLocalizations.of(context)!.error_label}: ${state.error}',
              context,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Avatar Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.onSurface.withOpacity(0.1),
                        backgroundImage:
                            _currentAvatarPath != null
                                ? FileImage(File(_currentAvatarPath!))
                                : (_originalAvatarUrl != null &&
                                        _originalAvatarUrl!.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                      _originalAvatarUrl!,
                                    )
                                    : null),
                        child:
                            _isUploadingImage
                                ? CircularProgressIndicator(
                                  color: colorScheme.primary,
                                )
                                : (_currentAvatarPath == null &&
                                        (_originalAvatarUrl == null ||
                                            _originalAvatarUrl!.isEmpty)
                                    ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.3,
                                      ),
                                    )
                                    : null),
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap:
                                _isUploadingImage ? null : _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Profile Info Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField(
                      label: AppLocalizations.of(context)!.display_name_label,
                      controller: _userNameController,
                      icon: Icons.person,
                      required: true,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: AppLocalizations.of(context)!.other_name_label,
                      controller: _otherNameController,
                      icon: Icons.badge,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: AppLocalizations.of(context)!.phone_number_label,
                      controller: _phoneController,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: AppLocalizations.of(context)!.address_label,
                      controller: _addressController,
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Additional Info Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.other_info_section,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReadOnlyInfo(
                      label: AppLocalizations.of(context)!.email_label,
                      value: widget.user.email,
                      icon: Icons.email,
                    ),
                    const Divider(height: 24),
                    _buildReadOnlyInfo(
                      label: AppLocalizations.of(context)!.friends_stat,
                      value: widget.user.friends?.length.toString() ?? '0',
                      icon: Icons.people,
                    ),
                  ],
                ),
              ),

              if (!widget.isViewOnly && _isEditing) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.save_changes_button,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: ResponsiveHelper.getFontSize(context, 14),
                color: colorScheme.onSurface.withOpacity(0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required)
              Text(' *', style: TextStyle(color: colorScheme.error)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: _isEditing,
          keyboardType: keyboardType,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            color:
                _isEditing
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.7),
          ),
          decoration: InputDecoration(
            border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: colorScheme.onSurface.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                _isEditing
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                    : EdgeInsets.zero,
            hintText: _isEditing ? l10n.enter_field_hint(label) : null,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyInfo({
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.onSurface.withOpacity(0.6)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                  color: colorScheme.onSurface.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
