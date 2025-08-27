part of 'collection_bloc.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final String collectionName;
  final List<GenericDocument> documents;

  const CollectionLoaded(this.collectionName, this.documents);

  @override
  List<Object?> get props => [collectionName, documents];
}

class CollectionError extends CollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class CollectionUpdating extends CollectionState {
  final String collectionName;
  final List<GenericDocument> documents;

  const CollectionUpdating(this.collectionName, this.documents);

  @override
  List<Object?> get props => [collectionName, documents];
}
