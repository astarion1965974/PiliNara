import 'package:PiliPlus/common/widgets/coui_menu.dart';
import 'package:PiliPlus/pages/common/page_order/page_order_mixin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:material_ui/material_ui.dart';

mixin PageOrderBtnMixin<S extends StatefulWidget, R, T> on State<S> {
  PageOrderMixin<R, T> get controller;

  Widget get pageOrderBtn => Builder(
    builder: (context) => IconButton(
      icon: controller.pageDesc
          ? const Icon(MdiIcons.sortNumericDescending)
          : const Icon(MdiIcons.sortNumericAscending),
      tooltip: '页码顺序',
      onPressed: () async {
        final value = await showCouiMenu<bool>(
          context: context,
          items: [
            CouiMenuItem<bool>(
              label: '正序',
              value: false,
              selected: !controller.pageDesc,
            ),
            CouiMenuItem<bool>(
              label: '倒序',
              value: true,
              selected: controller.pageDesc,
            ),
          ],
        );
        if (value != null && context.mounted) {
          controller.updatePageOrder(value);
          (context as Element).markNeedsBuild();
        }
      },
    ),
  );
}
