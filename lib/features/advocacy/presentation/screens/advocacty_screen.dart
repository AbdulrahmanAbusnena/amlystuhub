import 'package:amlystuhub/features/advocacy/presentation/state/advocacy_controller.dart';
import 'package:amlystuhub/features/advocacy/presentation/widgets/advocacy_header.dart';
import 'package:amlystuhub/features/advocacy/presentation/widgets/survey_card.dart';
import 'package:amlystuhub/features/auth/domain/models%20/user_role.dart';
import 'package:amlystuhub/features/auth/presentation%20/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/advocacy_models.dart';
import '../widgets/ticket_card.dart';

class AdvocacyHubScreen extends ConsumerWidget {
  const AdvocacyHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserModelProvider);
    final user = userAsync.value;

    final isLeadership = user != null && user.role == UserRole.stuCoAdmin;

    final surveysAsync = isLeadership
        ? ref.watch(allSurveysStreamProvider)
        : ref.watch(activeSurveysStreamProvider);

    final ticketsAsync = isLeadership
        ? ref.watch(allTicketsStreamProvider)
        : ref.watch(userTicketsStreamProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 900 ? 32.0 : 20.0;
            final isWide = constraints.maxWidth >= 900;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          32,
                          horizontalPadding,
                          16,
                        ),
                        child: AdvocacyHeader(isLeadership: isLeadership),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: _SurveysSection(
                                      surveysAsync: surveysAsync,
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  Expanded(
                                    flex: 4,
                                    child: _MyTicketsSection(
                                      ticketsAsync: ticketsAsync,
                                      isLeadershipView: isLeadership,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  _SurveysSection(surveysAsync: surveysAsync),
                                  const SizedBox(height: 32),
                                  _MyTicketsSection(
                                    ticketsAsync: ticketsAsync,
                                    isLeadershipView: isLeadership,
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SurveysSection extends StatelessWidget {
  final AsyncValue<List<SurveyModel>> surveysAsync;

  const _SurveysSection({required this.surveysAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Active Surveys',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 16),
        surveysAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => Text(
            'Failed to load surveys: $err',
            style: TextStyle(color: colorScheme.error),
          ),
          data: (surveys) {
            if (surveys.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'No active Google Form surveys right now.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: surveys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  SurveyCard(survey: surveys[index]),
            );
          },
        ),
      ],
    );
  }
}

class _MyTicketsSection extends StatelessWidget {
  final AsyncValue<List<TicketModel>> ticketsAsync;
  final bool isLeadershipView;

  const _MyTicketsSection({
    required this.ticketsAsync,
    required this.isLeadershipView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isLeadershipView
                  ? 'All Concerns & Reports'
                  : 'My Concerns & Reports',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: colorScheme.outlineVariant)),
          ],
        ),
        const SizedBox(height: 16),
        ticketsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, _) => Text(
            'Failed to load reports: $err',
            style: TextStyle(color: colorScheme.error),
          ),
          data: (tickets) {
            if (tickets.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    isLeadershipView
                        ? 'No submitted concerns found.'
                        : 'You have not submitted any concerns yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => TicketCard(
                ticket: tickets[index],
                isLeadershipView: isLeadershipView,
              ),
            );
          },
        ),
      ],
    );
  }
}
