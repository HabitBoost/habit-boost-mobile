import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum Mood {
  great(Icons.sentiment_very_satisfied, 'Отлично'),
  good(Icons.sentiment_satisfied, 'Хорошо'),
  neutral(Icons.sentiment_neutral, 'Нормально'),
  bad(Icons.sentiment_dissatisfied, 'Плохо'),
  terrible(Icons.sentiment_very_dissatisfied, 'Ужасно');

  const Mood(this.icon, this.label);

  final IconData icon;
  final String label;

  static Mood fromString(String value) {
    return Mood.values.firstWhere(
      (m) => m.name == value,
      orElse: () => Mood.neutral,
    );
  }
}

class JournalEntry extends Equatable {
  const JournalEntry({
    required this.id,
    required this.userId,
    required this.date,
    required this.content,
    this.mood = Mood.neutral,
    this.tags = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final DateTime date;
  final String content;
  final Mood mood;
  final List<String> tags;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JournalEntry copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? content,
    Mood? mood,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        content,
        mood,
        tags,
        createdAt,
        updatedAt,
      ];
}
