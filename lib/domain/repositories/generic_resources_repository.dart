import '../../data/models/project/generic_collection.dart';
import '../../data/models/project/generic_document.dart';

abstract class GenericResourcesRepository {
  List<GenericCollection> getAllCollections();

  List<GenericDocument> getAll(String collectionName);

  void add(String collectionName, GenericDocument document);

  void update(String collectionName, String id, Map<String, dynamic> newData);

  void delete(String collectionName, String id);

  GenericCollection? getCollectionByName(String collectionName);

  void addCollection(GenericCollection collection);

  void updateCollection(GenericCollection updatedCollection);

  void deleteCollection(String collectionName);
}
