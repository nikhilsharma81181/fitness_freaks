import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double iconSize;
  final double height;
  final double? width;
  final EdgeInsets padding;
  final double borderRadius;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.iconSize = 20,
    this.height = 56,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.borderRadius = 12,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
      },
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height,
        padding: padding,
        decoration: _getDecoration(context),
        child: Center(
          child: isLoading
              ? _buildLoader(context)
              : _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    final Color color = type == ButtonType.primary
        ? Colors.white
        : Theme.of(context).primaryColor;
        
    return SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final Color textColor = type == ButtonType.primary
        ? Colors.white
        : Theme.of(context).primaryColor;
        
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            color: textColor,
            size: iconSize,
          ),
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: textStyle ??
              TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  BoxDecoration _getDecoration(BuildContext context) {
    switch (type) {
      case ButtonType.primary:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withBlue(
                    (Theme.of(context).primaryColor.blue * 0.8).toInt(),
                  ),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        );
      case ButtonType.secondary:
        return BoxDecoration(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ButtonType.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        );
    }
  }
}
