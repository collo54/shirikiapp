import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shiriki/models/user_model.dart';
import 'package:shiriki/pages/fullmap_page.dart';
import 'package:shiriki/pages/login_page.dart';

import '../providers.dart';

final userProvider = StreamProvider<UserModel?>((ref) async* {
  // Connect to an API using sockets, and decode the output
  final userDataStream = ref.read(authenticate).onAuthStateChanged;

  await for (var userData in userDataStream) {
    yield userData;
  }
});

class AuthState extends ConsumerWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(userProvider);
    return value.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => Text(error.toString()),
      data: (user) {
        if (user != null) {
          return const FullMapPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
