import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined }

/// Brand button with a built-in loading state. Callers wrap it in `Obx` when
/// the loading flag comes from a controller.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = AppButtonVariant.filled,
    this.height = 54,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final AppButtonVariant variant;
  final double height;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.filled
                    ? scheme.onPrimary
                    : scheme.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    final Widget button = variant == AppButtonVariant.filled
        ? ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: content,
          )
        : OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: content,
          );

    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: button,
    );
  }
}
