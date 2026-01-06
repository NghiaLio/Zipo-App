// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

        showSnackBar.show_success('Ảnh đã được chọn', context);
      }
    } catch (e) {
      showSnackBar.show_error('Lỗi khi chọn ảnh: $e', context);
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
      showSnackBar.show_error('Tên không được để trống', context);
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
        showSnackBar.show_error('Lỗi khi tải ảnh lên: $e', context);
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

    showSnackBar.show_success('Đã lưu thông tin', context);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_isEditing) {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Hủy chỉnh sửa?'),
                      content: const Text('Các thay đổi sẽ không được lưu'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Ở lại'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Hủy'),
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
          'Thông tin cá nhân',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.getFontSize(context, 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.isViewOnly && !_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: _toggleEditMode,
            ),
          if (!widget.isViewOnly && _isEditing)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: _toggleEditMode,
            ),
        ],
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.error != null) {
            showSnackBar.show_error('Lỗi: ${state.error}', context);
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[300],
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
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : (_currentAvatarPath == null &&
                                        (_originalAvatarUrl == null ||
                                            _originalAvatarUrl!.isEmpty)
                                    ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.grey[600],
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
                                color: const Color(0xFF0288D1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoField(
                      label: 'Tên hiển thị',
                      controller: _userNameController,
                      icon: Icons.person,
                      required: true,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: 'Tên khác',
                      controller: _otherNameController,
                      icon: Icons.badge,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: 'Số điện thoại',
                      controller: _phoneController,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const Divider(height: 24),
                    _buildInfoField(
                      label: 'Địa chỉ',
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin khác',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildReadOnlyInfo(
                      label: 'Email',
                      value: widget.user.email,
                      icon: Icons.email,
                    ),
                    const Divider(height: 24),
                    _buildReadOnlyInfo(
                      label: 'Số bạn bè',
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
                      backgroundColor: const Color(0xFF0288D1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lưu thay đổi',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getFontSize(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getFontSize(context, 14),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (required) const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: _isEditing,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: ResponsiveHelper.getFontSize(context, 16),
            color: _isEditing ? Colors.black : Colors.grey[700],
          ),
          decoration: InputDecoration(
            border: _isEditing ? const OutlineInputBorder() : InputBorder.none,
            contentPadding:
                _isEditing
                    ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                    : EdgeInsets.zero,
            hintText: _isEditing ? 'Nhập $label' : null,
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
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getFontSize(context, 16),
                  color: Colors.grey[800],
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
