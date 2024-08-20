import 'package:blog_app/core/common/cubits/cubit/app_user_cubit.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';


import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/secrect/app_secrets.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
final serviceLocator=GetIt.instance;
Future<void> initDependencies() async{
  _initAuth();
  final supabase=await Supabase.initialize(
    url: AppSecrets.supabaseUrl,anonKey:AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(()=>supabase.client);
  serviceLocator.registerLazySingleton(()=>AppUserCubit());
}
void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
  // Repository
    ..registerFactory<AuthRepository>(
          () => AuthRepositoryImpl(
        serviceLocator(),

      ),
    )
  // Usecases
    ..registerFactory(
          () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
          () => UserLogin(
        serviceLocator(),
      ),

    )
    ..registerFactory(
          () => CurrentUser(
         serviceLocator(),
      ),

    )
  // Bloc
    ..registerLazySingleton(
          () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
       appUserCubit: serviceLocator(),
      ),
    );
}