import '../../domain/repositories/generic_resources_repository.dart';
import '../datasources/mock_collection_store.dart';
import '../models/models.dart';

class GenericResourcesRepositoryImpl implements GenericResourcesRepository {
  final MockCollectionStore store;

  GenericResourcesRepositoryImpl({required this.store});

  @override
  List<GenericCollection> getAllCollections() {
    return store.collections;
  }

  @override
  List<GenericDocument> getAll(String collectionName) {
    return store.getDocuments(collectionName);
  }

  @override
  void add(String collectionName, GenericDocument document) {
    store.addDocument(collectionName, document);
  }

  @override
  void update(String collectionName, String id, Map<String, dynamic> newData) {
    store.updateDocument(collectionName, id, newData);
  }

  @override
  void delete(String collectionName, String id) {
    store.deleteDocument(collectionName, id);
  }

  @override
  GenericCollection? getCollectionByName(String collectionName) {
    for (final c in store.collections) {
      if (c.collectionName == collectionName) return c;
    }
    return null;
  }

  @override
  void addCollection(GenericCollection collection) {
    store.addCollection(collection);
  }

  @override
  void updateCollection(GenericCollection updatedCollection) {
    store.updateCollection(updatedCollection);
  }

  @override
  void deleteCollection(String collectionName) {
    store.deleteCollection(collectionName);
  }
}
