import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Localization-aware price / period label.
String rentPeriodLabel(bool yearly) => yearly ? 'per_year'.tr : 'per_month'.tr;

/// True when the active locale is Arabic; picks the bilingual mock copy.
bool isArabicLocale() => (Get.locale?.languageCode ?? 'ar') == 'ar';

/// A soft gradient used by property headers when no remote photo is available.
/// Keeps the app fully offline-capable while looking like a listing photo frame.
List<Color> propertyGradient(ColorScheme scheme, int seed) {
  final List<Color> palettes = <Color>[
    scheme.primaryContainer,
    scheme.secondaryContainer,
    scheme.tertiaryContainer,
    scheme.surfaceContainerHighest,
  ];
  final Color start = palettes[seed % palettes.length];
  final Color end = Color.alphaBlend(
    scheme.primary.withValues(alpha: 0.22),
    start,
  );
  return <Color>[start, end];
}

/// Wraps the app's content cards with the brand radius.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.onTap,
    this.border = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final BorderRadius radius = BorderRadius.circular(20);

    return Material(
      color: color ?? scheme.surface,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: border
                ? Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
