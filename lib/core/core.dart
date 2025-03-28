/// Top-level exports for the core module
/// 
/// This allows importing the core module with a single import statement
library core;

// Core domain
export 'domain/entities/either.dart';
export 'domain/failures/failure.dart';
export 'domain/usecases/usecase.dart';

// Core data
export 'data/datasources/local/cache_policy.dart';
export 'data/datasources/local/entity_mapper.dart';
export 'data/datasources/local/local_storage.dart';
export 'data/datasources/remote/api_response_mapper.dart';
export 'data/datasources/remote/http_client.dart';
export 'data/datasources/remote/interceptors.dart';
export 'data/datasources/remote/network_info.dart';
export 'data/exceptions.dart';
export 'data/repositories/repository.dart';

// Core infrastructure
export 'infrastructure/local_storage/adapters/datetime_adapter.dart';
export 'infrastructure/local_storage/adapters/duration_adapter.dart';
export 'infrastructure/local_storage/adapters/uri_adapter.dart';
export 'infrastructure/local_storage/hive_storage.dart';
export 'infrastructure/local_storage/storage_encryption.dart';
export 'infrastructure/network/dio_client.dart';
export 'infrastructure/network/network_info_impl.dart';
export 'infrastructure/services/logger_service.dart';

// Core presentation
export 'presentation/providers/providers.dart';
export 'presentation/widgets/widgets.dart';

// Core DI
export 'di/provider_config.dart';
export 'di/providers.dart';

// Core constants
export 'constants/colors.dart';
export 'constants/endpoints.dart';
export 'constants/theme.dart';

// Core utils
export 'utils/image_compressor.dart';