import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import 'app_icon.dart';
import '../../utils/app_enums.dart';

class AnimatedThemeIcon extends StatelessWidget {
  const AnimatedThemeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      onPressed: () {
        settings.setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
      },
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return RotationTransition(
            turns: child.key == const ValueKey('moon')
                ? Tween<double>(begin: 0.75, end: 1.0).animate(animation)
                : Tween<double>(begin: 0.75, end: 1.0).animate(animation),
            child: ScaleTransition(scale: animation, child: child),
          );
        },
        child: isDark
            ? AppIcon(
                AppIconType.moon,
                key: const ValueKey('moon'),
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              )
            : AppIcon(
                AppIconType.sun,
                key: const ValueKey('sun'),
                size: 24,
                color: Colors.orange,
              ),
      ),
      tooltip: 'Toggle Theme',
    );
  }
}
