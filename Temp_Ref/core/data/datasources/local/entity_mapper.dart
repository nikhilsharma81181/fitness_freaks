/// Interface for mapping between domain entities and data models
///
/// This interface ensures consistency in the way entities are mapped to
/// storage models and vice versa.
///
/// [E] is the entity type (domain model)
/// [M] is the model type (data model for storage)
abstract class EntityMapper<E, M> {
  /// Convert from a domain entity to a data model for storage
  ///
  /// [entity] is the domain entity to convert
  M toModel(E entity);
  
  /// Convert from a data model to a domain entity
  ///
  /// [model] is the data model to convert
  E toEntity(M model);
  
  /// Convert a list of domain entities to a list of data models
  ///
  /// [entities] is the list of domain entities to convert
  List<M> toModelList(List<E> entities) {
    return entities.map((e) => toModel(e)).toList();
  }
  
  /// Convert a list of data models to a list of domain entities
  ///
  /// [models] is the list of data models to convert
  List<E> toEntityList(List<M> models) {
    return models.map((m) => toEntity(m)).toList();
  }
}
