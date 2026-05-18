import 'package:flutter/material.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';

/// imail fork (2026-05-18): LTR / RTL paragraph-direction toggle row
/// for the format sheet. Tapping either button inserts a fresh
/// `<div dir="…">` at the cursor so subsequent typing renders in the
/// chosen direction. Mirrors the same `BorderContainer + Row +
/// FormatStyleButton + CustomVerticalDivider` chrome as the
/// alignment / indent rows for visual consistency.
class ListFormatTextDirection extends StatelessWidget {
  final RichTextController richTextController;

  const ListFormatTextDirection({
    super.key,
    required this.richTextController,
  });

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): pre-light the matching button from
    // the ambient `Directionality` when no explicit choice has been
    // made yet — so on Arabic / Hebrew / Persian locales the RTL
    // button reads as "engaged" by default (the host app's locale
    // direction is the implicit starting state), and LTR reads as
    // engaged on English / Latin locales. Once the user explicitly
    // taps a button, `textDirectionTypeApply` wins and stays.
    final ambient = Directionality.of(context) == TextDirection.rtl
        ? TextDirectionType.rtl
        : TextDirectionType.ltr;
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.textDirectionTypeApply,
        builder: (context, value, __) {
          final selected = value ?? ambient;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_text_direction_ltr_button'),
                  iconAsset: ImagePaths().icTextDirectionLtr,
                  isSelected: selected == TextDirectionType.ltr,
                  onTapAction: () => richTextController
                      .selectTextDirection(TextDirectionType.ltr),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_text_direction_rtl_button'),
                  iconAsset: ImagePaths().icTextDirectionRtl,
                  isSelected: selected == TextDirectionType.rtl,
                  onTapAction: () => richTextController
                      .selectTextDirection(TextDirectionType.rtl),
                  packageName: packageName,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
