import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

class ProfilePhotoPicker extends StatefulWidget {
  final String? currentImagePath;
  final Function(String?) onImageSelected;

  const ProfilePhotoPicker({
    super.key,
    this.currentImagePath,
    required this.onImageSelected,
  });

  @override
  State<ProfilePhotoPicker> createState() => _ProfilePhotoPickerState();
}

class _ProfilePhotoPickerState extends State<ProfilePhotoPicker> {
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = widget.currentImagePath;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImagePickerOptions,
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.profileGradient1.withOpacity(0.8),
                  AppColors.profileGradient2.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: _selectedImagePath != null
                  ? Image.file(
                      File(_selectedImagePath!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Icon(
                CupertinoIcons.camera_fill,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Icon(
          CupertinoIcons.person_fill,
          color: Colors.white.withOpacity(0.9),
          size: 48,
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),

                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Choose Profile Photo',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPickerOption(
                            icon: CupertinoIcons.camera_fill,
                            label: 'Camera',
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromCamera();
                            },
                          ),
                          _buildPickerOption(
                            icon: CupertinoIcons.photo_fill,
                            label: 'Gallery',
                            onTap: () {
                              Navigator.pop(context);
                              _pickImageFromGallery();
                            },
                          ),
                          if (_selectedImagePath != null)
                            _buildPickerOption(
                              icon: CupertinoIcons.trash_fill,
                              label: 'Remove',
                              color: const Color(0xFFFF6B6B),
                              onTap: () {
                                Navigator.pop(context);
                                _removeImage();
                              },
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final optionColor = color ?? AppColors.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: optionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: optionColor.withOpacity(0.3),
                    width: 1.0,
                  ),
                ),
                child: Icon(
                  icon,
                  color: optionColor,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _pickImageFromCamera() {
    // TODO: Implement camera image picking
    // This would typically use image_picker package
    _showToast('Camera functionality coming soon!');
  }

  void _pickImageFromGallery() {
    // TODO: Implement gallery image picking
    // This would typically use image_picker package
    _showToast('Gallery functionality coming soon!');
  }

  void _removeImage() {
    setState(() {
      _selectedImagePath = null;
    });
    widget.onImageSelected(null);
    _showToast('Profile photo removed');
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: AppColors.darkCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
