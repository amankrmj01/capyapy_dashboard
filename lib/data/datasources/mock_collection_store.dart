import '../models/project/generic_collection.dart';
import '../models/project/generic_document.dart';

/// Stores mock data for multiple collections, each as a list of GenericDocument.
class MockCollectionStore {
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
  List<GenericDocument> getDocuments(String collectionName) {
    return collections
        .firstWhere(
          (c) => c.collectionName == collectionName,
          orElse: () =>
              GenericCollection(collectionName: collectionName, documents: []),
        )
        .documents;
  }

  /// Add a document to a collection.
  void addDocument(String collectionName, GenericDocument document) {
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

  /// Update a document in a collection by id.
  void updateDocument(
    String collectionName,
    String id,
    Map<String, dynamic> newData,
  ) {
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
  void deleteDocument(String collectionName, String id) {
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

  void deleteCollection(String collectionName) {
    collections.removeWhere((c) => c.collectionName == collectionName);
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
