import 'package:amlystuhub/core/widgets/retro_window_shell.dart';
import 'package:amlystuhub/features/auth/presentation%20/controllers/auth_controllers.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/dashboard/presentation/screens%20/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amlystuhub/core/widgets/input_field.dart';
import 'package:amlystuhub/core/widgets/primary_button.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _loginUser() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all validation access fields.'),
        ),
      );
      return;
    }
    ref.read(authStateProvider.notifier).login(email, password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthState.loading();

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(authStateProvider.notifier).resetState();
      } else if (next.status == AuthStatus.authenticated) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('WELCOME BACK!')));
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Dashboard()));
      }
    });
    // UI
    return RetroWindowShell(
      title: 'Welcome Back, Login',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 700;
                final imageSize = isSmall ? 140.0 : 210.0;

                final imageWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[300],
                    child: Image.asset(
                      'assets/cat2.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) =>
                          const Icon(Icons.computer, size: 40),
                    ),
                  ),
                );

                final formColumn = Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SYSTEM ACCESS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Please authenticate via your authorized @stu.amly.us credentials to initialize connection.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      _buildInputLabel('▶ Email:_'),
                      _buildInputField(
                        controller: _emailController,
                        hintText: '[Enter Your Email]',
                        icon: const Text('💾', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 35),
                      _buildInputLabel('▶ Password:_'),
                      _buildInputField(
                        controller: _passwordController,
                        hintText: '[Enter Password....]',
                        obscureText: true,
                        icon: const Text('🔑', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );

                if (isSmall) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageWidget,
                      const SizedBox(height: 12),
                      formColumn,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    imageWidget,
                    const SizedBox(width: 20),
                    formColumn,
                  ],
                );
              },
            ),
            SizedBox(height: 50),
            PrimaryButton(
              label: isLoading ? 'AUTHENTICATING...' : 'Login',
              onPressed: isLoading ? null : _loginUser,
              width: double.infinity,
            ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () => context.go('/signup'),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: const [
                      TextSpan(text: "You don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Build Input
  Widget _buildInputLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );
  // Custom Field Input
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required Widget icon,
    bool obscureText = false,
  }) => InputField(
    controller: controller,
    hintText: hintText,
    icon: icon,
    obscureText: obscureText,
  );
}
