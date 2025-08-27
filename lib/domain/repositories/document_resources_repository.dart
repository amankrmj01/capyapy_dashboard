import '../../data/models/project/generic_collection.dart';
import '../../data/models/project/generic_document.dart';

abstract class DocumentResourcesRepository {
  Future<List<GenericCollection>> getAllCollections();

  Future<List<GenericDocument>> getAllDocuments(String collectionName);

  Future<void> addDocument(String collectionName, GenericDocument document);

  Future<void> updateDocument(
    String collectionName,
    String id,
    Map<String, dynamic> newData,
  );

  Future<void> deleteDocument(String collectionName, String id);

  Future<GenericCollection?> getCollectionByName(String collectionName);

  Future<void> addCollection(GenericCollection collection);

  Future<void> updateCollection(GenericCollection updatedCollection);

  Future<void> deleteCollection(String collectionName);
}
