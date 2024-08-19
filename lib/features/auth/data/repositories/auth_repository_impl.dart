import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../datasources/auth_remote_data.dart';

class AuthRepositoryImpl implements AuthRepository{
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, User>> loginWithEmailPassword({required String email, required String password}) async{
   try{
  final user= await remoteDataSource.loginWithEmailPassword(email: email, password: password);
  return right(user);
   }on ServerException catch(e){
     print("hi world    ${e.message}!!");
     return left(Failure(e.message));
   }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({required String name, required String email, required String password}) async{
    try {
      final userId = await remoteDataSource.singUpWithEmailPassword(
          name: name, email: email, password: password);
      return right(userId);
    }
    on ServerException catch (e) {
      print("hi world    ${e.message}!!");
      return left(Failure(e.message));
    }

  }


}