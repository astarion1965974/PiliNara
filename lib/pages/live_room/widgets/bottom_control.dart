import 'package:PiliPlus/common/widgets/custom_icon.dart';
import 'package:PiliPlus/common/widgets/coui_menu.dart';
import 'package:PiliPlus/models/common/video/base_quality.dart';
import 'package:PiliPlus/pages/live_room/controller.dart';
import 'package:PiliPlus/pages/video/widgets/header_mixin.dart';
import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/video_fit_type.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/common_btn.dart';
import 'package:PiliPlus/plugin/pl_player/widgets/play_pause_btn.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/theme_utils.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:material_ui/material_ui.dart';

class BottomControl extends StatefulWidget {
  const BottomControl({
    super.key,
    required this.plPlayerController,
    required this.liveRoomCtr,
    required this.onRefresh,
    this.subTitleStyle = const TextStyle(fontSize: 12),
    this.titleStyle = const TextStyle(fontSize: 14),
  });

  final PlPlayerController plPlayerController;
  final LiveRoomController liveRoomCtr;
  final VoidCallback onRefresh;

  final TextStyle subTitleStyle;
  final TextStyle titleStyle;

  @override
  State<BottomControl> createState() => _BottomControlState();
}

class _BottomControlState extends State<BottomControl> with HeaderMixin {
  late final LiveRoomController liveRoomCtr = widget.liveRoomCtr;
  @override
  late final PlPlayerController plPlayerController = widget.plPlayerController;
  @override
  ThemeData get theme => ThemeUtils.darkTheme;

  @override
  Widget build(BuildContext context) {
    final isFullScreen = plPlayerController.isFullScreen.value;
    return Padding(
      padding: const .symmetric(horizontal: 14, vertical: 13),
      child: Material(
        type: .transparency,
        child: Row(
          children: [
            PlayOrPauseButton(plPlayerController: plPlayerController),
            ComBtn(
              height: 30,
              tooltip: '刷新',
              icon: const Icon(
                Icons.refresh,
                size: 18,
                color: Colors.white,
              ),
              onTap: widget.onRefresh,
            ),
            const Spacer(),
            ComBtn(
              height: 30,
              tooltip: '屏蔽',
              icon: const Icon(
                size: 18,
                Icons.block,
                color: Colors.white,
              ),
              onTap: () {
                if (kDebugMode || liveRoomCtr.isLogin) {
                  Get.toNamed(
                    '/liveDmBlockPage',
                    parameters: {
                      'roomId': liveRoomCtr.roomId.toString(),
                    },
                    arguments: liveRoomCtr,
                  );
                } else {
                  SmartDialog.showToast('账号未登录');
                }
              },
            ),
            const SizedBox(width: 3),
            Obx(
              () {
                final enableShowLiveDanmaku =
                    plPlayerController.enableShowLiveDanmaku.value;
                return ComBtn(
                  height: 30,
                  tooltip: "${enableShowLiveDanmaku ? '关闭' : '开启'}弹幕",
                  icon: enableShowLiveDanmaku
                      ? const Icon(
                          size: 18,
                          CustomIcons.dm_on,
                          color: Colors.white,
                        )
                      : const Icon(
                          size: 18,
                          CustomIcons.dm_off,
                          color: Colors.white,
                        ),
                  onTap: () {
                    final newVal = !enableShowLiveDanmaku;
                    plPlayerController.enableShowLiveDanmaku.value = newVal;
                    if (!plPlayerController.tempPlayerConf) {
                      GStorage.setting.put(
                        SettingBoxKey.enableShowLiveDanmaku,
                        newVal,
                      );
                    }
                  },
                );
              },
            ),
            ComBtn(
              height: 30,
              tooltip: '弹幕设置',
              icon: const Icon(
                size: 18,
                CustomIcons.dm_settings,
                color: Colors.white,
              ),
              onTap: () => showSetDanmaku(isLive: true),
            ),
            Obx(
              () {
                final fit = plPlayerController.videoFit.value;
                return Builder(
                  builder: (menuContext) => Tooltip(
                    message: '画面比例',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => showCouiMenu<VideoFitType>(
                        context: menuContext,
                        items: VideoFitType.values
                            .map(
                              (boxFit) => CouiMenuItem<VideoFitType>(
                                label: boxFit.desc,
                                value: boxFit,
                                selected: boxFit == fit,
                                onTap: () =>
                                    plPlayerController.toggleVideoFit(boxFit),
                              ),
                            )
                            .toList(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          fit.desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Obx(
              () {
                final quality = liveRoomCtr.currentQn.value;
                if (quality == null) {
                  return const SizedBox.shrink();
                }
                return Builder(
                  builder: (menuContext) => Tooltip(
                    message: '画质',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final selected = await showCouiMenu<LiveQuality>(
                          context: menuContext,
                          items: liveRoomCtr.acceptQnList
                              .map(
                                (e) => CouiMenuItem<LiveQuality>(
                                  label: e.desc,
                                  value: e,
                                  selected: e == quality,
                                ),
                              )
                              .toList(),
                        );
                        if (selected != null) {
                          liveRoomCtr.changeQn(selected);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          quality.desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (!plPlayerController.isDesktopPip)
              ComBtn(
                height: 30,
                tooltip: isFullScreen ? '退出全屏' : '全屏',
                icon: isFullScreen
                    ? const Icon(
                        Icons.fullscreen_exit,
                        size: 24,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.fullscreen,
                        size: 24,
                        color: Colors.white,
                      ),
                onTap: () =>
                    plPlayerController.triggerFullScreen(status: !isFullScreen),
                onSecondaryTap: () => plPlayerController.triggerFullScreen(
                  status: !isFullScreen,
                  inAppFullScreen: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
