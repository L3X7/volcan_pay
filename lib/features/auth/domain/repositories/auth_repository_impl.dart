import 'package:volcan_pay/features/auth/data/datasources/auth_datasource.dart';
import 'package:volcan_pay/features/auth/data/models/user_model.dart';
import 'package:volcan_pay/features/auth/domain/entities/user_entity.dart';
import 'package:volcan_pay/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await datasource.signIn(email, password);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register(
    String email,
    String password,
    String fullName,
  ) async {
    final userModel = await datasource.signUp(email, password, fullName);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> verifyEmailOTP(String email, String otp) async {
    final userModel = await datasource.verifyEmailOTP(email, otp);
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await datasource.signOut();
  }
}
