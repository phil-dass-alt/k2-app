import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'auth_provider.dart';

class UserProfileState {
  final UserModel? profile;
  final bool isLoading;
  final String? error;

  const UserProfileState({this.profile, this.isLoading = false, this.error});

  UserProfileState copyWith({
    UserModel? profile,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return UserProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfileState> {
  final UserService _userService;
  final String? _userId;

  UserProfileNotifier(this._userService, this._userId)
      : super(const UserProfileState()) {
    if (_userId != null) _loadProfile();
  }

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _userService.getUser(_userId!);
      state = state.copyWith(profile: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _userService.updateUser(updatedUser);
      state = state.copyWith(profile: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> refresh() => _loadProfile();
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final authState = ref.watch(authProvider);
  return UserProfileNotifier(userService, authState.user?.id);
});

// Provider for all users (admin use)
final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return userService.getAllUsers();
});

// Provider for pending users
final pendingUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  return userService.getPendingUsers();
});
