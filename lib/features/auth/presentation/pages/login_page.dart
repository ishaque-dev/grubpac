import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/core/utils/app_validators.dart';
import 'package:grubpac/core/widgets/app_snackbar.dart';
import 'package:grubpac/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnackbar.showError(context, state.message);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    AppUiStrings.appName,
                    style: AppText.display(size: 44.sp, color: AppColors.lime),
                  ),
                  Text(
                    AppUiStrings.tagline,
                    style: AppText.mono(
                      size: 12.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  Text(
                    AppUiStrings.signIn,
                    style: AppText.display(size: 28.sp),
                  ),
                  SizedBox(height: 24.h),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: AppUiStrings.emailAddress,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    style: AppText.body(),
                    validator: AppValidators.emailValidator,
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: AppUiStrings.password,
                    ),
                    obscureText: true,
                    style: AppText.body(),
                    validator: AppValidators.passwordValidator,
                  ),
                  const Spacer(),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading ? null : _onLogin,
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.bg,
                                  ),
                                )
                              : const Text(AppUiStrings.login),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppUiStrings.forgotPassword,
                        style: AppText.mono(
                          size: 11.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
