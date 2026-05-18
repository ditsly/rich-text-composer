import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_horizontal_divider.dart';

class OptionBottomSheet extends StatelessWidget {
  const OptionBottomSheet({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // imail fork patch (2026-05-18): swap the two hardcoded
    // `Colors.white` paints + the close-button SVG tint for
    // `Theme.of(context).colorScheme.surface` / `onSurface` so the
    // sheet theme-flips on dark + OLED. Title text style also reads
    // `onSurface` so it stays legible. Drop-in replacement: every
    // existing call site keeps the same constructor signature.
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      left: ResponsiveUtils().isPortraitMobile(context),
      right: ResponsiveUtils().isPortraitMobile(context),
      top: ResponsiveUtils().isMobile(context),
      bottom: ResponsiveUtils().isMobile(context),
      child: Container(
        color: scheme.surface,
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height - 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),),
                color: scheme.surface,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 28,
                    height: 28,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: Navigator.of(context).pop,
                      customBorder: const CircleBorder(),
                      child: SvgPicture.asset(
                        ImagePaths().icDismiss,
                        fit: BoxFit.fill,
                        width: 28,
                        height: 28,
                        package: packageName,
                        colorFilter: ColorFilter.mode(
                          scheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const CustomHorizontalDivider(),
            Flexible(child: child)
          ],
        ),
      ),
    );
  }
}
