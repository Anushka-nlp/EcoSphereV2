import 'package:anymex/ai/echosphere_ai.dart';
import 'package:anymex/controllers/announcement_controller.dart';
import 'package:anymex/controllers/auth_controller.dart';
import 'package:anymex/screens/admin/user_management_page.dart';
import 'package:anymex/screens/announcements/approval_queue_page.dart';
import 'package:anymex/screens/announcements/create_announcement_dialog.dart';
import 'package:anymex/screens/announcements/speaker_queue_page.dart';
import 'package:anymex/screens/auth/login_screen.dart';
import 'package:anymex/screens/home/home_dashboard_widgets.dart';
import 'package:anymex/screens/notifications/notifications_page.dart';
import 'package:anymex/screens/profile/profile_page.dart';
import 'package:anymex/widgets/common/glow.dart';
import 'package:anymex/widgets/common/navbar.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_button.dart';
import 'package:anymex/widgets/custom_widgets/echosphere_chip.dart';
import 'package:anymex/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

  final AuthController authController = Get.put(AuthController());
  final AnnouncementController annController = Get.put(AnnouncementController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 750;

    return Scaffold(
      body: Glow(
        child: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              const Header(type: PageType.home),
              const Divider(height: 1),

            Expanded(
              child: Obx(() {
                final navItems = _buildNavItems(context);
                final pages = _buildPages(context, theme);

                // Reset index if out of range when role changes
                final safeIndex = _selectedNavIndex >= navItems.length ? 0 : _selectedNavIndex;

                return Row(
                  children: [
                    // Desktop Side Navigation Bar
                    if (isDesktop)
                      ResponsiveNavBar(
                        isDesktop: true,
                        currentIndex: safeIndex,
                        items: navItems,
                      ),

                    // Main View Content
                    Expanded(
                      child: IndexedStack(
                        index: safeIndex,
                        children: pages,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    ),

      // Mobile Bottom Navigation Bar
      bottomNavigationBar: Obx(() {
        final navItems = _buildNavItems(context);
        final safeIndex = _selectedNavIndex >= navItems.length ? 0 : _selectedNavIndex;

        return isDesktop
            ? const SizedBox.shrink()
            : ResponsiveNavBar(
                isDesktop: false,
                currentIndex: safeIndex,
                items: navItems,
              );
      }),

      // Floating Creation Button for authorized users (Non-Student)
      floatingActionButton: Obx(() {
        final user = authController.currentUser.value;
        final canCreate = user != null && user.role != 'Student';

        if (_selectedNavIndex == 0 && canCreate) {
          return FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const CreateAnnouncementDialog(),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('New Notice'),
            backgroundColor: theme.colorScheme.primary,
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  List<Widget> _buildPages(BuildContext context, ThemeData theme) {
    final user = authController.currentUser.value;
    final role = user?.role ?? 'Student';

    if (role == 'Student') {
      return [
        _buildAnnouncementsDashboard(context, theme),
        _buildSearchPage(context, theme),
        const EchosphereAi(),
        const NotificationsPage(),
        const ProfilePage(),
      ];
    } else if (role == 'Teacher') {
      return [
        _buildAnnouncementsDashboard(context, theme),
        _buildSearchPage(context, theme),
        const ApprovalQueuePage(),
        const EchosphereAi(),
        const NotificationsPage(),
        const UserManagementPage(),
        const ProfilePage(),
      ];
    } else {
      // HoD, College Admin, Principal, Dev Admin
      return [
        _buildAnnouncementsDashboard(context, theme),
        _buildSearchPage(context, theme),
        const ApprovalQueuePage(),
        const SpeakerQueuePage(),
        const EchosphereAi(),
        const NotificationsPage(),
        const UserManagementPage(),
        const ProfilePage(),
      ];
    }
  }

  List<NavItem> _buildNavItems(BuildContext context) {
    final user = authController.currentUser.value;
    final role = user?.role ?? 'Student';

    if (role == 'Student') {
      return [
        NavItem(
          selectedIcon: Icons.campaign,
          unselectedIcon: Icons.campaign_outlined,
          label: 'Notices',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.search,
          unselectedIcon: Icons.search_outlined,
          label: 'Search',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.auto_awesome,
          unselectedIcon: Icons.auto_awesome_outlined,
          label: 'AI Assistant',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.notifications,
          unselectedIcon: Icons.notifications_outlined,
          label: 'Alerts',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.person,
          unselectedIcon: Icons.person_outline,
          label: 'Profile',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
      ];
    }

    if (role == 'Teacher') {
      return [
        NavItem(
          selectedIcon: Icons.campaign,
          unselectedIcon: Icons.campaign_outlined,
          label: 'Notices',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.search,
          unselectedIcon: Icons.search_outlined,
          label: 'Search',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.edit_note,
          unselectedIcon: Icons.edit_note_outlined,
          label: 'My Notices',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.auto_awesome,
          unselectedIcon: Icons.auto_awesome_outlined,
          label: 'AI Assistant',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.notifications,
          unselectedIcon: Icons.notifications_outlined,
          label: 'Alerts',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.group,
          unselectedIcon: Icons.group_outlined,
          label: 'Students',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
        NavItem(
          selectedIcon: Icons.person,
          unselectedIcon: Icons.person_outline,
          label: 'Profile',
          onTap: (index) => setState(() => _selectedNavIndex = index),
        ),
      ];
    }

    // HoD, College Admin, Principal, Developer Admin
    return [
      NavItem(
        selectedIcon: Icons.campaign,
        unselectedIcon: Icons.campaign_outlined,
        label: 'Notices',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.search,
        unselectedIcon: Icons.search_outlined,
        label: 'Search',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.fact_check,
        unselectedIcon: Icons.fact_check_outlined,
        label: 'Approvals',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.volume_up,
        unselectedIcon: Icons.volume_up_outlined,
        label: 'Speaker Queue',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.auto_awesome,
        unselectedIcon: Icons.auto_awesome_outlined,
        label: 'AI Assistant',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.notifications,
        unselectedIcon: Icons.notifications_outlined,
        label: 'Alerts',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.manage_accounts,
        unselectedIcon: Icons.manage_accounts_outlined,
        label: 'Accounts',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
      NavItem(
        selectedIcon: Icons.person,
        unselectedIcon: Icons.person_outline,
        label: 'Profile',
        onTap: (index) => setState(() => _selectedNavIndex = index),
      ),
    ];
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Central Dashboard — The Home Screen
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildAnnouncementsDashboard(BuildContext context, ThemeData theme) {
    return Obx(() {
      // Show shimmer skeleton only on initial load when data is empty
      if (annController.isLoading.value && annController.announcements.isEmpty) {
        return const DashboardSkeleton();
      }

      return RefreshIndicator(
        onRefresh: annController.fetchAnnouncements,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Section 1: Welcome Banner ─────────────────────────
              _buildWelcomeBanner(theme),
              const SizedBox(height: 16),

              // ─── Section 2: Today's Summary ────────────────────────
              Obx(() => TodaySummaryBanner(
                    todayCount: annController.todayAnnouncements.length,
                    pendingCount: annController.pendingApprovals.length,
                    isAuthorized: authController.currentUser.value != null &&
                        authController.currentUser.value!.role != 'Student',
                  )),
              const SizedBox(height: 20),

              // ─── Section 3: Stats Dashboard Panel ──────────────────
              _buildStatsPanel(theme),
              const SizedBox(height: 24),

              // ─── Section 4: Quick Actions + AI Shortcut ────────────
              _buildQuickActionsSection(theme),
              const SizedBox(height: 24),

              // ─── Section 5: Priority Announcements Carousel ────────
              Obx(() {
                final priorityList = annController.priorityAnnouncements;
                if (priorityList.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: PriorityCarousel(items: priorityList),
                );
              }),

              // ─── Section 6: Category Filter Chips ──────────────────
              _buildCategoryFilters(theme),
              const SizedBox(height: 20),

              // ─── Section 7: Announcement Feed ──────────────────────
              _buildAnnouncementFeed(theme),
            ],
          ),
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Welcome Banner
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildWelcomeBanner(ThemeData theme) {
    return Obx(() {
      final user = authController.currentUser.value;
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - value)),
            child: child,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.secondary.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.15),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.notifications_active,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user != null
                          ? 'Welcome back, ${user.fullName} 👋'
                          : 'Welcome to EchoSphere 📢',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Bold',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user != null
                          ? '${user.role} · ${user.department ?? "College-Wide"} Department'
                          : 'Log in to access college announcements.',
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              if (user == null)
                EchoSphereButton(
                  height: 38,
                  onTap: () => Get.to(() => const LoginScreen()),
                  child: const Text('Login'),
                ),
            ],
          ),
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Stats Dashboard Panel — Animated metric cards
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildStatsPanel(ThemeData theme) {
    return Obx(() {
      final user = authController.currentUser.value;
      final role = user?.role ?? 'Student';
      final isAdmin = role == 'College Admin' ||
          role == 'HoD' ||
          role == 'Principal' ||
          role == 'Developer';

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        ),
        child: Row(
          children: [
            StatCard(
              label: 'Total Notices',
              value: annController.announcements.length,
              icon: Icons.campaign_rounded,
              color: Colors.blue,
            ),
            const SizedBox(width: 10),
            StatCard(
              label: 'Today',
              value: annController.todayAnnouncements.length,
              icon: Icons.today_rounded,
              color: Colors.green,
            ),
            const SizedBox(width: 10),
            if (isAdmin || role == 'Teacher')
              StatCard(
                label: 'Pending',
                value: annController.pendingApprovals.length,
                icon: Icons.pending_actions_rounded,
                color: Colors.orange,
                onTap: () => setState(() => _selectedNavIndex = 1),
              )
            else
              StatCard(
                label: 'Urgent',
                value: annController.emergencyCount,
                icon: Icons.warning_amber_rounded,
                color: Colors.red,
              ),
          ],
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Quick Actions + AI Shortcut
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildQuickActionsSection(ThemeData theme) {
    return Obx(() {
      final user = authController.currentUser.value;
      final role = user?.role ?? 'Student';
      final canCreate = user != null && role != 'Student';
      final isTeacher = role == 'Teacher';
      final isAdmin = role == 'College Admin' ||
          role == 'HoD' ||
          role == 'Principal' ||
          role == 'Developer';

      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) => Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Horizontal scrollable Quick Actions row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (canCreate)
                    QuickActionCard(
                      title: 'New Notice',
                      icon: Icons.add_circle_rounded,
                      color: Colors.green,
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const CreateAnnouncementDialog(),
                      ),
                    ),
                  if (isAdmin || isTeacher)
                    QuickActionCard(
                      title: 'Approvals',
                      icon: Icons.fact_check_rounded,
                      color: Colors.orange,
                      badgeCount: annController.pendingApprovals.length,
                      onTap: () => setState(() => _selectedNavIndex = 1),
                    ),
                  if (isAdmin)
                    QuickActionCard(
                      title: 'Speaker Queue',
                      icon: Icons.volume_up_rounded,
                      color: Colors.blue,
                      onTap: () => setState(() => _selectedNavIndex = 2),
                    ),
                  QuickActionCard(
                    title: 'My Profile',
                    icon: Icons.person_rounded,
                    color: Colors.purple,
                    onTap: () => setState(() =>
                        _selectedNavIndex =
                            isAdmin ? 6 : (isTeacher ? 5 : 3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // AI Assistant Shortcut Banner
            InkWell(
              onTap: () => setState(() => _selectedNavIndex =
                  isAdmin ? 3 : (isTeacher ? 2 : 1)),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade200.withOpacity(0.15),
                      Colors.amber.shade500.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.shade400.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: Colors.amber, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'EchoSphere AI Assistant',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Ask about academics, navigate the app, or get help.',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.amber.shade600),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Category Filter Chips
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Poppins-Bold',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: AnnouncementController.categories.map((cat) {
                final isSelected =
                    annController.selectedCategory.value == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: EchoSphereChip(
                    label: cat,
                    isSelected: isSelected,
                    onSelected: (val) {
                      if (val) annController.selectedCategory.value = cat;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Announcement Feed List
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildAnnouncementFeed(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Announcements',
              style: TextStyle(
                fontFamily: 'Poppins-Bold',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${annController.filteredAnnouncements.length} Notices',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: 14),

        Obx(() {
          final feed = annController.filteredAnnouncements;

          if (feed.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Icon(Icons.campaign_outlined,
                        size: 56,
                        color: theme.colorScheme.onSurface.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Text(
                      'No announcements match your search or filter.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different category or clear your search.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: feed.length,
            itemBuilder: (context, index) {
              return AnnouncementFeedCard(
                notice: feed[index],
                index: index,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildSearchPage(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Search Announcements',
            style: TextStyle(
              fontFamily: 'Poppins-Bold',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          // Purple Rounded Pill Search Input
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: TextField(
              onChanged: (val) => annController.searchQuery.value = val,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search by title, department, or keyword...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: Icon(Icons.search_rounded,
                      size: 20,
                      color: theme.colorScheme.primary),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category Filters
          _buildCategoryFilters(theme),
          const SizedBox(height: 16),

          // Search Results
          Obx(() {
            final feed = annController.filteredAnnouncements;
            if (feed.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56,
                          color: theme.colorScheme.onSurface.withOpacity(0.2)),
                      const SizedBox(height: 16),
                      Text(
                        'No announcements found matching your search.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feed.length,
              itemBuilder: (context, index) {
                return AnnouncementFeedCard(
                  notice: feed[index],
                  index: index,
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
