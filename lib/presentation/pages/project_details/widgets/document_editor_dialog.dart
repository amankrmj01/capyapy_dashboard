import '../../../../data/models/models.dart';
import '../../../../core/utils/export_utils.dart';
import '../../../bloc/collection/collection_bloc.dart';

class DocumentEditorDialog extends StatefulWidget {
  final String collectionName;
  final List<MongoDbField>? fields;
  final GenericDocument? document;
  final Function(Map<String, dynamic>) onSave;

  const DocumentEditorDialog({
    super.key,
    required this.collectionName,
    this.fields,
    this.document,
    required this.onSave,
  });

  @override
  State<DocumentEditorDialog> createState() => _DocumentEditorDialogState();
}

class _DocumentEditorDialogState extends State<DocumentEditorDialog> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _formData = {};
  final Map<String, bool> _booleanValues = {};
  final Map<String, DateTime?> _dateValues = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.fields != null && widget.fields!.isNotEmpty) {
      // Initialize with field definitions from the data model
      for (final field in widget.fields!) {
        if (field.name != '_id') {
          _initializeFieldData(field);
        }
      }
    } else if (widget.document != null) {
      // Fallback: Initialize with existing document data
      for (final entry in widget.document!.data.entries) {
        if (entry.key != '_id') {
          _controllers[entry.key] = TextEditingController(
            text: _formatValueForEditing(entry.value),
          );
          _formData[entry.key] = entry.value;
        }
      }
    } else {
      // Default fields for new document when no schema is available
      _controllers['name'] = TextEditingController();
      _controllers['value'] = TextEditingController();
    }
  }

  void _initializeFieldData(MongoDbField field) {
    // Set initial values if editing existing document
    dynamic initialValue;
    if (widget.document != null) {
      initialValue = widget.document!.data[field.name];
    }

    switch (field.type) {
      case MongoDbFieldType.boolean:
        _booleanValues[field.name] = initialValue is bool
            ? initialValue
            : (field.defaultValue is bool ? field.defaultValue : false);
        _formData[field.name] = _booleanValues[field.name];
        break;

      case MongoDbFieldType.date:
        if (initialValue is DateTime) {
          _dateValues[field.name] = initialValue;
        } else if (initialValue is String) {
          _dateValues[field.name] = DateTime.tryParse(initialValue);
        } else if (field.defaultValue != null) {
          _dateValues[field.name] = field.defaultValue is DateTime
              ? field.defaultValue
              : DateTime.now();
        }
        _formData[field.name] = _dateValues[field.name];
        break;

      default:
        // For all other types, use text controller
        String textValue = '';
        if (initialValue != null) {
          textValue = _formatValueForEditing(initialValue);
        } else if (field.defaultValue != null) {
          textValue = _formatValueForEditing(field.defaultValue);
        }

        _controllers[field.name] = TextEditingController(text: textValue);
        _formData[field.name] = _parseValue(textValue, field.type);
    }
  }

  String _formatValueForEditing(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    if (value is DateTime) return value.toIso8601String();
    if (value is List) return value.join(', ');
    return value.toString();
  }

  dynamic _parseValue(String text, MongoDbFieldType type) {
    if (text.isEmpty) return null;

    switch (type) {
      case MongoDbFieldType.string:
        return text;
      case MongoDbFieldType.number:
      case MongoDbFieldType.decimal:
        return double.tryParse(text) ?? int.tryParse(text) ?? text;
      case MongoDbFieldType.boolean:
        return text.toLowerCase() == 'true';
      case MongoDbFieldType.date:
        return DateTime.tryParse(text) ?? text;
      case MongoDbFieldType.array:
        return text.split(',').map((e) => e.trim()).toList();
      case MongoDbFieldType.objectId:
        return text; // Keep as string for ObjectId
      default:
        // Try to parse as number if possible, otherwise string
        return double.tryParse(text) ?? int.tryParse(text) ?? text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CollectionBloc>.value(
      value: context.read<CollectionBloc>(),
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Flexible(child: _buildForm()),
            const SizedBox(height: 20),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          widget.document == null ? Icons.add : Icons.edit,
          color: AppColors.primary(context),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.document == null ? 'Add Document' : 'Edit Document',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                'Collection: ${widget.collectionName}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildForm() {
    if (widget.fields == null || widget.fields!.isEmpty) {
      return _buildFallbackForm();
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: widget.fields!
              .where((field) => field.name != '_id')
              .map(
                (field) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildFieldWidget(field),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFallbackForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: _controllers.entries.map((entry) {
            final fieldName = entry.key;
            final controller = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildBasicTextField(fieldName, controller),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFieldWidget(MongoDbField field) {
    switch (field.type) {
      case MongoDbFieldType.boolean:
        return _buildBooleanField(field);
      case MongoDbFieldType.date:
        return _buildDateField(field);
      case MongoDbFieldType.number:
      case MongoDbFieldType.decimal:
        return _buildNumberField(field);
      case MongoDbFieldType.array:
        return _buildArrayField(field);
      default:
        return _buildTextField(field);
    }
  }

  Widget _buildTextField(MongoDbField field) {
    final controller = _controllers[field.name]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(field),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines:
              field.type == MongoDbFieldType.string &&
                  field.validationRules != null &&
                  field.validationRules!['multiline'] == true
              ? 3
              : 1,
          decoration: InputDecoration(
            hintText: _getFieldHint(field),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            _formData[field.name] = _parseValue(value, field.type);
          },
        ),
      ],
    );
  }

  Widget _buildNumberField(MongoDbField field) {
    final controller = _controllers[field.name]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(field),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter ${field.type.displayName.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            _formData[field.name] = _parseValue(value, field.type);
          },
        ),
      ],
    );
  }

  Widget _buildBooleanField(MongoDbField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(field),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _booleanValues[field.name] ?? false,
                onChanged: (value) {
                  setState(() {
                    _booleanValues[field.name] = value ?? false;
                    _formData[field.name] = value ?? false;
                  });
                },
                activeColor: AppColors.primary(context),
              ),
              Text(
                _booleanValues[field.name] == true ? 'True' : 'False',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(MongoDbField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(field),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(field),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border(context)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary(context),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _dateValues[field.name] != null
                        ? _dateValues[field.name]!.toIso8601String().split(
                            'T',
                          )[0]
                        : 'Select date',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: _dateValues[field.name] != null
                          ? AppColors.textPrimary(context)
                          : AppColors.textSecondary(context),
                    ),
                  ),
                ),
                if (_dateValues[field.name] != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      setState(() {
                        _dateValues[field.name] = null;
                        _formData[field.name] = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrayField(MongoDbField field) {
    final controller = _controllers[field.name]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(field),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Enter comma-separated values',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: (value) => _validateField(field, value),
          onChanged: (value) {
            _formData[field.name] = _parseValue(value, field.type);
          },
        ),
      ],
    );
  }

  Widget _buildBasicTextField(
    String fieldName,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter ${fieldName.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary(context)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            _formData[fieldName] = value;
          },
        ),
      ],
    );
  }

  Widget _buildFieldLabel(MongoDbField field) {
    return Row(
      children: [
        Text(
          field.name,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        if (field.required) ...[
          const SizedBox(width: 4),
          Text('*', style: GoogleFonts.inter(color: Colors.red)),
        ],
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _getFieldTypeColor(field.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            field.type.displayName,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: _getFieldTypeColor(field.type),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (field.unique) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              'UNIQUE',
              style: GoogleFonts.inter(
                fontSize: 8,
                color: Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getFieldHint(MongoDbField field) {
    switch (field.type) {
      case MongoDbFieldType.string:
        return 'Enter text';
      case MongoDbFieldType.number:
      case MongoDbFieldType.decimal:
        return 'Enter number';
      case MongoDbFieldType.boolean:
        return 'Select true or false';
      case MongoDbFieldType.date:
        return 'Select date';
      case MongoDbFieldType.array:
        return 'Enter comma-separated values';
      case MongoDbFieldType.objectId:
        return 'Enter object ID';
      default:
        return 'Enter value';
    }
  }

  String? _validateField(MongoDbField field, String? value) {
    if (field.required && (value == null || value.isEmpty)) {
      return '${field.name} is required';
    }

    // Additional validations based on validation rules
    if (field.validationRules != null && value != null && value.isNotEmpty) {
      final rules = field.validationRules!;

      if (rules['maxLength'] != null) {
        final maxLength = rules['maxLength'] as int;
        if (value.length > maxLength) {
          return '${field.name} cannot exceed $maxLength characters';
        }
      }

      if (rules['minLength'] != null) {
        final minLength = rules['minLength'] as int;
        if (value.length < minLength) {
          return '${field.name} must be at least $minLength characters';
        }
      }

      if (rules['pattern'] != null) {
        final pattern = RegExp(rules['pattern'] as String);
        if (!pattern.hasMatch(value)) {
          return '${field.name} format is invalid';
        }
      }
    }

    return null;
  }

  Color _getFieldTypeColor(MongoDbFieldType type) {
    switch (type) {
      case MongoDbFieldType.string:
        return Colors.blue;
      case MongoDbFieldType.number:
      case MongoDbFieldType.decimal:
        return Colors.green;
      case MongoDbFieldType.boolean:
        return Colors.orange;
      case MongoDbFieldType.date:
        return Colors.purple;
      case MongoDbFieldType.objectId:
        return Colors.red;
      case MongoDbFieldType.array:
        return Colors.teal;
      case MongoDbFieldType.object:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate(MongoDbField field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateValues[field.name] ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateValues[field.name] = picked;
        _formData[field.name] = picked;
      });
    }
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(color: AppColors.textSecondary(context)),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _saveDocument,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Save',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _saveDocument() {
    if (_formKey.currentState!.validate()) {
      // Collect all form data
      final data = <String, dynamic>{};

      if (widget.fields != null && widget.fields!.isNotEmpty) {
        // Use field definitions to properly format data
        for (final field in widget.fields!) {
          if (field.name != '_id') {
            if (_formData.containsKey(field.name)) {
              data[field.name] = _formData[field.name];
            }
          }
        }
      } else {
        // Fallback: collect from text controllers
        for (final entry in _controllers.entries) {
          data[entry.key] = entry.value.text;
        }
      }

      widget.onSave(data);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
