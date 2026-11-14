import 'package:PiliPlus/common/widgets/coui_menu.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

typedef PopupMenuItemSelected<T> = bool Function(T value);

class PopupMenuText<T> extends StatelessWidget {
  final String title;
  final ValueGetter<T> value;
  final PopupMenuItemSelected<T> onSelected;
  final PopupMenuItemBuilder<T> itemBuilder;
  final String Function(T) getSelectTitle;

  const PopupMenuText({
    super.key,
    required this.title,
    required this.value,
    required this.onSelected,
    required this.itemBuilder,
    required this.getSelectTitle,
  });

  @override
  Widget build(BuildContext context) {
    final select = value();
    final secondary = ColorScheme.of(context).secondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$title: '),
        Builder(
          builder: (menuContext) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final entries = <CouiMenuEntry<T>>[];
              for (final entry in itemBuilder(menuContext)) {
                if (entry is PopupMenuDivider) {
                  entries.add(CouiMenuDivider<T>());
                } else if (entry is PopupMenuItem<T>) {
                  final child = entry.child;
                  final label = child is Text ? (child.data ?? '') : '';
                  entries.add(
                    CouiMenuItem<T>(
                      label: label,
                      value: entry.value,
                      enabled: entry.enabled,
                      selected: entry.value == select,
                      onTap: entry.onTap,
                    ),
                  );
                }
              }
              final selected = await showCouiMenu<T>(
                context: menuContext,
                items: entries,
              );
              if (selected == null || selected == select) return;
              if (!onSelected(selected) && context.mounted) {
                (context as Element).markNeedsBuild();
              }
            },
            child: Text.rich(
              style: TextStyle(height: 1, fontSize: 14, color: secondary),
              strutStyle: const StrutStyle(height: 1, leading: 0, fontSize: 14),
              TextSpan(
                text: getSelectTitle(select),
                children: [
                  WidgetSpan(
                    alignment: .middle,
                    child: Icon(
                      size: 14,
                      MdiIcons.unfoldMoreHorizontal,
                      color: secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
