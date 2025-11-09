import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> signInWithEmailPassword({
    required String email,
    required String password,
  }) async{
    try {
      final user = await remoteDataSource.signInWithEmailPassword(email: email, pass: password);
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        pass: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {

    try{
      final user = await remoteDataSource.getCurrentUserData();
      if(user == null){
        return left(Failure('User not logged in'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }

  }

  Future<Either<Failure, User>> _getUser(
      Future<User> Function() fn,
      ) async {
    try {
      /*if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }*/
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
