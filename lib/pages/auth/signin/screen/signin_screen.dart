import 'package:exchange_customer/core/components/app_button.dart';
import 'package:exchange_customer/core/components/app_snackbar.dart';
import 'package:exchange_customer/core/components/app_text.dart';
import 'package:exchange_customer/core/components/app_text_form_field.dart';
import 'package:exchange_customer/core/constants/colors.dart';
import 'package:exchange_customer/core/constants/images.dart';
import 'package:exchange_customer/l10n/app_localizations.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_cubit.dart';
import 'package:exchange_customer/pages/auth/signin/cubit/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocListener<SigninCubit, SigninState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (_) {
            context.go('/home');
          },
          error: (e) {
            AppSnackbar.showError(context, e);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: context.read<SigninCubit>().formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section
                        _buildLogoSection(),

                        const SizedBox(height: 32),

                        // Welcome Text
                        _buildWelcomeSection(t!),
                        const SizedBox(height: 40),

                        // Form Fields
                        _buildFormSection(t),

                        const SizedBox(height: 12),

                        // Forgot Password
                        _buildForgotPasswordButton(t),

                        const SizedBox(height: 24),

                        // Sign In Button
                        _buildSignInButton(t),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.kSecondColorDarkMode,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.kPrimaryColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset(
            AppImages.klogo,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.wifi_tethering,
              size: 60,
              color: AppColors.kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(AppLocalizations t) {
    return Column(
      children: [
        AppText(t.welcome_back, fontSize: 28, fontWeight: FontWeight.w700),
        const SizedBox(height: 8),
        AppText(
          t.signin_subtitle,
          fontSize: 14,
          color: AppColors.kGreyColor,
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildFormSection(AppLocalizations t) {
    return Column(
      children: [
        // Username Field
        AppTextFormField(
          label: t.username,
          controller: context.read<SigninCubit>().emailController,
          icon: Icons.person_outline_rounded,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.username_required;
            }
            return null;
          },
        ),

        const SizedBox(height: 8),

        // Password Field
        AppTextFormField(
          label: t.password,
          controller: context.read<SigninCubit>().passwordController,
          icon: Icons.lock_outline_rounded,
          // obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.visibility_off_outlined,
              color: AppColors.kPrimaryColor,
            ),
            onPressed: () {
              // setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return t.password_required;
            }
            if (value.length < 6) {
              return t.password_min_length;
            }
            return null;
          },
          // onFieldSubmitted: (_) => _handleSignIn(),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton(AppLocalizations t) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () {
          // TODO: Navigate to forgot password
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: AppText(
          t.forgot_password,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.kPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildSignInButton(AppLocalizations t) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: t.signin,
        onPressed: () {
          context.read<SigninCubit>().signin();
        },
        isLoading: context.watch<SigninCubit>().state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        ),
        // isLoading: _isLoading,
        icon: Icons.login_rounded,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
