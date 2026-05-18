import 'package:flutter/material.dart';

import '../../models/types.dart';

// imail fork (2026-05-18): every static `CommonColor.*` paint that
// used to render light-only swatches now reads the ambient
// `Theme.of(context).colorScheme` so the Quick Styles list (H1, H2,
// H3, blockquote, code) flips correctly on dark / OLED. The legacy
// gray block-quote border / gray code chrome + `Colors.black` heading
// text were invisible on dark before this patch.
class ListHeaderStyle extends StatelessWidget {
  const ListHeaderStyle({
    Key? key,
    required this.itemSelected,
  }) : super(key: key);
  final Function(HeaderStyleType) itemSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: HeaderStyleType.values.length,
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsetsDirectional.all(24),
      itemBuilder: (_, index) {
        final item = HeaderStyleType.values[index];
        return Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => itemSelected.call(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildItemDropdown(context, item),
            )
          ),
        );
      },
    );
  }

  Widget _buildItemDropdown(BuildContext context, HeaderStyleType headerStyle) {
    final scheme = Theme.of(context).colorScheme;
    switch (headerStyle) {
      case HeaderStyleType.blockquote:
        return Container(
            decoration: BoxDecoration(
                border: BorderDirectional(
                    start: BorderSide(
                        // Block-quote rail — `outline` reads on both
                        // modes; the legacy `#EEEEEE` was invisible
                        // on dark.
                        color: scheme.outline,
                        width: 5.0))),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: _buildHeaderStyle(
                context,
                headerStyle.styleName,
                headerStyle.textSize,
                headerStyle.fontWeight));
      case HeaderStyleType.code:
        return Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                border: Border.all(
                    color: scheme.outlineVariant,
                    width: 1.0),
                color: scheme.surfaceContainerHighest),
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: _buildHeaderStyle(
                context,
                headerStyle.styleName,
                headerStyle.textSize,
                headerStyle.fontWeight));
      default:
        return _buildHeaderStyle(
            context,
            headerStyle.styleName,
            headerStyle.textSize,
            headerStyle.fontWeight);
    }
  }

  Widget _buildHeaderStyle(
      BuildContext context, String name, double size, FontWeight fontWeight) {
    return Text(name,
        style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            // Was `Colors.black` — invisible on dark / OLED. Now reads
            // `onSurface` so heading text stays legible on every mode.
            color: Theme.of(context).colorScheme.onSurface),
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis);
  }
}
