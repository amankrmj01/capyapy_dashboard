import '../models/project/generic_collection.dart';
import '../models/project/generic_document.dart';
import 'collection_data_source.dart';

/// Stores mock data for multiple collections, each as a list of GenericDocument.
class MockCollectionStore implements CollectionDataSource {
  final List<GenericCollection> collections = [
    GenericCollection(
      collectionName: 'posts',
      documents: [
        GenericDocument(
          id: 'post_1',
          data: {
            'title': 'First Post',
            'content': 'This is the first blog post.',
            'published': true,
            'publishedAt': DateTime(2025, 8, 1),
          },
        ),
        GenericDocument(
          id: 'post_2',
          data: {
            'title': 'Second Post',
            'content': 'Another post for the blog.',
            'published': false,
            'publishedAt': null,
          },
        ),
      ],
    ),
    GenericCollection(
      collectionName: 'products',
      documents: [
        GenericDocument(
          id: 'product_1',
          data: {'name': 'Laptop', 'price': 999.99, 'inStock': true},
        ),
        GenericDocument(
          id: 'product_2',
          data: {'name': 'Mouse', 'price': 25.5, 'inStock': false},
        ),
      ],
    ),
  ];

  /// Get all documents for a collection.
  @override
  Future<List<GenericDocument>> getDocuments(String collectionName) async {
    return collections
        .firstWhere(
          (c) => c.collectionName == collectionName,
          orElse: () =>
              GenericCollection(collectionName: collectionName, documents: []),
        )
        .documents;
  }

  @override
  Future<void> addDocument(
    String collectionName,
    GenericDocument document,
  ) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    if (!collections.contains(collection)) {
      collections.add(
        GenericCollection(
          collectionName: collectionName,
          documents: [document],
        ),
      );
    } else {
      collection.documents.add(document);
    }
  }

  @override
  Future<void> updateDocument(
    String collectionName,
    String id,
    Map<String, dynamic> newData,
  ) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    final index = collection.documents.indexWhere((doc) => doc.id == id);
    if (index != -1) {
      collection.documents[index] = GenericDocument(id: id, data: newData);
    }
  }

  /// Delete a document from a collection by id.
  @override
  Future<void> deleteDocument(String collectionName, String id) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    collection.documents.removeWhere((doc) => doc.id == id);
  }

  void addCollection(GenericCollection collection) {
    collections.add(collection);
  }

  void updateCollection(GenericCollection updatedCollection) {
    final index = collections.indexWhere(
      (c) => c.collectionName == updatedCollection.collectionName,
    );
    if (index != -1) {
      collections[index] = updatedCollection;
    }
  }

  @override
  Future<void> deleteCollection(String collectionName) async {
    collections.removeWhere((c) => c.collectionName == collectionName);
  }

  @override
  Future<bool> collectionExists(String collectionName) async {
    return collections.any((c) => c.collectionName == collectionName);
  }

  @override
  Future<void> createCollection(String collectionName) async {
    if (!collections.any((c) => c.collectionName == collectionName)) {
      collections.add(
        GenericCollection(collectionName: collectionName, documents: []),
      );
    }
  }

  @override
  Future<List<String>> getAllCollections() async {
    return collections.map((c) => c.collectionName).toList();
  }

  @override
  Future<GenericDocument?> getDocumentById(
    String collectionName,
    String id,
  ) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    return collection.documents.firstWhere(
      (doc) => doc.id == id,
      orElse: () => GenericDocument(id: '404', data: {}),
    );
  }

  @override
  Future<int> getDocumentCount(String collectionName) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    return collection.documents.length;
  }

  @override
  Future<bool> isFieldValueUnique(
    String collectionName,
    String fieldName,
    value, {
    String? excludeId,
  }) async {
    final collection = collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () =>
          GenericCollection(collectionName: collectionName, documents: []),
    );
    for (final doc in collection.documents) {
      if (excludeId != null && doc.id == excludeId) continue;
      if (doc.data[fieldName] == value) return false;
    }
    return true;
  }

  // void addFieldToCollection(String collectionName, MongoDbField newField) {
  //   final schema = schemas.firstWhere(
  //     (s) => s.collectionName == collectionName,
  //     orElse: () => throw Exception('Schema not found'),
  //   );
  //   // Add field to schema
  //   schema.fields.add(newField);
  //   // Add field to all documents in the collection
  //   final collection = collections.firstWhere(
  //     (c) => c.collectionName == collectionName,
  //     orElse: () => throw Exception('Collection not found'),
  //   );
  //   for (var doc in collection.documents) {
  //     doc.data[newField.name] = newField.defaultValue;
  //   }
  // }
  //
  // void removeFieldFromCollection(String collectionName, String fieldName) {
  //   final schema = schemas.firstWhere(
  //     (s) => s.collectionName == collectionName,
  //     orElse: () => throw Exception('Schema not found'),
  //   );
  //   // Remove field from schema
  //   schema.fields.removeWhere((f) => f.name == fieldName);
  //   // Remove field from all documents in the collection
  //   final collection = collections.firstWhere(
  //     (c) => c.collectionName == collectionName,
  //     orElse: () => throw Exception('Collection not found'),
  //   );
  //   for (var doc in collection.documents) {
  //     doc.data.remove(fieldName);
  //   }
  // }
}
