import 'package:capyapy_dashboard/presentation/pages/billings/billing_page.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/dashboard_page.dart';
import 'package:capyapy_dashboard/presentation/pages/projects/projects_page.dart';
import 'package:capyapy_dashboard/presentation/pages/settings/settings_page.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/dashboard_sidebar.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    ProjectsPage(),
    BillingPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}
