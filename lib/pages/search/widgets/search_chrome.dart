import 'package:PiliPlus/pages/video/widgets/detail_chrome.dart';
import 'package:material_ui/material_ui.dart';

/// Surfaces shared by the search entry and search results.
class SearchChrome {
  static Color background(ColorScheme scheme) =>
      VideoDetailChrome.background(scheme);

  static Color accent(ColorScheme scheme) => VideoDetailChrome.accent(scheme);

  static Color pill(ColorScheme scheme) => VideoDetailChrome.pill(scheme);

  static Color field(ColorScheme scheme) =>
      scheme.brightness == Brightness.dark
          ? scheme.surfaceContainerHigh.withValues(alpha: 0.85)
          : Colors.white.withValues(alpha: 0.88);
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
    final scheme = ColorScheme.of(context);
    return Material(
      color: SearchChrome.field(scheme),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.search, size: 19, color: SearchChrome.accent(scheme)),
              const SizedBox(width: 8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
