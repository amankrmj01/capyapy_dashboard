import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Project> _projects = [
    Project(
      id: '1',
      name: 'E-commerce API',
      status: ProjectStatus.active,
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      endpointCount: 15,
      mockServerRunning: true,
      tags: ['retail', 'payments'],
    ),
    Project(
      id: '2',
      name: 'User Management System',
      status: ProjectStatus.active,
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      endpointCount: 8,
      mockServerRunning: false,
      tags: ['auth', 'users'],
    ),
    Project(
      id: '3',
      name: 'Social Media API',
      status: ProjectStatus.inactive,
      lastModified: DateTime.now().subtract(const Duration(days: 5)),
      endpointCount: 23,
      mockServerRunning: false,
      tags: ['social', 'media'],
    ),
  ];

  List<Project> get filteredProjects {
    if (_searchQuery.isEmpty) return _projects;
    return _projects
        .where(
          (project) =>
              project.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              project.tags.any(
                (tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context),
        _buildSearchBar(context),
        if (filteredProjects.isEmpty)
          _buildEmptyState(context)
        else
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
                          Text('📁', style: GoogleFonts.inter(fontSize: 20)),
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
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isCollapsed ? 1.0 : 0.0,
                            child: Text(
                              'Your Mock API Playground',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary(context),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
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
                            Text(
                              '📁 Projects',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary(context),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Your Mock API Playground',
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

  Widget _buildSearchBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      sliver: SliverToBoxAdapter(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Filter by name, tag, or status...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🐹💻', style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              'No projects yet. Let\'s build your first mock API!',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Capy is chilling with a laptop, waiting for you to start',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showCreateProjectModal,
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Project'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final project = filteredProjects[index];
          return _buildProjectCard(context, project);
        }, childCount: filteredProjects.length),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Project project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusChip(project.status),
                          const SizedBox(width: 8),
                          _buildServerStatusChip(project.mockServerRunning),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, project),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'view', child: Text('👁️ View')),
                    const PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Text('📋 Duplicate'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('🗑️ Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip('📊 ${project.endpointCount} endpoints'),
                const SizedBox(width: 12),
                _buildInfoChip(
                  '🕒 ${_formatLastModified(project.lastModified)}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: project.tags.map((tag) => _buildTagChip(tag)).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewProject(project),
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editProject(project),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ProjectStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.displayName,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status.color,
        ),
      ),
    );
  }

  Widget _buildServerStatusChip(bool isRunning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isRunning ? Colors.green : Colors.grey).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isRunning ? 'Running' : 'Stopped',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isRunning ? Colors.green : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textSecondary(context).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary(context),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '#$tag',
        style: GoogleFonts.inter(fontSize: 11, color: Colors.blue),
      ),
    );
  }

  String _formatLastModified(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _handleMenuAction(String action, Project project) {
    switch (action) {
      case 'view':
        _viewProject(project);
        break;
      case 'edit':
        _editProject(project);
        break;
      case 'duplicate':
        _duplicateProject(project);
        break;
      case 'delete':
        _deleteProject(project);
        break;
    }
  }

  void _viewProject(Project project) {
    // Navigate to project view
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Viewing ${project.name}')));
  }

  void _editProject(Project project) {
    // Navigate to project edit
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Editing ${project.name}')));
  }

  void _duplicateProject(Project project) {
    setState(() {
      _projects.add(
        Project(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: '${project.name} (Copy)',
          status: ProjectStatus.inactive,
          lastModified: DateTime.now(),
          endpointCount: project.endpointCount,
          mockServerRunning: false,
          tags: project.tags,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${project.name} duplicated successfully!')),
    );
  }

  void _deleteProject(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _projects.removeWhere((p) => p.id == project.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${project.name} deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectModal() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Project'),
        content: const Text('Project creation feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class Project {
  final String id;
  final String name;
  final ProjectStatus status;
  final DateTime lastModified;
  final int endpointCount;
  final bool mockServerRunning;
  final List<String> tags;

  Project({
    required this.id,
    required this.name,
    required this.status,
    required this.lastModified,
    required this.endpointCount,
    required this.mockServerRunning,
    required this.tags,
  });
}

enum ProjectStatus {
  active(Colors.green, 'Active'),
  inactive(Colors.grey, 'Inactive');

  const ProjectStatus(this.color, this.displayName);

  final Color color;
  final String displayName;
}
