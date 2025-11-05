import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String pass,
  });

  Future<String> signInWithEmailPassword({
    required String email,
    required String pass,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> signInWithEmailPassword ({
    required String email,
    required String pass}) async {
    try{
      return '';
    }catch (e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String pass}) async {
    try {
      final response =await supabaseClient.auth.signUp(password: pass, email: email, data: {
        'name': name
      });

      if(response.user == null){
        throw ServerException('User is null!');
      }
      return response.user!.id;
    } catch (e) {
        throw ServerException(e.toString());
    }
  }

}
