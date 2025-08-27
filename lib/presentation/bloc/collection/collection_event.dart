part of 'collection_bloc.dart';

abstract class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends CollectionEvent {
  final String collectionName;

  const LoadDocuments(this.collectionName);

  @override
  List<Object?> get props => [collectionName];
}

class AddDocument extends CollectionEvent {
  final String collectionName;
  final GenericDocument document;

  const AddDocument(this.collectionName, this.document);

  @override
  List<Object?> get props => [collectionName, document];
}

class UpdateDocument extends CollectionEvent {
  final String collectionName;
  final String id;
  final Map<String, dynamic> newData;

  const UpdateDocument(this.collectionName, this.id, this.newData);

  @override
  List<Object?> get props => [collectionName, id, newData];
}

class DeleteDocument extends CollectionEvent {
  final String collectionName;
  final String id;

  const DeleteDocument(this.collectionName, this.id);

  @override
  List<Object?> get props => [collectionName, id];
}
