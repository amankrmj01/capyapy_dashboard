import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/analytics_chart.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/notifications_section.dart';
import 'package:capyapy_dashboard/presentation/pages/dashboard/widget/overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';

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
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _scrollOffset = _scrollController.offset.clamp(0.0, 100.0);
    });
  }

  // Calculate progress from 0.0 to 1.0 based on scroll
  double get _transitionProgress => (_scrollOffset / 100.0).clamp(0.0, 1.0);

  // Calculate header height (120 -> 70)
  double get _headerHeight => 120.0 - (50.0 * _transitionProgress);

  // Calculate if we should show collapsed layout (starts fading in at 40% progress)
  double get _collapsedOpacity =>
      ((_transitionProgress - 0.4) / 0.6).clamp(0.0, 1.0);

  // Calculate expanded layout opacity (starts fading out at 20% progress)
  double get _expandedOpacity =>
      (1.0 - (_transitionProgress / 0.5)).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: _headerHeight + 20),
              // Dynamic space for floating header
              _buildOverviewCards(context),
              _buildAnalyticsSection(context),
              _buildNotificationsSection(context),
              const SizedBox(height: 32),
              // Bottom padding
            ],
          ),
        ),
        _buildFloatingHeader(context),
      ],
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      // Faster for smoother scroll
      curve: Curves.easeOut,
      margin: EdgeInsets.lerp(
        const EdgeInsets.only(left: 24, right: 24, top: 16),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        _transitionProgress,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.lerp(
          BorderRadius.circular(12),
          BorderRadius.circular(20),
          _transitionProgress,
        ),
        boxShadow: _transitionProgress > 0.3
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.1 * _transitionProgress,
                  ),
                  blurRadius: 12 * _transitionProgress,
                  offset: Offset(0, 4 * _transitionProgress),
                ),
              ]
            : null,
      ),
      child: Container(
        height: _headerHeight,
        padding: EdgeInsets.lerp(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          _transitionProgress,
        ),
        child: Stack(
          alignment: AlignmentGeometry.centerLeft,
          children: [
            // Expanded layout (fades out early)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _expandedOpacity,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
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

            // Collapsed layout (fades in later)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _collapsedOpacity,
              child: Row(
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
                  Row(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
        children: [
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
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: NotificationsSection(),
    );
  }
}
