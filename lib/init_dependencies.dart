import 'package:blog_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_screts.dart';
import 'feature/auth/domain/repository/auth_repository.dart';
import 'feature/auth/domain/usecases/user_login.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  serviceLocator..registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  )

  ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(serviceLocator()))

  ..registerFactory(() => UserSignUp(serviceLocator()))

  ..registerFactory(() => UserLogin(serviceLocator()))

  ..registerLazySingleton(() => AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator()));
}
