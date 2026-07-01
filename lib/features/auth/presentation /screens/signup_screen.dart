import 'package:amlystuhub/core/widgets/retro_window_shell.dart';
import 'package:amlystuhub/features/auth/presentation%20/controllers/auth_controllers.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:amlystuhub/core/widgets/input_field.dart';
import 'package:amlystuhub/core/widgets/primary_button.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Default Data
  String _selectedGrade = 'Grade 10';
  bool _isApStudent = false;

  // Grading List
  final Map<String, Color> _gradeColors = {
    'Grade 9': const Color(0xFFFDE49E),
    'Grade 10': const Color(0xFFAED6F1),
    'Grade 11': const Color(0xFFF5C0C0),
    'Grade 12': const Color(0xFFA9DFBF),
  };

  int _parseGradeLevel(String gradeString) {
    final numericString = gradeString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString) ?? 10;
  }

  // Registration logic
  void _registerUser() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate that text inputs aren't empty before transmission
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all terminal security fields.'),
        ),
      );
      return;
    }

    ref
        .read(authStateProvider.notifier)
        .register(
          name,
          email,
          password,
          _parseGradeLevel(_selectedGrade),
          _isApStudent,
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Auth controller setup
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
        ref.read(authStateProvider.notifier).resetState();
      }
    });

    return RetroWindowShell(
      title: 'REGISTRATION',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isSmall = constraints.maxWidth < 800;
                final imageSize = isSmall ? 140.0 : 180.0;

                final imageWidget = ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[300],
                    child: Image.asset(
                      'assets/cat1.webp',
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, _) =>
                          const Icon(Icons.computer, size: 40),
                    ),
                  ),
                );

                final formColumn = Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('▶ Name:_'),
                      _buildInputField(
                        controller: _nameController,
                        hintText: '[Enter Full Name....]',
                        icon: const Text('⌨️', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 18),
                      _buildInputLabel('▶ Email:_'),
                      _buildInputField(
                        controller: _emailController,
                        hintText: '[Enter Email....]',
                        icon: const Text('💾', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      _buildInputLabel('▶ Password:_'),
                      _buildInputField(
                        controller: _passwordController,
                        hintText: '[Enter Password....]',
                        obscureText: true,
                        icon: const Text('🔑', style: TextStyle(fontSize: 16)),
                      ),
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
                    imageWidget,
                    const SizedBox(width: 20),
                    formColumn,
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('▼ Academic_Track_:'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'].map(
                              (grade) {
                                final isSelected = _selectedGrade == grade;
                                final activeColor =
                                    _gradeColors[grade] ?? theme.primaryColor;

                                return InkWell(
                                  onTap: isLoading
                                      ? null
                                      : () => setState(
                                          () => _selectedGrade = grade,
                                        ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? activeColor
                                          : Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      grade,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputLabel('▼ AP Student?'),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: isLoading
                                    ? null
                                    : () => setState(() => _isApStudent = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isApStudent
                                        ? const Color(0xFFA9DFBF)
                                        : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    border: const Border(
                                      right: BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: isLoading
                                    ? null
                                    : () =>
                                          setState(() => _isApStudent = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !_isApStudent
                                        ? const Color(0xFFF5C0C0)
                                        : Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            PrimaryButton(
              label: isLoading ? 'INITIALIZING...' : 'Sign Up',
              onPressed: isLoading ? null : _registerUser,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () => context.go('/login'),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: const [
                      TextSpan(text: 'You have an account? '),
                      TextSpan(
                        text: 'Login',
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

  Widget _buildInputLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
    ),
  );

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
