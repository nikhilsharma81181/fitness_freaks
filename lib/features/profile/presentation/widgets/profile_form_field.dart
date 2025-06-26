import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool isOptional;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.7),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            if (isOptional) ...[
              const SizedBox(width: 4),
              Text(
                '(Optional)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1.0,
                ),
              ),
              child: TextFormField(
                controller: controller,
                validator: validator,
                keyboardType: keyboardType,
                maxLines: maxLines,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your ${label.toLowerCase()}',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  errorStyle: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
