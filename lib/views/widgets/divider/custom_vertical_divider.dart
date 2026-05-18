
import 'package:flutter/material.dart';

class CustomVerticalDivider extends StatelessWidget {

  const CustomVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): theme-aware divider — was hardcoded
    // `CommonColor.colorBorderGray` (#E4E4E4) which on dark looked
    // far brighter than the surrounding chrome.
    return Container(
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
