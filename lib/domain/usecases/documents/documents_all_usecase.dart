import 'package:capyapy_dashboard/domain/usecases/documents/generic_collection_usecases.dart';

class DocumentsAllUseCase {
  final GetAllDocumentsUseCase getAllDocumentsUseCase;
  final AddDocumentUseCase addDocumentUseCase;
  final UpdateDocumentUseCase updateDocumentUseCase;
  final DeleteDocumentUseCase deleteDocumentUseCase;
  final GetAllCollectionsUseCase getAllCollectionsUseCase;
  final GetCollectionByNameUseCase getCollectionByNameUseCase;
  final AddCollectionUseCase addCollectionUseCase;
  final UpdateCollectionUseCase updateCollectionUseCase;
  final DeleteCollectionUseCase deleteCollectionUseCase;

  DocumentsAllUseCase({
    required this.getAllDocumentsUseCase,
    required this.addDocumentUseCase,
    required this.updateDocumentUseCase,
    required this.deleteDocumentUseCase,
    required this.getAllCollectionsUseCase,
    required this.getCollectionByNameUseCase,
    required this.addCollectionUseCase,
    required this.updateCollectionUseCase,
    required this.deleteCollectionUseCase,
  });
}
