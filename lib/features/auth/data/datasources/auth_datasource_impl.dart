import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:volcan_pay/features/auth/data/datasources/auth_datasource.dart';
import 'package:volcan_pay/features/auth/data/models/user_model.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final SupabaseClient _client;

  AuthDatasourceImpl(this._client);

  @override
  Future<UserModel> signIn(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Error al iniciar sesión');
    }

    return UserModel.fromJson({
      'id': response.user!.id,
      'email': response.user!.email,
      'full_name': response.user!.userMetadata?['full_name'],
    });
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<UserModel> signUp(
    String email,
    String password,
    String fullName,
  ) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    if (response.user == null) {
      throw Exception('Error al registrarse');
    }

    return UserModel.fromJson({
      'id': response.user!.id,
      'email': response.user!.email,
      'full_name': fullName,
    });
  }
}
