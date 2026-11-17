import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controllers/game_library_controller.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.preferences});

  final SharedPreferences preferences;

  Future<void> _logout() async {
    await preferences.remove(sessionEmailKey);
    Get.offAll(() => LoginPage(preferences: preferences));
  }

  @override
  Widget build(BuildContext context) {
    final email = preferences.getString(sessionEmailKey) ?? '';
    final library = Get.find<GameLibraryController>();
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Profil',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF333333),
                  child: Icon(
                    Icons.person_rounded,
                    size: 58,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                _ProfileRow(label: 'Email:', value: email),
                const SizedBox(height: 14),
                Obx(
                  () => _ProfileRow(
                    label: 'Games Dimiliki:',
                    value: '${library.games.length}',
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: _logout,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFF04438),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Logout'),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: .7)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
