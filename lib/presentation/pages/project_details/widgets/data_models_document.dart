import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../data/models/models.dart';
import '../../../bloc/collection/collection_bloc.dart';
import '../../../bloc/collection/collection_event.dart';
import '../../../bloc/collection/collection_state.dart';
import 'document_editor_dialog.dart';

class DataModelsDocument extends StatefulWidget {
  final String collectionName;
  final List<MongoDbField>? fields;

  const DataModelsDocument({
    super.key,
    required this.collectionName,
    this.fields,
  });

  @override
  State<DataModelsDocument> createState() => _DataModelsDocumentState();
}

class _DataModelsDocumentState extends State<DataModelsDocument> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionBloc>().add(LoadDocuments(widget.collectionName));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CollectionBloc, CollectionState>(
                builder: (context, state) {
                  if (state is CollectionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CollectionError) {
                    return _buildErrorState(context, state.message);
                  } else if (state is CollectionLoaded ||
                      state is CollectionUpdating) {
                    final documents = (state is CollectionLoaded)
                        ? state.documents
                        : (state as CollectionUpdating).documents;

                    if (documents.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return _buildDocumentsList(context, documents);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.storage,
            color: AppColors.primary(context),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collection Data',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                widget.collectionName,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddDocumentDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: Text('Add Document', style: GoogleFonts.inter(fontSize: 14)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary(context),
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary(context).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Documents Found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This collection is empty. Add your first document to get started.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context).withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddDocumentDialog(context),
            icon: const Icon(Icons.add),
            label: Text('Add First Document', style: GoogleFonts.inter()),
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Documents',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CollectionBloc>().add(
                LoadDocuments(widget.collectionName),
              );
            },
            icon: const Icon(Icons.refresh),
            label: Text('Retry', style: GoogleFonts.inter()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary(context),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsList(
    BuildContext context,
    List<GenericDocument> documents,
  ) {
    return Column(
      children: [
        // Documents count and controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Row(
            children: [
              Text(
                '${documents.length} Documents',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary(context),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  context.read<CollectionBloc>().add(
                    LoadDocuments(widget.collectionName),
                  );
                },
                icon: const Icon(Icons.refresh, size: 18),
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Documents list
        Expanded(
          child: ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return _buildDocumentCard(context, document, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    GenericDocument document,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ID: ${document.id}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary(context),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showEditDocumentDialog(context, document),
                icon: const Icon(Icons.edit, size: 18),
                tooltip: 'Edit',
              ),
              IconButton(
                onPressed: () => _showDeleteConfirmation(context, document),
                icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                tooltip: 'Delete',
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Document fields
          ...document.data.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatValue(entry.value),
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) return value;
    if (value is num) return value.toString();
    if (value is bool) return value.toString();
    if (value is DateTime) return value.toIso8601String();
    if (value is List) return '${value.length} items';
    if (value is Map) return '${value.length} fields';
    return value.toString();
  }

  void _showAddDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CollectionBloc>(),
        child: DocumentEditorDialog(
          collectionName: widget.collectionName,
          fields: widget.fields,
          onSave: (data) {
            final document = GenericDocument(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              data: data,
            );
            context.read<CollectionBloc>().add(
              AddDocument(widget.collectionName, document),
            );
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _showEditDocumentDialog(BuildContext context, GenericDocument document) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<CollectionBloc>(),
        child: DocumentEditorDialog(
          collectionName: widget.collectionName,
          fields: widget.fields,
          document: document,
          onSave: (data) {
            context.read<CollectionBloc>().add(
              UpdateDocument(widget.collectionName, document.id, data),
            );
            Navigator.of(dialogContext).pop();
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GenericDocument document) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'Delete Document',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete document "${document.id}"? This action cannot be undone.',
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
              context.read<CollectionBloc>().add(
                DeleteDocument(widget.collectionName, document.id),
              );
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
}
