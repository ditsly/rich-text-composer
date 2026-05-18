
import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';

class ListFormatColor extends StatelessWidget {

  final RichTextController richTextController;
  final String? foregroundColorLabel;
  final String? backgroundColorLabel;
  final VoidCallback? onSelectForegroundColor;
  final VoidCallback? onSelectBackgroundColor;

  const ListFormatColor({
    super.key,
    required this.richTextController,
    this.foregroundColorLabel,
    this.backgroundColorLabel,
    this.onSelectForegroundColor,
    this.onSelectBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextColor,
              builder: (context, _, __) {
                // imail fork (2026-05-18): when the chosen foreground
                // text color is `Colors.black` (the controller's
                // default initial value) AND the ambient brightness
                // is dark, fall back to the theme's `onSurface` so
                // the "A" glyph stays legible. Was hardcoded to
                // `selectedTextColor.value` which on dark / OLED
                // painted the icon BLACK against a near-black sheet
                // → invisible. Mirror of the
                // `selectedTextBackgroundColor == Colors.white` fix
                // we already shipped for the paint-bucket below.
                // If the user explicitly picks black on light mode,
                // we honour it (Colors.black on white is fine).
                final selectedFg = richTextController.selectedTextColor.value;
                final isDark =
                    Theme.of(context).brightness == Brightness.dark;
                final iconTint = (selectedFg == Colors.black && isDark)
                    ? Theme.of(context).colorScheme.onSurface
                    : selectedFg;
                return Expanded(
                  child: FormatStyleButton(
                    key: const Key('foreground_color_button'),
                    iconAsset: ImagePaths().icTextColor,
                    iconColor: iconTint,
                    onTapAction: () {
                      if (ResponsiveUtils().isMobile(context)) {
                        _handleSelectForegroundColorAction(context);
                      } else {
                        onSelectForegroundColor?.call();
                      }
                    },
                    packageName: packageName,
                  ),
                );
              }),
          const CustomVerticalDivider(),
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextBackgroundColor,
              builder: (context, _, __) {
                // imail fork (2026-05-18): brightness-aware fallback.
                // The controller defaults `selectedTextBackgroundColor`
                // to `Colors.white` — visible against dark surfaces
                // but invisible on light. So fall back to the theme's
                // `onSurfaceVariant` gray ONLY on light mode. On dark
                // mode the chosen white reads fine, so honour the
                // user's choice.
                final selectedBg = richTextController
                    .selectedTextBackgroundColor.value;
                final isLight =
                    Theme.of(context).brightness == Brightness.light;
                final iconTint = (selectedBg == Colors.white && isLight)
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : selectedBg;
                return Expanded(
                  child: FormatStyleButton(
                    key: const Key('background_color_button'),
                    iconAsset: ImagePaths().icBackgroundColor,
                    iconColor: iconTint,
                    onTapAction: () {
                      if (ResponsiveUtils().isMobile(context)) {
                        _handleSelectBackgroundColorAction(context);
                      } else {
                        onSelectBackgroundColor?.call();
                      }
                    },
                    packageName: packageName,
                  ),
                );
              })
        ],
      ),
    );
  }

  void _handleSelectForegroundColorAction(BuildContext context) {
    DialogUtils().showDialogBottomSheet(
      context,
      OptionBottomSheet(
        title: foregroundColorLabel ?? 'Foreground',
        child: ValueListenableBuilder(
          valueListenable: richTextController.selectedTextColor,
          builder: (context, _, __) {
            return ColorPickerKeyboard(
              currentColor: richTextController.selectedTextColor.value,
              padding: const EdgeInsets.all(24),
              onSelected: (color) {
                richTextController.selectTextColor(color);
                Navigator.of(context).pop();
              },
            );
          }
        ),
      ));
  }

  void _handleSelectBackgroundColorAction(BuildContext context) {
    DialogUtils().showDialogBottomSheet(
      context,
      OptionBottomSheet(
        title: backgroundColorLabel ?? 'Background',
        child: ValueListenableBuilder(
          valueListenable: richTextController.selectedTextBackgroundColor,
          builder: (context, _, __) {
            return ColorPickerKeyboard(
              currentColor: richTextController.selectedTextBackgroundColor.value,
              padding: const EdgeInsets.all(24),
              onSelected: (color) {
                richTextController.selectBackgroundColor(color);
                Navigator.of(context).pop();
              },
            );
          }
        ),
      ));
  }
}