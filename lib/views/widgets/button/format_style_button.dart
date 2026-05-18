import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef OnFormatStyleButtonTapAction = Function();

class FormatStyleButton extends StatelessWidget {

  final OnFormatStyleButtonTapAction? onTapAction;
  final String iconAsset;
  final bool isSelected;
  final Color? iconColor;
  final String? packageName;
  /// imail fork (2026-05-18): when true AND the ambient
  /// [Directionality] is `rtl`, the rendered SVG is horizontally
  /// flipped. Use for directional glyphs (indent, outdent, back
  /// chevron) so the format toolbar mirrors correctly in RTL locales.
  /// Defaults to false — most format icons (B, I, U, S, align-left/
  /// center/right which are semantic positions, list bullets, etc.)
  /// must NOT mirror.
  final bool rtlMirror;

  const FormatStyleButton({
    super.key,
    required this.iconAsset,
    this.onTapAction,
    this.isSelected = false,
    this.iconColor,
    this.packageName,
    this.rtlMirror = false,
  });

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): theme-aware paints.
    // * Default icon tint reads `onSurfaceVariant` (gray on light,
    //   light-gray on dark) instead of the legacy static
    //   `CommonColor.colorIconSelect = #99A2AD` which on dark looked
    //   washed-out and on OLED could disappear.
    // * Selected-state ICON tint moves to `primary` (the host app's
    //   brand color via the ambient ThemeData) so the active button
    //   reads as "engaged" — was the SAME gray as unselected,
    //   removing the visual distinction.
    // * Selected-state BG moves to `primary` with 12% opacity — a
    //   light brand-tint wash that lifts on white AND on dark.
    // Caller-supplied `iconColor` still wins when provided (used by
    // ListFormatColor to paint the foreground/background-color swatch).
    final scheme = Theme.of(context).colorScheme;
    final Color resolvedIconColor;
    if (iconColor != null) {
      resolvedIconColor = iconColor!;
    } else if (isSelected) {
      resolvedIconColor = scheme.primary;
    } else {
      resolvedIconColor = scheme.onSurfaceVariant;
    }
    Widget icon = SvgPicture.asset(
      iconAsset,
      colorFilter: ColorFilter.mode(resolvedIconColor, ui.BlendMode.srcIn),
      package: packageName,
      fit: BoxFit.contain,
    );

    if (rtlMirror && Directionality.of(context) == TextDirection.rtl) {
      icon = Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1.0, 1.0, 1.0),
        child: icon,
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTapAction,
        child: Container(
          color: isSelected
            ? scheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          height: double.infinity,
          child: LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: icon,
          ),
        ),
      ),
    );
  }
}