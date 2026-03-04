import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:volcan_pay/features/auth/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';


@freezed
abstract class UserModel with _$UserModel {

  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: "full_name") String? fullName,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(id: id, email: email, fullName: fullName);
}
