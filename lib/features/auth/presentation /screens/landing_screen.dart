import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingScreen extends ConsumerStatefulWidget {
  const LandingScreen({super.key});

  @override
  ConsumerState<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends ConsumerState<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(child: Column(children: [

          ],
        )),
    );
  }

  Widget _buildheader(BuildContext, context) {
    return Container();
  }

  Widget _buildbody(BuildContext, context) {
    return Container();
  }

  Widget _buidfooter(BuildContext, context) {
    return Container();
  }
}
