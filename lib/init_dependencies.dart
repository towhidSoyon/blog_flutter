import 'package:blog_app/core/common/cubits/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/feature/auth/domain/usecases/current_user.dart';
import 'package:blog_app/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/feature/auth/presentation/auth_bloc.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_local_datasource.dart';
import 'package:blog_app/feature/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/feature/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/feature/blog/presentation/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrets/app_screts.dart';
import 'feature/auth/domain/repository/auth_repository.dart';
import 'feature/auth/domain/usecases/user_login.dart';
import 'feature/blog/data/repositories/blog_repositories_impl.dart';
import 'feature/blog/domain/repositories/blog_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name:'blogs'));

  //core

  serviceLocator.registerLazySingleton<InternetConnection>(() => InternetConnection());


  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(serviceLocator<InternetConnection>()),
  );

  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator<BlogRemoteDataSource>(),
        serviceLocator<BlogLocalDataSource>(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlog: serviceLocator()),
    );
}
