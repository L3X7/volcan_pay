import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:volcan_pay/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';

part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: "full_name") String? fullName,
    @JsonKey(name: "email_confirmed_at") String? emailConfirmedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromSupabaseUser(User user) => UserModel(
    id: user.id,
    email: user.email ?? '',
    fullName: user.userMetadata?['full_name'],
    emailConfirmedAt: user.emailConfirmedAt,
  );
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    fullName: fullName,
    emailConfirmedAt: emailConfirmedAt,
  );
}
