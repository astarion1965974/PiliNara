import 'package:PiliPlus/common/coui.dart';
import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:material_ui/material_ui.dart';

/// Surfaces shared by the search entry and search results.
class SearchChrome {
  static Color background(ColorScheme scheme) =>
      VideoDetailChrome.background(scheme);

  static Color accent(ColorScheme scheme) => VideoDetailChrome.accent(scheme);

  static Color pill(ColorScheme scheme) => VideoDetailChrome.pill(scheme);

  static Color field(ColorScheme scheme) =>
      CouiThemeData.fromScheme(scheme).inputFillColor;
}

class SearchBackground extends StatelessWidget {
  const SearchBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => VideoDetailBackground(child: child);
}

class SearchFieldSurface extends StatelessWidget {
  const SearchFieldSurface({super.key, required this.child, this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final coui = CouiThemeData.of(context);
    final fillColor = Color.alphaBlend(
      coui.inputFillColor,
      coui.surfaceBackground,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: Coui.cardRadius,
        border: Border.all(color: coui.inputBorderColor, width: 0.75),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: Coui.cardRadius,
        child: InkWell(
          borderRadius: Coui.cardRadius,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(Icons.search, size: 19, color: coui.accent),
                const SizedBox(width: 8),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
