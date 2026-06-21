import 'package:amlystuhub/core/widgets/retro_window_shell.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectGrade = 'Grade 10';
  bool _isApStudent = false;

  @override
  Widget build(BuildContext context) {
    return RetroWindowShell(
      title: 'REGISTRATION',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 90,
              height: 90,
              color: Colors.grey[300],
              child: Image.asset('assets/images/cat2.jpg', fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
