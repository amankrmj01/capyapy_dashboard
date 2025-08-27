import '../../data/models/models.dart';
import '../repositories/generic_resources_repository.dart';

class GetAllDocumentsUseCase {
  final GenericResourcesRepository repository;

  GetAllDocumentsUseCase(this.repository);

  List<GenericDocument> call(String collectionName) {
    return repository.getAll(collectionName);
  }
}

class AddDocumentUseCase {
  final GenericResourcesRepository repository;

  AddDocumentUseCase(this.repository);

  void call(String collectionName, GenericDocument document) {
    repository.add(collectionName, document);
  }
}

class UpdateDocumentUseCase {
  final GenericResourcesRepository repository;

  UpdateDocumentUseCase(this.repository);

  void call(String collectionName, String id, Map<String, dynamic> newData) {
    repository.update(collectionName, id, newData);
  }
}

class DeleteDocumentUseCase {
  final GenericResourcesRepository repository;

  DeleteDocumentUseCase(this.repository);

  void call(String collectionName, String id) {
    repository.delete(collectionName, id);
  }
}

class GetAllCollectionsUseCase {
  final GenericResourcesRepository repository;

  GetAllCollectionsUseCase(this.repository);

  List<GenericCollection> call() {
    return repository.getAllCollections();
  }
}

class GetCollectionByNameUseCase {
  final GenericResourcesRepository repository;

  GetCollectionByNameUseCase(this.repository);

  GenericCollection? call(String collectionName) {
    return repository.getAllCollections().firstWhere(
      (c) => c.collectionName == collectionName,
      orElse: () => GenericCollection(collectionName: '404', documents: []),
    );
  }
}

class AddCollectionUseCase {
  final GenericResourcesRepository repository;

  AddCollectionUseCase(this.repository);

  void call(GenericCollection collection) {
    repository.addCollection(collection);
  }
}

class UpdateCollectionUseCase {
  final GenericResourcesRepository repository;

  UpdateCollectionUseCase(this.repository);

  void call(GenericCollection updatedCollection) {
    repository.updateCollection(updatedCollection);
  }
}

class DeleteCollectionUseCase {
  final GenericResourcesRepository repository;

  DeleteCollectionUseCase(this.repository);

  void call(String collectionName) {
    repository.deleteCollection(collectionName);
  }
}
