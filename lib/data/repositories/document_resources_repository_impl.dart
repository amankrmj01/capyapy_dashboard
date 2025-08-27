import '../../domain/repositories/document_resources_repository.dart';
import '../datasource/mock_collection_store.dart';
import '../models/models.dart';

class DocumentResourcesRepositoryImpl implements DocumentResourcesRepository {
  final MockCollectionStore store;

  DocumentResourcesRepositoryImpl({required this.store});

  @override
  Future<List<GenericCollection>> getAllCollections() async {
    return store.collections;
  }

  @override
  Future<List<GenericDocument>> getAllDocuments(String collectionName) async {
    return store.getDocuments(collectionName);
  }

  @override
  Future<void> addDocument(
    String collectionName,
    GenericDocument document,
  ) async {
    store.addDocument(collectionName, document);
  }

  @override
  Future<void> updateDocument(
    String collectionName,
    String id,
    Map<String, dynamic> newData,
  ) async {
    store.updateDocument(collectionName, id, newData);
  }

  @override
  Future<void> deleteDocument(String collectionName, String id) async {
    store.deleteDocument(collectionName, id);
  }

  @override
  Future<GenericCollection?> getCollectionByName(String collectionName) async {
    for (final c in store.collections) {
      if (c.collectionName == collectionName) return c;
    }
    return null;
  }

  @override
  Future<void> addCollection(GenericCollection collection) async {
    store.addCollection(collection);
  }

  @override
  Future<void> updateCollection(GenericCollection updatedCollection) async {
    store.updateCollection(updatedCollection);
  }

  @override
  Future<void> deleteCollection(String collectionName) async {
    store.deleteCollection(collectionName);
  }
}
