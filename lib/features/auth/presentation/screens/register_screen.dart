import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/core/utils/validators.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/auth/presentation/widgets/auth_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(context.l10n.authAcceptTerms),
          ),
        );
      return;
    }
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            name: _nameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    final l10n = context.l10n;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message)),
              );
          } else if (state is Authenticated) {
            context.go(Routes.onboarding);
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
                  Text(
                    l10n.authRegisterTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(
                          color: colors.textPrimary,
                        ),
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingL,
                  ),
                  AuthField(
                    label: l10n.authName,
                    hint: l10n.authNameHint,
                    controller: _nameController,
                    validator: (v) => Validators.required(
                      v,
                      l10n,
                      l10n.authName,
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingM,
                  ),
                  AuthField(
                    label: l10n.authEmail,
                    hint: l10n.authEmailHint,
                    controller: _emailController,
                    validator: (v) =>
                        Validators.email(v, l10n),
                    keyboardType:
                        TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingM,
                  ),
                  AuthField(
                    label: l10n.authPassword,
                    hint: '\u2022\u2022\u2022\u2022'
                        '\u2022\u2022\u2022\u2022',
                    controller: _passwordController,
                    validator: (v) =>
                        Validators.password(v, l10n),
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword =
                            !_obscurePassword,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingM,
                  ),
                  AuthField(
                    label: l10n.authConfirmPassword,
                    hint: '\u2022\u2022\u2022\u2022'
                        '\u2022\u2022\u2022\u2022',
                    controller: _confirmPasswordController,
                    validator: (v) =>
                        Validators.confirmPassword(
                      v,
                      _passwordController.text,
                      l10n,
                    ),
                    obscureText: _obscureConfirm,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onRegister(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: colors.textTertiary,
                        size: 20,
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirm =
                            !_obscureConfirm,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingL,
                  ),
                  _buildTermsCheckbox(colors),
                  const SizedBox(
                    height: AppDimensions.paddingL,
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: isLoading
                              ? null
                              : _onRegister,
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  l10n.authRegister,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: AppDimensions.paddingM,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authHaveAccount,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color: colors.textSecondary,
                            ),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          l10n.authLogin,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color:
                                    AppColors.accentCoral,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(AppColorsTheme colors) {
    return GestureDetector(
      onTap: () =>
          setState(() => _agreedToTerms = !_agreedToTerms),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _agreedToTerms
                  ? AppColors.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: _agreedToTerms
                  ? null
                  : Border.all(
                      color: colors.borderEmpty,
                      width: 2,
                    ),
            ),
            child: _agreedToTerms
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              context.l10n.authAgreeTerms,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(
                    color: colors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
