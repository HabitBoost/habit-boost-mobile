import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:habit_boost/features/journal/presentation/widgets/mood_selector.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({this.entry, super.key});

  final JournalEntry? entry;

  @override
  State<JournalEntryScreen> createState() =>
      _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  late final TextEditingController _contentController;
  late Mood _mood;
  late List<String> _tags;
  late DateTime _date;
  bool get _isEditing => widget.entry != null;

  static const _availableTags = [
    'Продуктивность',
    'Рефлексия',
    'Здоровье',
    'Спорт',
    'Учёба',
  ];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
    _mood = widget.entry?.mood ?? Mood.neutral;
    _tags = List<String>.from(widget.entry?.tags ?? []);
    _date = widget.entry?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_contentController.text.trim().isEmpty) return;

    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final entry = JournalEntry(
      id: widget.entry?.id ?? '',
      userId: authState.user.id,
      date: _date,
      content: _contentController.text.trim(),
      mood: _mood,
      tags: _tags,
      createdAt: widget.entry?.createdAt,
    );

    if (_isEditing) {
      context
          .read<JournalBloc>()
          .add(JournalEntryUpdated(entry: entry));
    } else {
      context
          .read<JournalBloc>()
          .add(JournalEntryCreated(entry: entry));
    }

    context.pop(true);
  }

  void _delete() {
    if (widget.entry == null) return;
    context
        .read<JournalBloc>()
        .add(JournalEntryDeleted(id: widget.entry!.id));
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Редактировать запись' : 'Новая запись',
        ),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: _delete,
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.accentCoral,
              ),
            ),
          TextButton(
            onPressed: _save,
            child: const Text('Сохранить'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          Text(
            'Как ваше настроение?',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          ),
          const SizedBox(height: 12),
          MoodSelector(
            selected: _mood,
            onChanged: (mood) => setState(() => _mood = mood),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'Что произошло сегодня?',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _contentController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Напишите о своём дне...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusCard,
                ),
                borderSide: BorderSide(
                  color: colors.borderSubtle,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusCard,
                ),
                borderSide: BorderSide(
                  color: colors.borderSubtle,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'Теги',
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final selected = _tags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _tags.add(tag);
                    } else {
                      _tags.remove(tag);
                    }
                  });
                },
                selectedColor:
                    AppColors.accentCoral.withValues(alpha: 0.15),
                checkmarkColor: AppColors.accentCoral,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
