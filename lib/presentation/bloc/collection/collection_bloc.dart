import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/project/generic_document.dart';
import '../../../domain/repositories/document_resources_repository.dart';
import 'collection_event.dart';
import 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final DocumentResourcesRepository repository;

  CollectionBloc({required this.repository}) : super(CollectionInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<AddDocument>(_onAddDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<CollectionState> emit,
  ) async {
    emit(CollectionLoading());
    try {
      final docs = await repository.getAllDocuments(event.collectionName);
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

  void _onAddDocument(AddDocument event, Emitter<CollectionState> emit) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        repository.addDocument(event.collectionName, event.document);
        final docs = await repository.getAllDocuments.call(
          event.collectionName,
        );
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
    Emitter<CollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        repository.updateDocument(
          event.collectionName,
          event.id,
          event.newData,
        );
        final docs = await repository.getAllDocuments.call(
          event.collectionName,
        );
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
    Emitter<CollectionState> emit,
  ) async {
    if (state is CollectionLoaded) {
      final currentState = state as CollectionLoaded;
      emit(
        CollectionUpdating(currentState.collectionName, currentState.documents),
      );

      try {
        repository.deleteDocument(event.collectionName, event.id);
        final docs = await repository.getAllDocuments.call(
          event.collectionName,
        );
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
