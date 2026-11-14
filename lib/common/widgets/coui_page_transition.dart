import 'package:PiliPlus/common/coui.dart';
import 'package:material_ui/material_ui.dart';

/// ColorOS-inspired horizontal slide page transition driven by [CouiMotion].
class CouiPageTransitionsBuilder extends PageTransitionsBuilder {
  const CouiPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final primary = CurvedAnimation(
      parent: animation,
      curve: CouiMotion.pageTransitionCurve,
      reverseCurve: CouiMotion.pageTransitionCurve.flipped,
    );
    final secondary = CurvedAnimation(
      parent: secondaryAnimation,
      curve: CouiMotion.pageTransitionCurve,
      reverseCurve: CouiMotion.pageTransitionCurve.flipped,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.22, 0.0),
      ).animate(secondary),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(primary),
        child: child,
      ),
    );
  }
}
