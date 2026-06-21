import 'package:amlystuhub/features/auth/presentation%20/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:amlystuhub/core/widgets/retro_window_shell.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedGrade = 'Grade 10';
  bool _isApStudent = false;

  // Dedicated custom active colors for each specific grade card
  final Map<String, Color> _gradeColors = {
    'Grade 9': const Color(0xFFFDE49E), // Retro Soft Yellow
    'Grade 10': const Color(0xFFAED6F1), // Classic Pastel Blue
    'Grade 11': const Color(0xFFF5C0C0), // Soft Pink
    'Grade 12': const Color(0xFFA9DFBF), // Muted Green
  };

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

    return RetroWindowShell(
      title: 'REGISTRATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Cat Photo Asset + Core Form Inputs
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Your CRT Cat Asset Block
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 175,
                  height: 175,
                  color: Colors.grey[300],
                  child: Image.asset(
                    'assets/cat2.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, _, __) =>
                        const Icon(Icons.computer, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Name and Email Inputs
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('▶ Name:_'),
                    _buildInputField(
                      controller: _nameController,
                      hintText: '[Enter Full Name....]',
                      icon: const Text('⌨️', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 12),
                    _buildInputLabel('▶ Email:_'),
                    _buildInputField(
                      controller: _emailController,
                      hintText: '[Enter Email....]',
                      icon: const Text('💾', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 12),

                    _buildInputLabel('▶ Password:_'),
                    _buildInputField(
                      controller: _passwordController,
                      hintText: '[Enter Password....]',
                      obscureText: true,
                      icon: const Text('🔑', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Row 2: Balanced Grade Track Layout + Split AP Choice Parameters
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Academic Track Grid Selection Zone with Unique Colors
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('▼ Academic_Track_:'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: ['Grade 9', 'Grade 10', 'Grade 11', 'Grade 12']
                          .map((grade) {
                            final isSelected = _selectedGrade == grade;
                            // Pull unique color if active, otherwise fallback to flat clean white
                            final activeColor =
                                _gradeColors[grade] ?? theme.primaryColor;

                            return InkWell(
                              onTap: () =>
                                  setState(() => _selectedGrade = grade),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
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
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          })
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // AP Student Selector Split into Left (YES) & Right (NO)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputLabel('▼ AP Student?'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Left Side: YES Option
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isApStudent = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
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
                          // Right Side: NO Option
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isApStudent = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
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

          const SizedBox(height: 24),

          // Primary Submission Trigger Button
          InkWell(
            onTap: () {
              // Your custom authentication or registration processing logic here
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // View Toggle Route Action
          Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignIn()),
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 13),
                  children: [
                    TextSpan(text: 'Bitch you have an account? '),
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
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required Widget icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            child: icon,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
