import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/project_builder/project_builder_bloc.dart';
import '../../bloc/project_builder/project_builder_event.dart';
import '../../bloc/project_builder/project_builder_state.dart';
import '../../../core/constants/app_colors.dart';
import 'widgets/project_creation_wizard.dart';
import 'widgets/projects_list.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  bool _showCreateProjectWizard = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectBuilderBloc(),
      child: BlocListener<ProjectBuilderBloc, ProjectBuilderState>(
        listener: (context, state) {
          if (state is ProjectBuilderSuccess) {
            setState(() {
              _showCreateProjectWizard = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Project "${state.project.projectName}" created successfully!',
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProjectBuilderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _showCreateProjectWizard
            ? ProjectCreationWizard(
                onClose: () {
                  setState(() {
                    _showCreateProjectWizard = false;
                  });
                  context.read<ProjectBuilderBloc>().add(const ResetBuilder());
                },
              )
            : _buildProjectsOverview(context),
      ),
    );
  }

  Widget _buildProjectsOverview(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildQuickStats(context),
        _buildProjectsList(context),
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
                            onPressed: _startProjectCreation,
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
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
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
                            onPressed: _startProjectCreation,
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
        ),
        delegate: SliverChildListDelegate([
          _buildStatCard(
            context,
            icon: '📊',
            title: 'Total Projects',
            value: '8',
            subtitle: '3 Active',
            color: Colors.blue,
          ),
          _buildStatCard(
            context,
            icon: '🔗',
            title: 'Endpoints',
            value: '42',
            subtitle: 'Across all projects',
            color: Colors.green,
          ),
          _buildStatCard(
            context,
            icon: '📝',
            title: 'Data Models',
            value: '15',
            subtitle: 'Total schemas',
            color: Colors.orange,
          ),
          _buildStatCard(
            context,
            icon: '⚡',
            title: 'API Calls',
            value: '1,234',
            subtitle: 'This month',
            color: Colors.purple,
          ),
        ]),
      ),
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
                  child: Text(icon, style: TextStyle(fontSize: 20)),
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

  Widget _buildProjectsList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: ProjectsList(onCreateProject: _startProjectCreation),
      ),
    );
  }

  void _startProjectCreation() {
    setState(() {
      _showCreateProjectWizard = true;
    });
    context.read<ProjectBuilderBloc>().add(const StartProjectCreation());
  }
}
