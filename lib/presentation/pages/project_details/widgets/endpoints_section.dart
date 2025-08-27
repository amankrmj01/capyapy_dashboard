import '../../../../core/utils/export_utils.dart';
import '../../../../data/models/models.dart';
import '../../../bloc/project_details/project_details_bloc.dart';
import 'endpoint_editor_dialog.dart';
import 'endpoint_stats.dart';
import '../../project_details/project_provider.dart';

class EndpointsSection extends StatefulWidget {
  final ProjectModel project;
  final Function(ProjectModel)? onProjectUpdated;

  const EndpointsSection({
    super.key,
    required this.project,
    this.onProjectUpdated,
  });

  @override
  State<EndpointsSection> createState() => _EndpointsSectionState();
}

class _EndpointsSectionState extends State<EndpointsSection> {
  String _selectedMethod = 'all';

  @override
  void initState() {
    super.initState();
    context.read<ProjectDetailsBloc>().add(
      LoadProjectDetails(widget.project.id),
    );
  }

  void _addNewEndpoint() {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => EndpointEditorDialog(
        onSave: (endpoint) {
          bloc.add(AddEndpoint(endpoint));
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _editEndpoint(int index, Endpoint endpoint) {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => EndpointEditorDialog(
        endpoint: endpoint,
        onSave: (updatedEndpoint) {
          bloc.add(UpdateEndpoint(index, updatedEndpoint));
          Navigator.of(dialogContext).pop(); // Close dialog
        },
      ),
    );
  }

  void _deleteEndpoint(int index) {
    final bloc = context.read<ProjectDetailsBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete Endpoint',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete this endpoint? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              bloc.add(DeleteEndpoint(index));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete', style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }

  List<Endpoint> _filteredEndpoints(ProjectModel project) {
    if (_selectedMethod == 'all') {
      return project.endpoints;
    }
    return project.endpoints
        .where(
          (endpoint) => endpoint.method.name.toLowerCase() == _selectedMethod,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectDetailsBloc, ProjectDetailsState>(
      builder: (context, state) {
        if (state is ProjectDetailsInitial || state is ProjectDetailsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProjectDetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ProjectDetailsLoaded ||
            state is ProjectDetailsUpdating) {
          final project = (state is ProjectDetailsLoaded)
              ? state.project
              : (state as ProjectDetailsUpdating).project;
          final endpoints = _filteredEndpoints(project);
          return Column(
            children: [
              _buildHeader(project),
              _buildMethodFilter(),
              Expanded(
                child: endpoints.isEmpty
                    ? _buildEmptyState()
                    : _buildEndpointsList(project, endpoints),
              ),
            ],
          );
        } else {
          return Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildHeader(ProjectModel project) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: Row(
        children: [
          Text(
            'API Endpoints',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${project.endpoints.length}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.primary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _addNewEndpoint,
            icon: const Icon(Icons.add, size: 18),
            label: Text('Add Endpoint', style: GoogleFonts.inter(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodFilter() {
    final methods = ['all', 'get', 'post', 'put', 'delete', 'patch'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: methods.map((method) {
            final isSelected = _selectedMethod == method;
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  method.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedMethod = method;
                  });
                },
                backgroundColor: AppColors.background(context),
                selectedColor: AppColors.primary(context),
                checkmarkColor: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.api,
            size: 64,
            color: AppColors.textSecondary(context).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            _selectedMethod == 'all'
                ? 'No Endpoints'
                : 'No ${_selectedMethod.toUpperCase()} Endpoints',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedMethod == 'all'
                ? 'Create your first API endpoint to define your API structure.'
                : 'No ${_selectedMethod.toUpperCase()} endpoints found. Try a different filter or create a new endpoint.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addNewEndpoint,
            icon: const Icon(Icons.add),
            label: Text('Create Endpoint', style: GoogleFonts.inter()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndpointsList(ProjectModel project, List<Endpoint> endpoints) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: endpoints.length,
      itemBuilder: (context, index) {
        final endpoint = endpoints[index];
        final originalIndex = project.endpoints.indexOf(endpoint);
        return _buildEndpointCard(originalIndex, endpoint);
      },
    );
  }

  Widget _buildEndpointCard(int index, Endpoint endpoint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getMethodColor(
                      endpoint.method,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    endpoint.method.name.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getMethodColor(endpoint.method),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${ProjectProvider.of(context)?.project.basePath}${endpoint.path}',
                        style: GoogleFonts.sourceCodePro(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      if (endpoint.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          endpoint.description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (endpoint.authRequired)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'Auth Required',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (endpoint.pathParams?.isNotEmpty == true) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'Path Params',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                          if (endpoint.queryParams?.isNotEmpty == true) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'Query Params',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Add Stats button before the 3-dot button
                ElevatedButton.icon(
                  onPressed: () {
                    showBlurredBackGroundGeneralDialog(
                      context: context,
                      builder: (dialogContext) => EndpointStatsDialog(
                        endpoint: endpoint,
                        basePath:
                            ProjectProvider.of(context)?.project.basePath ?? '',
                      ),
                    );
                  },
                  icon: const Icon(Icons.show_chart, size: 18),
                  label: Text('Stats', style: GoogleFonts.inter(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface(context),
                    foregroundColor: AppColors.primary(context),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary(context),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 16,
                            color: AppColors.textPrimary(context),
                          ),
                          const SizedBox(width: 8),
                          Text('Edit', style: GoogleFonts.inter()),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 16, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: GoogleFonts.inter(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editEndpoint(index, endpoint);
                    } else if (value == 'delete') {
                      _deleteEndpoint(index);
                    }
                  },
                ),
              ],
            ),
          ),
          _buildEndpointDetails(endpoint),
        ],
      ),
    );
  }

  Widget _buildEndpointDetails(Endpoint endpoint) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: Column(
        children: [
          if (endpoint.request != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.border(context).withValues(alpha: 0.3),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Request',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      endpoint.request!.contentType,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    'Response',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            endpoint.response.statusCode,
                          ).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          '${endpoint.response.statusCode}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: _getStatusColor(
                              endpoint.response.statusCode,
                            ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        endpoint.response.contentType,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(HttpMethod method) {
    switch (method) {
      case HttpMethod.get:
        return Colors.green;
      case HttpMethod.post:
        return Colors.blue;
      case HttpMethod.put:
        return Colors.orange;
      case HttpMethod.delete:
        return Colors.red;
      case HttpMethod.patch:
        return Colors.purple;
    }
  }

  Color _getStatusColor(int status) {
    if (status >= 200 && status < 300) return Colors.green;
    if (status >= 300 && status < 400) return Colors.orange;
    if (status >= 400) return Colors.red;
    return Colors.grey;
  }
}
