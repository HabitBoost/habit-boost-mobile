import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/locale/locale_cubit.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/core/theme/theme_cubit.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habits_bloc.dart';
import 'package:habit_boost/features/notifications/domain/repositories/notification_repository.dart';
import 'package:habit_boost/features/profile/presentation/screens/about_screen.dart';
import 'package:habit_boost/features/profile/presentation/screens/goals_screen.dart';
import 'package:habit_boost/features/profile/presentation/widgets/profile_header.dart';
import 'package:habit_boost/features/profile/presentation/widgets/settings_tile.dart';
import 'package:habit_boost/features/progress/presentation/widgets/stats_card.dart';
import 'package:habit_boost/features/sos/presentation/screens/sos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _notifKey = 'notifications_enabled';
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationSetting();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        context.read<HabitsBloc>().add(
              HabitsLoadRequested(
                userId: authState.user.id,
              ),
            );
      }
    });
  }

  Future<void> _loadNotificationSetting() async {
    final prefs = sl<SharedPreferences>();
    setState(() {
      _notificationsEnabled = prefs.getBool(_notifKey) ?? false;
    });
  }

  Future<void> _toggleNotifications({required bool value}) async {
    final repo = sl<NotificationRepository>();
    final prefs = sl<SharedPreferences>();

    if (value) {
      final granted = await repo.requestPermission();
      if (!granted) return;
    } else {
      await repo.cancelAll();
    }

    await prefs.setBool(_notifKey, value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final user = authState is Authenticated
                ? authState.user
                : null;

            final daysSinceReg = _daysSinceRegistration(
              user?.createdAt,
            );

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              children: [
                const SizedBox(height: AppDimensions.paddingM),
                ProfileHeader(
                  name: user?.name ?? l10n.profileUser,
                  email: user?.email ?? '',
                ),
                const SizedBox(height: AppDimensions.paddingL),
                _buildStats(context, daysSinceReg),
                const SizedBox(height: AppDimensions.paddingL),
                Text(
                  l10n.profileSettings,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                _buildSettingsCard(context, colors),
                const SizedBox(height: AppDimensions.paddingL),
                _buildLogoutButton(context),
                const SizedBox(height: AppDimensions.paddingL),
              ],
            );
          },
        ),
      ),
    );
  }

  int _daysSinceRegistration(DateTime? createdAt) {
    if (createdAt == null) return 0;
    return DateTime.now().difference(createdAt).inDays + 1;
  }

  Widget _buildStats(BuildContext context, int days) {
    final l10n = context.l10n;
    final habitsBloc = context.watch<HabitsBloc>();
    final habitCount = habitsBloc.state.habits.length;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCard(
            value: '$days',
            label: l10n.profileDaysWithUs,
            valueColor: AppColors.accentCoral,
          ),
          const SizedBox(width: 12),
          StatsCard(
            value: '$habitCount',
            label: l10n.profileHabitsCount,
            valueColor: AppColors.accentIndigo,
          ),
          const SizedBox(width: 12),
          StatsCard(
            value: '0',
            label: l10n.profileBadgesCount,
            valueColor: AppColors.accentGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    AppColorsTheme colors,
  ) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(
          AppDimensions.radiusCard,
        ),
      ),
      child: Column(
        children: [
          SettingsTile(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.accentCoral,
            title: l10n.profileNotifications,
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeTrackColor: AppColors.primary,
              onChanged: (value) =>
                  _toggleNotifications(value: value),
            ),
            onTap: () => _toggleNotifications(
              value: !_notificationsEnabled,
            ),
          ),
          Divider(
            height: 1,
            color: colors.borderSubtle,
          ),
          SettingsTile(
            icon: Icons.gps_fixed,
            iconColor: AppColors.accentGreen,
            title: l10n.profileGoals,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const GoalsScreen(),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: colors.borderSubtle,
          ),
          SettingsTile(
            icon: Icons.dark_mode_outlined,
            iconColor: AppColors.accentIndigo,
            title: l10n.profileTheme,
            onTap: () => _showThemePicker(context),
          ),
          Divider(
            height: 1,
            color: colors.borderSubtle,
          ),
          SettingsTile(
            icon: Icons.language,
            iconColor: AppColors.accentOrange,
            title: l10n.profileLanguage,
            onTap: () => _showLanguagePicker(context),
          ),
          Divider(
            height: 1,
            color: colors.borderSubtle,
          ),
          SettingsTile(
            icon: Icons.info_outline,
            iconColor: colors.textTertiary,
            title: l10n.profileAbout,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const AboutScreen(),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: colors.borderSubtle,
          ),
          SettingsTile(
            icon: Icons.sos,
            iconColor: AppColors.accentCoral,
            title: l10n.profileSos,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SosScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _confirmLogout(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentCoral,
          side: const BorderSide(
            color: AppColors.accentCoral,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusCard,
            ),
          ),
        ),
        child: Text(
          l10n.profileLogout,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showThemePicker(BuildContext context) {
    final cubit = context.read<ThemeCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _ThemePickerSheet(),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final cubit = context.read<LocaleCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _LanguagePickerSheet(),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<AuthBloc>()
                  .add(const AuthLogoutRequested());
              context.go(Routes.login);
            },
            child: Text(
              l10n.profileLogoutAction,
              style: const TextStyle(
                color: AppColors.accentCoral,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePickerSheet extends StatelessWidget {
  const _ThemePickerSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, current) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingM,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                  ),
                  child: Text(
                    l10n.profileTheme,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(
                  height: AppDimensions.paddingM,
                ),
                _ThemeOption(
                  icon: Icons.brightness_auto,
                  title: l10n.themeSystem,
                  isSelected: current == ThemeMode.system,
                  onTap: () {
                    context
                        .read<ThemeCubit>()
                        .setTheme(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                _ThemeOption(
                  icon: Icons.light_mode_outlined,
                  title: l10n.themeLight,
                  isSelected: current == ThemeMode.light,
                  onTap: () {
                    context
                        .read<ThemeCubit>()
                        .setTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                _ThemeOption(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.themeDark,
                  isSelected: current == ThemeMode.dark,
                  onTap: () {
                    context
                        .read<ThemeCubit>()
                        .setTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, current) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingM,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                  ),
                  child: Text(
                    l10n.profileLanguage,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(
                  height: AppDimensions.paddingM,
                ),
                _LanguageOption(
                  icon: Icons.brightness_auto,
                  title: l10n.languageSystem,
                  isSelected: current == null,
                  onTap: () {
                    context
                        .read<LocaleCubit>()
                        .setLocale(null);
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  icon: Icons.language,
                  title: l10n.languageRussian,
                  isSelected:
                      current?.languageCode == 'ru',
                  onTap: () {
                    context
                        .read<LocaleCubit>()
                        .setLocale(const Locale('ru'));
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  icon: Icons.language,
                  title: l10n.languageEnglish,
                  isSelected:
                      current?.languageCode == 'en',
                  onTap: () {
                    context
                        .read<LocaleCubit>()
                        .setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : colors.textTertiary,
      ),
      title: Text(title),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppColors.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : colors.textTertiary,
      ),
      title: Text(title),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: AppColors.primary,
            )
          : null,
      onTap: onTap,
    );
  }
}
