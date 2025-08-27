import 'package:equatable/equatable.dart';
import '../../../../data/models/models.dart';

abstract class GenericCollectionEvent extends Equatable {
  const GenericCollectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadDocuments extends GenericCollectionEvent {
  final String collectionName;

  const LoadDocuments(this.collectionName);

  @override
  List<Object?> get props => [collectionName];
}

class AddDocument extends GenericCollectionEvent {
  final String collectionName;
  final GenericDocument document;

  const AddDocument(this.collectionName, this.document);

  @override
  List<Object?> get props => [collectionName, document];
}

class UpdateDocument extends GenericCollectionEvent {
  final String collectionName;
  final String id;
  final Map<String, dynamic> newData;

  const UpdateDocument(this.collectionName, this.id, this.newData);

  @override
  List<Object?> get props => [collectionName, id, newData];
}

class DeleteDocument extends GenericCollectionEvent {
  final String collectionName;
  final String id;

  const DeleteDocument(this.collectionName, this.id);

  @override
  List<Object?> get props => [collectionName, id];
}
