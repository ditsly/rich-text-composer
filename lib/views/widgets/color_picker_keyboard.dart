import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

class ColorPickerKeyboard extends StatelessWidget {
  final Function(Color)? onSelected;
  final Color currentColor;
  final EdgeInsetsGeometry? padding;

  const ColorPickerKeyboard({
    required this.currentColor,
    Key? key,
    this.onSelected,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // imail fork (2026-05-18): theme-aware container + selection
    // border. Outer container was `Colors.white` (invisible on dark);
    // current-color border was `Colors.white` (also invisible on dark
    // when picking the white swatch). Now reads `surface` (matches the
    // surrounding sheet) and `onSurface` (always contrasts with the
    // swatch beneath it).
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: scheme.surface,
        ),
        padding: padding ?? const EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: 35),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: LayoutBuilder(builder: (context, constraint) {
            return ClipRRect(
              child: Wrap(children: CommonColor.listColorsPicker
                .map((color) => _itemColorWidget(context, constraint.maxWidth, color))
                .toList()),
            );
          }),
        ),
      ),
    );
  }

  Widget _itemColorWidget(BuildContext context, double maxWidth, Color color) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelected?.call(color),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: currentColor == color ? scheme.onSurface : Colors.transparent,
              width: 3,
            ),
          ),
          width: (maxWidth / 12).floorToDouble(),
          height: 24.0,
        ),
      ),
    );
  }
}
