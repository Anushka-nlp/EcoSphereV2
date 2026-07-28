import 'package:anymex/controllers/auth_controller.dart';
import 'package:anymex/controllers/theme.dart';
import 'package:anymex/screens/auth/login_screen.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_button.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

enum PageType { manga, anime, home, novel, library, extensions }

class Header extends StatelessWidget {
  final PageType type;
  const Header({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authController = Get.find<AuthController>();
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 650;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12.0 : 16.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          // Theme Toggle
          IconButton(
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              size: isMobile ? 18 : 20,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          const Spacer(),

          // Centered Logo & Branding
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.campaign,
                  color: theme.colorScheme.primary,
                  size: isMobile ? 20 : 22,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'EchoSphere',
                style: TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: isMobile ? 17 : 19,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const Spacer(),

          // User Profile & Role Info
          Obx(() {
            final user = authController.currentUser.value;
            if (user == null || !authController.isLoggedIn.value) {
              return EchoSphereButton(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onTap: () => Get.to(() => const LoginScreen()),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login, size: isMobile ? 14 : 16),
                    if (!isMobile) ...[
                      const SizedBox(width: 4),
                      const Text('Login', style: TextStyle(fontSize: 12)),
                    ],
                  ],
                ),
              );
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMobile) ...[
                  EchoSphereChip(
                    label: user.role,
                    isSelected: true,
                    onSelected: (_) {},
                  ),
                  const SizedBox(width: 8),
                ],
                GestureDetector(
                  onTap: () => _showUserMenu(context, authController),
                  child: CircleAvatar(
                    radius: isMobile ? 15 : 18,
                    backgroundColor: theme.colorScheme.primary,
                    child: Text(
                      user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _showUserMenu(BuildContext context, AuthController authController) {
    final user = authController.currentUser.value;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user?.fullName ?? 'User Profile',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Role: ${user?.role} • Dept: ${user?.department ?? "N/A"}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            if (user?.usn != null) ...[
              const SizedBox(height: 4),
              Text('USN: ${user!.usn}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
            if (user?.employeeId != null) ...[
              const SizedBox(height: 4),
              Text('Employee ID: ${user!.employeeId}', style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
            const Divider(height: 24),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                authController.logout();
                Get.offAll(() => const LoginScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
