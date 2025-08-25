import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/project_model.dart';

class DataModelEditorDialog extends StatefulWidget {
  final DataModel? dataModel;
  final Function(DataModel) onSave;

  const DataModelEditorDialog({
    super.key,
    this.dataModel,
    required this.onSave,
  });

  @override
  State<DataModelEditorDialog> createState() => _DataModelEditorDialogState();
}

class _DataModelEditorDialogState extends State<DataModelEditorDialog> {
  late TextEditingController _modelNameController;
  late TextEditingController _collectionNameController;
  late TextEditingController _descriptionController;
  List<ModelField> _fields = [];

  @override
  void initState() {
    super.initState();
    _modelNameController = TextEditingController(
      text: widget.dataModel?.modelName ?? '',
    );
    _collectionNameController = TextEditingController(
      text: widget.dataModel?.collectionName ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.dataModel?.description ?? '',
    );
    _fields = widget.dataModel?.fields.map((field) => field).toList() ?? [];
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    _collectionNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addField() {
    setState(() {
      _fields.add(const ModelField(name: '', type: FieldType.string));
    });
  }

  void _removeField(int index) {
    setState(() {
      _fields.removeAt(index);
    });
  }

  void _updateField(int index, ModelField field) {
    setState(() {
      _fields[index] = field;
    });
  }

  void _save() {
    if (_modelNameController.text.isEmpty ||
        _collectionNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill in all required fields',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final dataModel = ProjectDataModel(
      id:
          widget.dataModel?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      modelName: _modelNameController.text,
      collectionName: _collectionNameController.text,
      description: _descriptionController.text.isEmpty
          ? 'No description provided'
          : _descriptionController.text,
      fields: _fields,
      createdAt: widget.dataModel?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(dataModel);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildBasicInfo(),
            const SizedBox(height: 24),
            _buildFieldsSection(),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.table_chart, color: AppColors.primary(context), size: 24),
        const SizedBox(width: 12),
        Text(
          widget.dataModel == null ? 'Create Data Model' : 'Edit Data Model',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: AppColors.textSecondary(context)),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                'Model Name',
                _modelNameController,
                'e.g., User',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                'Collection Name',
                _collectionNameController,
                'e.g., users',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Optional',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
          ),
          style: GoogleFonts.inter(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildFieldsSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Fields',
                style: GoogleFonts.inter(
                  fontSize: 16,
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
                  '${_fields.length}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.primary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addField,
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  'Add Field',
                  style: GoogleFonts.inter(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(context),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _fields.isEmpty
                ? _buildEmptyFieldsState()
                : _buildFieldsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFieldsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 48,
            color: AppColors.textSecondary(context).withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Fields Added',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add fields to define the structure of your data model.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context).withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsList() {
    return ListView.builder(
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        return _buildFieldEditor(index, _fields[index]);
      },
    );
  }

  Widget _buildFieldEditor(int index, ModelField field) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  initialValue: field.name,
                  decoration: InputDecoration(
                    labelText: 'Field Name',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: GoogleFonts.inter(fontSize: 14),
                  onChanged: (value) {
                    _updateField(
                      index,
                      ModelField(
                        name: value,
                        type: field.type,
                        required: field.required,
                        unique: field.unique,
                        defaultValue: field.defaultValue,
                        enumValues: field.enumValues,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<FieldType>(
                  initialValue: field.type,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: GoogleFonts.inter(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: FieldType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(
                        type.displayName,
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateField(
                        index,
                        ModelField(
                          name: field.name,
                          type: value,
                          required: field.required,
                          unique: field.unique,
                          defaultValue: field.defaultValue,
                          enumValues: field.enumValues,
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _removeField(index),
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: Text(
                    'Required',
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                  value: field.required,
                  onChanged: (value) {
                    _updateField(
                      index,
                      ModelField(
                        name: field.name,
                        type: field.type,
                        required: value ?? false,
                        unique: field.unique,
                        defaultValue: field.defaultValue,
                        enumValues: field.enumValues,
                      ),
                    );
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary(context),
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: Text('Unique', style: GoogleFonts.inter(fontSize: 12)),
                  value: field.unique,
                  onChanged: (value) {
                    _updateField(
                      index,
                      ModelField(
                        name: field.name,
                        type: field.type,
                        required: field.required,
                        unique: value ?? false,
                        defaultValue: field.defaultValue,
                        enumValues: field.enumValues,
                      ),
                    );
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary(context),
                ),
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
          style: GoogleFonts.inter(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(color: AppColors.textSecondary(context)),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            widget.dataModel == null ? 'Create Model' : 'Save Changes',
            style: GoogleFonts.inter(),
          ),
        ),
      ],
    );
  }
}
