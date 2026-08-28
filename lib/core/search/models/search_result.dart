import 'package:flutter/material.dart';

enum SearchCategory {
  announcement('Announcements', Icons.campaign_outlined),
  academic('Academic Hub', Icons.school_outlined),
  advocacy('Advocacy & Surveys', Icons.how_to_vote_outlined),
  schedule('Schedule & Events', Icons.calendar_today_outlined);

  final String label;
  final IconData icon;
  const SearchCategory(this.label, this.icon);
}

class SearchResult {
  final String id;
  final String title;
  final String snippet;
  final SearchCategory category;
  final VoidCallback onTap;

  SearchResult({
    required this.id,
    required this.title,
    required this.snippet,
    required this.category,
    required this.onTap,
  });
}
