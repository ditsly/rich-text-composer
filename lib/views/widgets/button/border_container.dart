
import 'package:flutter/material.dart';

class BorderContainer extends StatelessWidget {

  final Widget child;

  const BorderContainer({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): theme-aware border — was hardcoded
    // `CommonColor.colorBorderGray` (#E4E4E4) which on dark / OLED
    // produced a too-bright outline that didn't match the chrome.
    return Container(
      height: 44,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8),),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }
}
