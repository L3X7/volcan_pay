import 'package:volcan_pay/features/auth/data/models/user_model.dart';

abstract class AuthDatasource {
  Future<UserModel> signIn(String email, String password);

  Future<UserModel> signUp(String email, String password, String fullName);

  Future<void> signOut();

  Future<UserModel> verifyEmailOTP(String email, String otp);
}
