import 'package:equatable/equatable.dart';
import '../../../../data/models/models.dart';

abstract class GenericCollectionState extends Equatable {
  const GenericCollectionState();

  @override
  List<Object?> get props => [];
}

class CollectionInitial extends GenericCollectionState {}

class CollectionLoading extends GenericCollectionState {}

class CollectionLoaded extends GenericCollectionState {
  final List<GenericDocument> documents;

  const CollectionLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

class CollectionError extends GenericCollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object?> get props => [message];
}
