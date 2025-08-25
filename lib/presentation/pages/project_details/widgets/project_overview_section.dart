import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/models.dart';

class ProjectOverviewSection extends StatefulWidget {
  final Project project;
  final Function(Project) onProjectUpdated;

  const ProjectOverviewSection({
    super.key,
    required this.project,
    required this.onProjectUpdated,
  });

  @override
  State<ProjectOverviewSection> createState() => _ProjectOverviewSectionState();
}

class _ProjectOverviewSectionState extends State<ProjectOverviewSection> {
  late TextEditingController _nameController;
  late TextEditingController _basePathController;
  late TextEditingController _descriptionController;
  bool _hasAuth = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.projectName);
    _basePathController = TextEditingController(
      text: widget.project.apiBasePath,
    );
    _descriptionController = TextEditingController();
    _hasAuth = widget.project.hasAuth;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _basePathController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedProject = widget.project.copyWith(
      projectName: _nameController.text,
      apiBasePath: _basePathController.text,
      hasAuth: _hasAuth,
      updatedAt: DateTime.now(),
    );
    widget.onProjectUpdated(updatedProject);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(),
          const SizedBox(height: 32),
          _buildProjectBasics(),
          const SizedBox(height: 32),
          _buildProjectStats(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            'Data Models',
            widget.project.dataModels.length.toString(),
            Icons.table_chart,
            AppColors.primary(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Endpoints',
            widget.project.endpoints.length.toString(),
            Icons.api,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildInfoCard(
            'Auth Required',
            widget.project.hasAuth ? 'Yes' : 'No',
            Icons.security,
            widget.project.hasAuth ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectBasics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Configuration',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            'Project Name',
            _nameController,
            'Enter project name',
          ),
          const SizedBox(height: 16),
          _buildTextField('Base Path', _basePathController, 'e.g., /api/v1'),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _hasAuth,
                onChanged: (value) {
                  setState(() {
                    _hasAuth = value ?? false;
                  });
                },
                activeColor: AppColors.primary(context),
              ),
              Text(
                'Enable Authentication',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Reset to original values
                  setState(() {
                    _nameController.text = widget.project.projectName;
                    _basePathController.text = widget.project.apiBasePath;
                    _hasAuth = widget.project.hasAuth;
                  });
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: Colors.white,
                ),
                child: Text('Save Changes', style: GoogleFonts.inter()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Metadata',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary(context),
            ),
          ),
          const SizedBox(height: 16),
          _buildMetadataRow('Created By', widget.project.metadata.createdBy),
          _buildMetadataRow(
            'Created At',
            '${widget.project.metadata.createdAt.day}/${widget.project.metadata.createdAt.month}/${widget.project.metadata.createdAt.year}',
          ),
          _buildMetadataRow('Project ID', widget.project.id),
          if (widget.project.metadata.tags.isNotEmpty) _buildTagsRow(),
        ],
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              'Tags',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.metadata.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary(
                          context,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.primary(context),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
