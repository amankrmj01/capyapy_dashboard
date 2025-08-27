import 'package:capyapy_dashboard/core/utils/export_utils.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/dashboard_sidebar.dart';
import '../bloc/user/user_bloc.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(LoadUser('mock_id'));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    // Get current location from GoRouterState
    final state = GoRouterState.of(context);
    final location = state.uri.toString();
    // Set sidebar index based on route
    if (location == '/dashboard') {
      _selectedIndex = 0;
    } else if (location.startsWith('/dashboard/project')) {
      _selectedIndex = 1;
    } else if (location == '/dashboard/billing') {
      _selectedIndex = 2;
    } else if (location == '/dashboard/settings') {
      _selectedIndex = 3;
    }
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                // Navigate to correct route when sidebar item is clicked
                if (index == 0) {
                  GoRouter.of(context).go('/dashboard');
                } else if (index == 1) {
                  GoRouter.of(context).go('/dashboard/project');
                } else if (index == 2) {
                  GoRouter.of(context).go('/dashboard/billing');
                } else if (index == 3) {
                  GoRouter.of(context).go('/dashboard/settings');
                }
              },
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
