import 'package:expense_app/core/localization/app_string_key.dart';
import 'package:expense_app/core/localization/app_strings_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int selectedIndex = _AppBottomDestination.values.indexWhere(
      (_AppBottomDestination destination) => destination.matches(location),
    );

    return NavigationBar(
      selectedIndex: selectedIndex == -1 ? 0 : selectedIndex,
      onDestinationSelected: (int index) {
        final _AppBottomDestination destination =
            _AppBottomDestination.values[index];
        if (destination.routePath == location) {
          return;
        }

        context.go(destination.routePath);
      },
      destinations: _AppBottomDestination.values.map((
        _AppBottomDestination destination,
      ) {
        return NavigationDestination(
          key: Key(destination.keyValue),
          icon: Icon(destination.icon),
          selectedIcon: Icon(destination.selectedIcon),
          label: destination.label(context),
        );
      }).toList(),
    );
  }
}

enum _AppBottomDestination {
  dashboard(
    routePath: '/',
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard_rounded,
    keyValue: 'bottom_nav_dashboard',
  ),
  transactions(
    routePath: '/transactions',
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long_rounded,
    keyValue: 'bottom_nav_transactions',
  ),
  statistics(
    routePath: '/statistics',
    icon: Icons.pie_chart_outline_rounded,
    selectedIcon: Icons.pie_chart_rounded,
    keyValue: 'bottom_nav_statistics',
  ),
  reports(
    routePath: '/reports',
    icon: Icons.description_outlined,
    selectedIcon: Icons.description_rounded,
    keyValue: 'bottom_nav_reports',
  ),
  settings(
    routePath: '/settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    keyValue: 'bottom_nav_settings',
  );

  const _AppBottomDestination({
    required this.routePath,
    required this.icon,
    required this.selectedIcon,
    required this.keyValue,
  });

  final String routePath;
  final IconData icon;
  final IconData selectedIcon;
  final String keyValue;

  bool matches(String location) {
    if (routePath == '/') {
      return location == routePath;
    }

    return location == routePath || location.startsWith('$routePath/');
  }

  String label(BuildContext context) {
    return switch (this) {
      _AppBottomDestination.dashboard => context.strings.t(
        AppStringKey.navDashboard,
      ),
      _AppBottomDestination.transactions => context.strings.t(
        AppStringKey.navTransactions,
      ),
      _AppBottomDestination.statistics => context.strings.t(
        AppStringKey.navStatistics,
      ),
      _AppBottomDestination.reports => context.strings.t(
        AppStringKey.navReports,
      ),
      _AppBottomDestination.settings => context.strings.t(
        AppStringKey.navSettings,
      ),
    };
  }
}
