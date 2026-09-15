import 'package:amlystuhub/features/event_management/presentation/controllers/bbq_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BbqFinanceCards extends ConsumerWidget {
  const BbqFinanceCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(bbqFinanceMetricsProvider);

    return metricsAsync.when(
      data: (metrics) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Total RSVPs',
                  value: '${metrics.totalRsvps}',
                  subtitle:
                      '${metrics.chickenCount} Chk | ${metrics.meatCount} Meat',
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Projected Net Profit',
                  value: '${metrics.projectedNetProfit.toStringAsFixed(1)} LYD',
                  subtitle:
                      'Gross: ${metrics.maxProjectedRevenue.toStringAsFixed(1)} LYD',
                  color: metrics.projectedNetProfit >= 0
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Est. Revenue (80%)',
                  value:
                      '${metrics.estimatedRevenue80Percent.toStringAsFixed(1)} LYD',
                  subtitle: 'Conservative turn-out',
                  color: Colors.amber.shade800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  title: 'Upfront Expense',
                  value: '${metrics.upfrontExpense.toStringAsFixed(1)} LYD',
                  subtitle: 'Investment budget',
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error computing metrics: $err',
            style: TextStyle(color: Colors.red.shade900),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
