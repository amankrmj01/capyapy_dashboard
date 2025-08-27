import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/generic_collection_usecases.dart';
import 'generic_collection_event.dart';
import 'generic_collection_state.dart';

class GenericCollectionBloc
    extends Bloc<GenericCollectionEvent, GenericCollectionState> {
  final GetAllDocumentsUseCase getAllDocuments;
  final AddDocumentUseCase addDocument;
  final UpdateDocumentUseCase updateDocument;
  final DeleteDocumentUseCase deleteDocument;

  GenericCollectionBloc({
    required this.getAllDocuments,
    required this.addDocument,
    required this.updateDocument,
    required this.deleteDocument,
  }) : super(CollectionInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<AddDocument>(_onAddDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  void _onLoadDocuments(
    LoadDocuments event,
    Emitter<GenericCollectionState> emit,
  ) {
    emit(CollectionLoading());
    try {
      final docs = getAllDocuments.call(event.collectionName);
      emit(
        CollectionLoaded(
          event.collectionName,
          List<GenericDocument>.from(docs),
        ),
      );
    } catch (e) {
      emit(CollectionError('Failed to load documents: ${e.toString()}'));
    }
  }

  void _onAddDocument(
    AddDocument event,
    Emitter<GenericCollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        addDocument.call(event.collectionName, event.document);
        final docs = getAllDocuments.call(event.collectionName);
        emit(
          CollectionLoaded(
            event.collectionName,
            List<GenericDocument>.from(docs),
          ),
        );
      } catch (e) {
        emit(CollectionError('Failed to add document: ${e.toString()}'));
      }
    }
  }

  void _onUpdateDocument(
    UpdateDocument event,
    Emitter<GenericCollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        updateDocument.call(event.collectionName, event.id, event.newData);
        final docs = getAllDocuments.call(event.collectionName);
        emit(
          CollectionLoaded(
            event.collectionName,
            List<GenericDocument>.from(docs),
          ),
        );
      } catch (e) {
        emit(CollectionError('Failed to update document: ${e.toString()}'));
      }
    }
  }

  void _onDeleteDocument(
    DeleteDocument event,
    Emitter<GenericCollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        deleteDocument.call(event.collectionName, event.id);
        final docs = getAllDocuments.call(event.collectionName);
        emit(
          CollectionLoaded(
            event.collectionName,
            List<GenericDocument>.from(docs),
          ),
        );
      } catch (e) {
        emit(CollectionError('Failed to delete document: ${e.toString()}'));
      }
    }
  }
}
