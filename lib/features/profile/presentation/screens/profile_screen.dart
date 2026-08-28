import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:amlystuhub/features/profile/domain/models/profile_models.dart';
import 'package:amlystuhub/features/profile/presentation/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  int? _selectedGrade;
  bool? _selectedIsAp;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserModelProvider);
    final userRequestsAsync = ref.watch(userProfileRequestsProvider);
    final profileState = ref.watch(profileControllerProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Account Profile')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (user) {
          if (user == null)
            return const Center(child: Text('User session expired.'));

          _selectedGrade ??= user.gradeLevel;
          _selectedIsAp ??= user.isApStudent;
          if (_nameController.text.isEmpty) {
            _nameController.text = user.name;
          }

          final hasPendingRequest =
              userRequestsAsync.value?.any(
                (r) => r.status == ProfileRequestStatus.pending,
              ) ??
              false;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // General Profile Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        label: Text('Role: ${user.role.name}'),
                        backgroundColor: colorScheme.secondaryContainer,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Direct Editable Details: Name & Password
              const Text(
                'Personal Info',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: profileState.isLoading
                    ? null
                    : () async {
                        final success = await ref
                            .read(profileControllerProvider.notifier)
                            .updateName(_nameController.text);
                        if (context.mounted && success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Name updated successfully.'),
                            ),
                          );
                        }
                      },
                child: const Text('Update Name'),
              ),
              const Divider(height: 32),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: profileState.isLoading
                    ? null
                    : () async {
                        if (_passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password must be at least 6 characters.',
                              ),
                            ),
                          );
                          return;
                        }
                        final success = await ref
                            .read(profileControllerProvider.notifier)
                            .updatePassword(_passwordController.text);
                        if (context.mounted && success) {
                          _passwordController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password updated successfully.'),
                            ),
                          );
                        }
                      },
                child: const Text('Update Password'),
              ),
              const Divider(height: 32),

              // Restricted Academic Information (Requires StuCo Admin Approval)
              const Text(
                'Academic Details (Requires Admin Approval)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _selectedGrade,
                decoration: const InputDecoration(
                  labelText: 'Grade Level',
                  border: OutlineInputBorder(),
                ),
                items: [9, 10, 11, 12].map((g) {
                  return DropdownMenuItem(value: g, child: Text('Grade $g'));
                }).toList(),
                onChanged: hasPendingRequest
                    ? null
                    : (val) => setState(() => _selectedGrade = val),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Enrolled in AP Courses'),
                value: _selectedIsAp!,
                onChanged: hasPendingRequest
                    ? null
                    : (val) => setState(() => _selectedIsAp = val),
              ),
              const SizedBox(height: 12),
              if (hasPendingRequest)
                Card(
                  color: Colors.amberAccent,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'You have a pending change request under review by StuCo Leadership.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: profileState.isLoading
                      ? null
                      : () async {
                          if (_selectedGrade == user.gradeLevel &&
                              _selectedIsAp == user.isApStudent) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No changes detected.'),
                              ),
                            );
                            return;
                          }

                          final success = await ref
                              .read(profileControllerProvider.notifier)
                              .requestAcademicDetailsChange(
                                newGradeLevel: _selectedGrade!,
                                newIsApStudent: _selectedIsAp!,
                              );

                          if (context.mounted && success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Request submitted to StuCo Leadership.',
                                ),
                              ),
                            );
                          }
                        },
                  child: const Text('Request Academic Changes'),
                ),
            ],
          );
        },
      ),
    );
  }
}
