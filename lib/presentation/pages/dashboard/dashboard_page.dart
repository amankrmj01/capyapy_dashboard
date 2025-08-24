import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/analytics_chart.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/notifications_section.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../bloc/dashboard/dashboard_event.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc()..add(const LoadDashboard()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildOverviewCards(context),
        _buildAnalyticsSection(context),
        _buildNotificationsSection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 120,
      collapsedHeight: 70,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shadowColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxHeight <= 80;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: isCollapsed
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: isCollapsed
                  ? AppColors.surface(context)
                  : Colors.transparent,
              borderRadius: isCollapsed
                  ? BorderRadius.circular(16)
                  : BorderRadius.zero,
              boxShadow: isCollapsed
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: FlexibleSpaceBar(
              background: Container(color: Colors.transparent),
              titlePadding: EdgeInsets.only(
                left: isCollapsed ? 20 : 24,
                bottom: isCollapsed ? 20 : 16,
                right: isCollapsed ? 20 : 24,
              ),
              title: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: isCollapsed
                    ? Row(
                        children: [
                          Text('🧭', style: GoogleFonts.inter(fontSize: 20)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Dashboard',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isCollapsed ? 1.0 : 0.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Your Control Center',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text('🖥️', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '🧭 Dashboard',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary(context),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text('🖥️', style: TextStyle(fontSize: 24)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your Control Center',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary(context),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildListDelegate([
          OverviewCard(
            title: "Daily API Usage",
            value: "128 / 500",
            subtitle: "Today's API Calls",
            icon: "📊",
            tooltip: "Your daily API quota resets at midnight",
            color: Colors.blue,
          ),
          OverviewCard(
            title: "Active Projects",
            value: "12",
            subtitle: "Projects",
            icon: "🗂️",
            tooltip: "Projects with at least one active endpoint",
            color: Colors.green,
          ),
          OverviewCard(
            title: "Credits Remaining",
            value: "15,230",
            subtitle: "Credits Left",
            icon: "💳",
            tooltip: "Used for premium features and extended limits",
            color: Colors.orange,
          ),
          OverviewCard(
            title: "Mock Server Status",
            value: "Running",
            subtitle: "Mock Server",
            icon: "🚀",
            tooltip: "Control your mock API instance",
            color: Colors.purple,
            hasToggle: true,
            isToggled: true,
          ),
        ]),
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📈 Analytics',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: AnalyticsChart(
                    title: "API Calls (Last 7 Days)",
                    type: ChartType.line,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AnalyticsChart(
                    title: "Endpoint Types",
                    type: ChartType.pie,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnalyticsChart(
              title: "Top 5 Most-Hit Endpoints",
              type: ChartType.table,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(child: NotificationsSection()),
    );
  }
}
