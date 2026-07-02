import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppHeaderDash extends StatelessWidget {
  final String title;
  final String label;
  final String label2;
  final VoidCallback onPressed;
  // const AppHeaderDash({Key? key, this.title = 'Welcome Back!'}) : super(key: key);

  const AppHeaderDash({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
    required this.label2,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onPressed,
            child: Text(
              label2,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
