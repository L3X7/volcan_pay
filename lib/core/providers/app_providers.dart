import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:volcan_pay/features/auth/data/datasources/auth_datasource_impl.dart';
import 'package:volcan_pay/features/auth/domain/repositories/auth_repository.dart';
import 'package:volcan_pay/features/auth/domain/repositories/auth_repository_impl.dart';

part 'app_providers.g.dart';

@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

@riverpod
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = AuthDatasourceImpl(client);
  return AuthRepositoryImpl(dataSource);
}
