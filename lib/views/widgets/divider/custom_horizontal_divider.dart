
import 'package:flutter/material.dart';

class CustomHorizontalDivider extends StatelessWidget {

  const CustomHorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): theme-aware divider — was hardcoded
    // `CommonColor.colorBorderGray` (#E4E4E4).
    return Container(
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
