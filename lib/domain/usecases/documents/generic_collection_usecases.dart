import '../../../data/models/models.dart';
import '../../repositories/document_resources_repository.dart';

class GetAllDocumentsUseCase {
  final DocumentResourcesRepository repository;

  GetAllDocumentsUseCase(this.repository);

  Future<List<GenericDocument>> call(String collectionName) {
    return repository.getAllDocuments(collectionName);
  }
}

class AddDocumentUseCase {
  final DocumentResourcesRepository repository;

  AddDocumentUseCase(this.repository);

  void call(String collectionName, GenericDocument document) {
    repository.addDocument(collectionName, document);
  }
}

class UpdateDocumentUseCase {
  final DocumentResourcesRepository repository;

  UpdateDocumentUseCase(this.repository);

  void call(String collectionName, String id, Map<String, dynamic> newData) {
    repository.updateDocument(collectionName, id, newData);
  }
}

class DeleteDocumentUseCase {
  final DocumentResourcesRepository repository;

  DeleteDocumentUseCase(this.repository);

  void call(String collectionName, String id) {
    repository.deleteDocument(collectionName, id);
  }
}

class GetAllCollectionsUseCase {
  final DocumentResourcesRepository repository;

  GetAllCollectionsUseCase(this.repository);

  Future<List<GenericCollection>> call() {
    return repository.getAllCollections();
  }
}

class GetCollectionByNameUseCase {
  final DocumentResourcesRepository repository;

  GetCollectionByNameUseCase(this.repository);

  Future<GenericCollection?> call(String collectionName) async {
    final collections = await repository.getAllCollections();
    return collections.firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () => GenericCollection(collectionName: '404', documents: []),
    );
  }
}

class AddCollectionUseCase {
  final DocumentResourcesRepository repository;

  AddCollectionUseCase(this.repository);

  void call(GenericCollection collection) {
    repository.addCollection(collection);
  }
}

class UpdateCollectionUseCase {
  final DocumentResourcesRepository repository;

  UpdateCollectionUseCase(this.repository);

  void call(GenericCollection updatedCollection) {
    repository.updateCollection(updatedCollection);
  }
}

class DeleteCollectionUseCase {
  final DocumentResourcesRepository repository;

  DeleteCollectionUseCase(this.repository);

  void call(String collectionName) {
    repository.deleteCollection(collectionName);
  }
}
