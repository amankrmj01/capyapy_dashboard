import 'package:capyapy_dashboard/presentation/bloc/project_creation/project_creation_bloc.dart';
import 'package:capyapy_dashboard/presentation/bloc/project_creation/project_creation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../data/datasources/mock_project_data_source.dart';
import '../../../domain/usecases/project/create_project_usecase.dart';
import 'widgets/projects_list.dart';
import '../../../data/repositories/project_repository_impl.dart';
import '../../bloc/projects/projects_bloc.dart';
import '../../bloc/projects/projects_event.dart';
import '../../bloc/projects/projects_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/services/service_locator.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  bool _hasRefreshed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Removed the auto-load from here since ProjectsBloc doesn't exist yet
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
    final dataSource = sl<MockProjectDataSource>();
    // Check for refresh flag in GoRouter extra
    final router = GoRouter.of(context);
    final refreshFlag = router.routerDelegate.currentConfiguration.extra;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasRefreshed &&
          refreshFlag is Map &&
          refreshFlag['refresh'] == true) {
        context.read<ProjectsBloc>().add(const RefreshProjects());
        _hasRefreshed = true;
      }
    });
    return BlocProvider(
      create: (_) => ProjectsBloc(
        projectRepository: ProjectRepositoryImpl(dataSource: dataSource),
      )..add(const LoadProjects()),
      child: BlocProvider(
        create: (_) => ProjectCreationBloc(
          createProjectUseCase: CreateProjectUseCase(
            repository: ProjectRepositoryImpl(dataSource: dataSource),
          ),
        ),
        child: Builder(
          builder: (context) =>
              BlocListener<ProjectCreationBloc, ProjectCreationState>(
                listener: (context, state) {
                  if (state is ProjectCreationSuccess) {
                    // Refresh projects after creating a new one
                    context.read<ProjectsBloc>().add(const RefreshProjects());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Project "${state.project.projectName}" created successfully!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is ProjectCreationError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${state.message}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: _ProjectsPageContent(
                  scrollController: _scrollController,
                  transitionProgress: _transitionProgress,
                  headerHeight: _headerHeight,
                  collapsedOpacity: _collapsedOpacity,
                  expandedOpacity: _expandedOpacity,
                  startProjectCreation: _startProjectCreation,
                  formatNumber: _formatNumber,
                ),
              ),
        ),
      ),
    );
  }

  void _startProjectCreation(BuildContext context) {
    context.go('/dashboard/project/new');
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

// Separate the content into its own widget to have cleaner code
class _ProjectsPageContent extends StatelessWidget {
  final ScrollController scrollController;
  final double transitionProgress;
  final double headerHeight;
  final double collapsedOpacity;
  final double expandedOpacity;
  final Function(BuildContext) startProjectCreation;
  final String Function(int) formatNumber;

  const _ProjectsPageContent({
    required this.scrollController,
    required this.transitionProgress,
    required this.headerHeight,
    required this.collapsedOpacity,
    required this.expandedOpacity,
    required this.startProjectCreation,
    required this.formatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              SizedBox(height: headerHeight + 20),
              _buildQuickStats(context),
              _buildProjectsList(context),
              const SizedBox(height: 32),
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
      curve: Curves.easeOut,
      margin: EdgeInsets.lerp(
        const EdgeInsets.only(left: 24, right: 24, top: 16),
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        transitionProgress,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.lerp(
          BorderRadius.circular(12),
          BorderRadius.circular(20),
          transitionProgress,
        ),
        boxShadow: transitionProgress > 0.3
            ? [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.1 * transitionProgress,
                  ),
                  blurRadius: 12 * transitionProgress,
                  offset: Offset(0, 4 * transitionProgress),
                ),
              ]
            : null,
      ),
      child: Container(
        height: headerHeight,
        padding: EdgeInsets.lerp(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          transitionProgress,
        ),
        child: Stack(
          alignment: AlignmentGeometry.centerLeft,
          children: [
            // Expanded layout
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: expandedOpacity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '🗂️ Projects',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('🚀', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create and manage your mock API services',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => startProjectCreation(context),
                    icon: Icon(Icons.add),
                    label: Text('Create New Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Collapsed layout
            AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: collapsedOpacity,
              child: Row(
                children: [
                  Text('🗂️', style: GoogleFonts.inter(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Projects',
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => startProjectCreation(context),
                    icon: Icon(Icons.add, size: 16),
                    label: Text('New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: Size(0, 32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1300 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: List.generate(
                4,
                (index) => _buildLoadingStatCard(context),
              ),
            ),
          );
        }

        if (state is ProjectsLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 1300 ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  context,
                  icon: '📊',
                  title: 'Total Projects',
                  value: '${state.totalProjects}',
                  subtitle: '${state.activeProjects} Active',
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  icon: '🔗',
                  title: 'Endpoints',
                  value: '${state.totalEndpoints}',
                  subtitle: 'Across all projects',
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  icon: '📝',
                  title: 'Data Models',
                  value: '${state.totalModels}',
                  subtitle: 'Total schemas',
                  color: Colors.orange,
                ),
                _buildStatCard(
                  context,
                  icon: '⚡',
                  title: 'API Calls',
                  value: formatNumber(state.totalApiCalls),
                  subtitle: 'This month',
                  color: Colors.purple,
                ),
              ],
            ),
          );
        }

        // Error or initial state - show empty cards
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 1300 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                context,
                icon: '📊',
                title: 'Total Projects',
                value: '--',
                subtitle: 'Loading...',
                color: Colors.blue,
              ),
              _buildStatCard(
                context,
                icon: '🔗',
                title: 'Endpoints',
                value: '--',
                subtitle: 'Loading...',
                color: Colors.green,
              ),
              _buildStatCard(
                context,
                icon: '📝',
                title: 'Data Models',
                value: '--',
                subtitle: 'Loading...',
                color: Colors.orange,
              ),
              _buildStatCard(
                context,
                icon: '⚡',
                title: 'API Calls',
                value: '--',
                subtitle: 'Loading...',
                color: Colors.purple,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 20)),
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStatCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 24,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 14,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: ProjectsList(onCreateProject: startProjectCreation),
    );
  }
}
