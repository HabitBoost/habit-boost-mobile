import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/sync/sync_service.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/core/utils/validators.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/auth/presentation/widgets/auth_field.dart';
import 'package:habit_boost/features/auth/presentation/widgets/logo_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          } else if (state is Authenticated) {
            await sl<SyncService>()
                .pullAndMerge(state.user.id);
            if (!context.mounted) return;
            context.go(Routes.home);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: 40,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const LogoHeader(),
                  const SizedBox(height: AppDimensions.paddingL),
                  Text(
                    l10n.authLoginTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: colors.textPrimary),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  AuthField(
                    label: l10n.authEmail,
                    hint: l10n.authEmailHint,
                    controller: _emailController,
                    validator: (v) =>
                        Validators.email(v, l10n),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  AuthField(
                    label: l10n.authPassword,
                    hint: '••••••••',
                    controller: _passwordController,
                    validator: (v) =>
                        Validators.password(v, l10n),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onLogin(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return _CoralButton(
                        label: l10n.authLogin,
                        isLoading: isLoading,
                        onPressed: _onLogin,
                      );
                    },
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  TextButton(
                    onPressed: () => context.push(Routes.forgotPassword),
                    child: Text(l10n.authForgotPassword),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  _buildDivider(colors),
                  const SizedBox(height: AppDimensions.paddingM),
                  _GreenOutlineButton(
                    label: l10n.authRegisterTitle,
                    onPressed: () => context.push(Routes.register),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(AppColorsTheme colors) {
    return Row(
      children: [
        Expanded(child: Divider(color: colors.borderSubtle)),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
          child: Text(
            context.l10n.authOr,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: colors.textTertiary),
          ),
        ),
        Expanded(child: Divider(color: colors.borderSubtle)),
      ],
    );
  }
}

class _CoralButton extends StatelessWidget {
  const _CoralButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accentCoral,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class _GreenOutlineButton extends StatelessWidget {
  const _GreenOutlineButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
