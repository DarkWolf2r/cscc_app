import 'package:cscc_app/features/auth/model/user_model.dart';
import 'package:cscc_app/features/auth/repo/user_info_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import 'package:flutter_riverpod/legacy.dart';

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final UserModel user = await ref
      .watch(userDataServiceProvider)
      .fetchCurrentUserData();
  return user;
});

final anyUserDataProvider = FutureProvider.family((ref, userId) async {
  final UserModel user = await ref
      .watch(userDataServiceProvider)
      .fetchAnytUserData(userId);
  return user;
});

// ana zidthom hna
final userNotifierProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<UserModel?>>((ref) {
  return UserNotifier(ref);
});

class UserNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref ref;
  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    refreshUser();
  }
  Future<void> refreshUser() async {
    try {
      final userRepo = ref.watch(userDataServiceProvider);
      final user = await userRepo.fetchCurrentUserData();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}