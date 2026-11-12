import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/pages/setting/models/model.dart';
import 'package:material_ui/material_ui.dart';

/// Groups adjacent settings without changing their state or callbacks.
class CouiSettingRow extends StatelessWidget {
  const CouiSettingRow({
    super.key,
    required this.settings,
    required this.index,
  });

  final List<SettingsModel> settings;
  final int index;

  @override
  Widget build(BuildContext context) {
    final item = settings[index];
    if (item is WidgetModel) return item.widget;
    final first = index == 0 || settings[index - 1] is WidgetModel;
    final last =
        index == settings.length - 1 || settings[index + 1] is WidgetModel;
    final hasIcon =
        item.leading != null ||
        (item is SplitModel && item.normalModel.leading != null);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, first ? 8 : 0, 16, last ? 8 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: first ? const Radius.circular(Coui.card) : Radius.zero,
          bottom: last ? const Radius.circular(Coui.card) : Radius.zero,
        ),
        child: Material(
          color: Coui.cardColor(scheme),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.widget,
              if (!last)
                Divider(
                  height: .5,
                  thickness: .5,
                  indent: hasIcon ? 72 : 16,
                  endIndent: 16,
                  color: scheme.outline.withValues(alpha: .12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
