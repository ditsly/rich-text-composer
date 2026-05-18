
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

typedef OnLabelIconButtonButtonTapAction = Function();

class LabelIconButton extends StatelessWidget {

  final OnLabelIconButtonButtonTapAction? onTapAction;
  final String label;
  final String iconAsset;
  final String? packageName;
  /// imail fork (2026-05-18): mirror the trailing icon when ambient
  /// [Directionality] is `rtl`. Defaults to true since the canonical
  /// use of this widget (the "Quick styles ›" trigger) carries a
  /// trailing arrow-right glyph that must point LEFT in RTL.
  final bool rtlMirrorIcon;

  const LabelIconButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.onTapAction,
    this.packageName,
    this.rtlMirrorIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = SvgPicture.asset(
      iconAsset,
      package: packageName,
      fit: BoxFit.fill,
    );

    if (rtlMirrorIcon && Directionality.of(context) == TextDirection.rtl) {
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CommonColor.colorIconSelect,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            LimitedBox(
              maxWidth: 28,
              maxHeight: 28,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}