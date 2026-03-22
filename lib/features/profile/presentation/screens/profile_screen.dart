import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/profile/presentation/widgets/profile_header.dart';
import 'package:habit_boost/features/profile/presentation/widgets/settings_tile.dart';
import 'package:habit_boost/features/progress/presentation/widgets/stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final user = authState is Authenticated
                ? authState.user
                : null;

            return ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
              ),
              children: [
                const SizedBox(height: AppDimensions.paddingM),
                ProfileHeader(
                  name: user?.name ?? 'Пользователь',
                  email: user?.email ?? '',
                ),
                const SizedBox(height: AppDimensions.paddingL),
                const Row(
                  children: [
                    StatsCard(
                      value: '—',
                      label: 'Всего дней',
                      valueColor: AppColors.accentCoral,
                    ),
                    SizedBox(width: 12),
                    StatsCard(
                      value: '—',
                      label: 'Привычек',
                      valueColor: AppColors.accentIndigo,
                    ),
                    SizedBox(width: 12),
                    StatsCard(
                      value: '—',
                      label: 'Бейджей',
                      valueColor: AppColors.accentGreen,
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingL),
                Text(
                  'Настройки',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusCard,
                    ),
                  ),
                  child: Column(
                    children: [
                      SettingsTile(
                        icon: Icons.notifications_outlined,
                        iconColor: AppColors.accentCoral,
                        title: 'Уведомления',
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.borderSubtle,
                      ),
                      SettingsTile(
                        icon: Icons.gps_fixed,
                        iconColor: AppColors.accentGreen,
                        title: 'Мои цели',
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.borderSubtle,
                      ),
                      SettingsTile(
                        icon: Icons.dark_mode_outlined,
                        iconColor: AppColors.accentIndigo,
                        title: 'Тема оформления',
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.borderSubtle,
                      ),
                      SettingsTile(
                        icon: Icons.language,
                        iconColor: AppColors.accentOrange,
                        title: 'Язык',
                        onTap: () {},
                      ),
                      const Divider(
                        height: 1,
                        color: AppColors.borderSubtle,
                      ),
                      SettingsTile(
                        icon: Icons.info_outline,
                        iconColor: AppColors.textTertiary,
                        title: 'О приложении',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthLogoutRequested());
                      context.go(Routes.login);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentCoral,
                      side: const BorderSide(
                        color: AppColors.accentCoral,
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusCard,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Выйти из аккаунта',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
              ],
            );
          },
        ),
      ),
    );
  }
}
