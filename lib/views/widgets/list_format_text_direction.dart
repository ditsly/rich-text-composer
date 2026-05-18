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
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.textDirectionTypeApply,
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_text_direction_ltr_button'),
                  iconAsset: ImagePaths().icTextDirectionLtr,
                  isSelected: richTextController.textDirectionTypeApply.value ==
                      TextDirectionType.ltr,
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
                  isSelected: richTextController.textDirectionTypeApply.value ==
                      TextDirectionType.rtl,
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
