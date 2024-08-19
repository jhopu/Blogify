import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/usecase/usecase.dart';

class UserLogin implements UseCase<User,UserLoginParams>{
  final AuthRepository authRepository;
  UserLogin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async{
   return await authRepository.loginWithEmailPassword(email: params.email, password: params.password);
  }
  
}


class UserLoginParams {
  final String email;
  final String password;


  UserLoginParams({
    required this.email,
    required this.password,
    });

}