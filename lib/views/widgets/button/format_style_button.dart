
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

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
    Widget icon = SvgPicture.asset(
      iconAsset,
      colorFilter: ColorFilter.mode(
        isSelected
          ? CommonColor.colorIconSelect
          : iconColor ?? CommonColor.colorIconSelect,
        BlendMode.srcIn
      ),
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
            ? CommonColor.colorBackgroundSelect
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