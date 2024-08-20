import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/datasources/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource{
  Session? get currentUserSession;
  Future<UserModel> singUpWithEmailPassword({
    required String name,
    required String email,
    required String password,

});
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,

  });
  Future<UserModel?> getCurrentUserData();
}
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  // TODO: implement currentUserSession
  Session? get currentUserSession => supabaseClient.auth.currentSession;
  @override
  Future<UserModel> loginWithEmailPassword({
    required String email, required String password}) async{
    try{
      final respone=await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
        );
      if(respone.user==null){
        throw ServerException('User is null!');
      }
      return UserModel.fromJson(respone.user!.toJson());
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> singUpWithEmailPassword({
    required String name, required String email, required String password}) async{
   try{
final respone=await supabaseClient.auth.signUp(
  password: password,
email: email,
data:{'name': name,},);
if(respone.user==null){
  throw ServerException('User is null!');
}
return UserModel.fromJson(respone.user!.toJson());
   }catch(e){
throw ServerException(e.toString());
   }
  }

  @override
  Future<UserModel?> getCurrentUserData() async{
   try{
     if(currentUserSession!=null){
       final userData=await supabaseClient.from('profiles').select().eq('id', currentUserSession!.user.id,);
       return UserModel.fromJson(userData.first);
     }
return null;
   }
   catch(e){
     throw ServerException(e.toString());
   }
  }



}