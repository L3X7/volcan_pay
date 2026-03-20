import 'package:volcan_pay/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);

  Future<UserEntity> register(String email, String password, String fullName);

  Future<void> signOut();

  Future<UserEntity> verifyEmailOTP(String email, String otp);
}
