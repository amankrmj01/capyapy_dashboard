import '../models/project/generic_document.dart';

abstract class CollectionDataSource {
  Future<List<GenericDocument>> getDocuments(String collectionName);

  Future<void> addDocument(String collectionName, GenericDocument document);

  Future<void> updateDocument(
    String collectionName,
    String id,
    Map<String, dynamic> newData,
  );

  Future<void> deleteDocument(String collectionName, String id);

  Future<List<String>> getAllCollections();

  Future<void> createCollection(String collectionName);

  Future<void> deleteCollection(String collectionName);

  Future<bool> collectionExists(String collectionName);

  Future<int> getDocumentCount(String collectionName);

  Future<GenericDocument?> getDocumentById(String collectionName, String id);

  Future<bool> isFieldValueUnique(
    String collectionName,
    String fieldName,
    dynamic value, {
    String? excludeId,
  });
}
