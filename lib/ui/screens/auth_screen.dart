import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../core/utils/helpers.dart';
import '../../logic/blocs/auth/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.loading) {
          AppDialogs.showLoading(context);
        } else {
          AppDialogs.hideLoading(context);

          if (state.status == AuthStatus.error) {
            AppDialogs.showToast(
              state.error.toString(),
              ToastificationType.error,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isLogin ? 'Kirish' : 'Ro\'yxatdan O\'tish'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: state.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: state.emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'To\'g\'ri elekron pochta kiriting';
                      }
                      return null;
                    },
                  ),
                  if (!state.isLogin)
                    TextFormField(
                      controller: state.fullNameController,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ismingizni kiriting';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    controller: state.passwordController,
                    decoration: const InputDecoration(labelText: 'Parol'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 6) {
                        return 'Eng kamida 6 ta element kiriting';
                      }
                      return null;
                    },
                  ),
                  if (!state.isLogin)
                    TextFormField(
                      controller: state.passwordConfirmController,
                      decoration: const InputDecoration(
                          labelText: 'Parolni tasdiqlang'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value != state.passwordController!.text) {
                          return 'Parollar mos kelamdi';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthenticateEvent());
                    },
                    child:
                        Text(state.isLogin ? 'Kirish' : 'Ro\'yxatdan O\'tish'),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(ToggleLoginFormEvent());
                    },
                    child: Text(state.isLogin
                        ? 'Ro\'yxatdan o\'tish'
                        : 'Tizimga kirish'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
