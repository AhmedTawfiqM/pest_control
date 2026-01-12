import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/language_switcher.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginEvent(
              _emailController.text.trim(),
              _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppConstants.dashboardRoute);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Language Switcher at top
                      const LanguageSwitcher(),
                      const SizedBox(height: 32),

                      // Logo/Icon
                      Icon(
                        Icons.pest_control,
                        size: 100,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        l10n.appName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Field Operations',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      CustomTextField(
                        controller: _emailController,
                        label: l10n.email,
                        hint: 'Enter your email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      CustomTextField(
                        controller: _passwordController,
                        label: l10n.password,
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                l10n.login,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.dontHaveAccount + ' '),
                          TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.of(context)
                                        .pushNamed(AppConstants.registerRoute);
                                  },
                            child: Text(l10n.register),
                          ),
                        ],
                      ),

                      // Demo credentials hint
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline,
                                    size: 16,
                                    color: Colors.blue[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Demo Credentials',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Email: admin@pestcontrol.com',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 16),
                                  onPressed: () {
                                    final email = 'admin@pestcontrol.com';
                                    Clipboard.setData(ClipboardData(text: email));
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  color: Colors.blue[700],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Password: password123',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.copy, size: 16),
                                  onPressed: () {
                                    final password = 'password123';
                                    Clipboard.setData(ClipboardData(text: password));
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  color: Colors.blue[700],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

