import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../bloc/project_creation/project_creation_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../bloc/project_creation/project_creation_state.dart';

class BasicInfoStep extends StatefulWidget {
  final ProjectCreationInitial state;

  const BasicInfoStep({super.key, required this.state});

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  late TextEditingController _projectNameController;
  late TextEditingController _basePathController;

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController(
      text: widget.state.formData['name'] ?? '',
    );
    _basePathController = TextEditingController(
      text: widget.state.formData['basePath'] ?? '',
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _basePathController.dispose();
    super.dispose();
  }

  void _updateProjectInfo() {
    context.read<ProjectCreationBloc>().add(
      ProjectCreationFieldUpdated('name', _projectNameController.text),
    );
    context.read<ProjectCreationBloc>().add(
      ProjectCreationFieldUpdated('basePath', _basePathController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.runtimeType != ProjectCreationInitial) {
      return Container();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(context),
          const SizedBox(height: 32),
          _buildFormSection(context),
          const SizedBox(height: 32),
          _buildExamplesSection(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text('🚀', style: TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Project Builder',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create powerful mock API services in minutes. Start by giving your project a name and setting the base path for your endpoints.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary(context),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Details',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 16),

        // Project Name Field
        _buildInputField(
          context,
          label: 'Project Name',
          hint: 'e.g., UserServiceMock, BlogAPI, E-commerce Backend',
          controller: _projectNameController,
          icon: '📝',
          onChanged: _updateProjectInfo,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Project name is required';
            }
            return null;
          },
        ),

        const SizedBox(height: 24),

        // Base Path Field
        _buildInputField(
          context,
          label: 'Base Path',
          hint: 'e.g., /api/v1, /v2/services, /mock',
          controller: _basePathController,
          icon: '🔗',
          onChanged: _updateProjectInfo,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Base path is required';
            }
            if (!value!.startsWith('/')) {
              return 'Base path must start with /';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // Info Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'The base path will be prepended to all your API endpoints. For example, if your base path is "/api/v1" and you create a "/users" endpoint, the full path will be "/api/v1/users".',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required String icon,
    required VoidCallback onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: (_) => onChanged(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: AppColors.textSecondary(context),
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.surface(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildExamplesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Examples',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildExampleChip(context, '🛍️', 'E-commerce API', '/api/v1'),
            _buildExampleChip(context, '👥', 'User Management', '/users/v2'),
            _buildExampleChip(context, '📝', 'Blog Service', '/blog/api'),
            _buildExampleChip(context, '🏦', 'Banking API', '/banking/v1'),
            _buildExampleChip(context, '📚', 'Library System', '/library'),
            _buildExampleChip(context, '🎬', 'Media Service', '/media/api'),
          ],
        ),
      ],
    );
  }

  Widget _buildExampleChip(
    BuildContext context,
    String icon,
    String name,
    String path,
  ) {
    return InkWell(
      onTap: () {
        _projectNameController.text = name;
        _basePathController.text = path;
        _updateProjectInfo();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              path,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
