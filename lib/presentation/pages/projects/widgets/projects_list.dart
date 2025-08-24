import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class ProjectsList extends StatelessWidget {
  final void Function(BuildContext) onCreateProject;

  const ProjectsList({super.key, required this.onCreateProject});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Projects',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement view all projects
              },
              icon: Icon(Icons.list, size: 18),
              label: Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildProjectGrid(context),
      ],
    );
  }

  Widget _buildProjectGrid(BuildContext context) {
    // Mock projects data - in real app this would come from state management
    final projects = [
      _MockProject(
        name: 'E-commerce API',
        description:
            'Complete online store backend with products, orders, and users',
        status: 'Active',
        endpoints: 24,
        models: 8,
        lastUpdated: '2 hours ago',
        color: Colors.blue,
        icon: '🛍️',
      ),
      _MockProject(
        name: 'Blog Service',
        description: 'Content management system for blogs and articles',
        status: 'Active',
        endpoints: 12,
        models: 4,
        lastUpdated: '1 day ago',
        color: Colors.green,
        icon: '📝',
      ),
      _MockProject(
        name: 'User Management',
        description: 'Authentication and user profile management',
        status: 'Inactive',
        endpoints: 8,
        models: 3,
        lastUpdated: '3 days ago',
        color: Colors.orange,
        icon: '👤',
      ),
      _MockProject(
        name: 'Banking API',
        description: 'Financial transactions and account management',
        status: 'Development',
        endpoints: 18,
        models: 6,
        lastUpdated: '5 hours ago',
        color: Colors.purple,
        icon: '🏦',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: projects.length + 1,
      // +1 for create new card
      itemBuilder: (context, index) {
        if (index == projects.length) {
          return _buildCreateProjectCard(context);
        }
        return _buildProjectCard(context, projects[index]);
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, _MockProject project) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to project details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: project.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          project.icon,
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(project.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(
                            project.status,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        project.status,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(project.status),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 16),
                              const SizedBox(width: 8),
                              Text('View'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              const SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 16),
                              const SizedBox(width: 8),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              const SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        // TODO: Handle menu actions
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  project.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    _buildMetric(
                      context,
                      '🔗',
                      project.endpoints.toString(),
                      'endpoints',
                    ),
                    const SizedBox(width: 16),
                    _buildMetric(
                      context,
                      '📋',
                      project.models.toString(),
                      'models',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Updated ${project.lastUpdated}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateProjectCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: Colors.blue, size: 32),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Create New Project',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up a new mock API service with custom data models and endpoints',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary(context),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String icon,
    String value,
    String label,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textSecondary(context),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'development':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}

class _MockProject {
  final String name;
  final String description;
  final String status;
  final int endpoints;
  final int models;
  final String lastUpdated;
  final Color color;
  final String icon;

  const _MockProject({
    required this.name,
    required this.description,
    required this.status,
    required this.endpoints,
    required this.models,
    required this.lastUpdated,
    required this.color,
    required this.icon,
  });
}
