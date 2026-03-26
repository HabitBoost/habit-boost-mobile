import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/extensions/l10n_extension.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';
import 'package:habit_boost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:habit_boost/features/journal/presentation/bloc/journal_bloc.dart';
import 'package:habit_boost/features/journal/presentation/widgets/mood_selector.dart';
import 'package:habit_boost/l10n/app_localizations.dart';

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

  static const _tagKeys = [
    'productivity',
    'reflection',
    'health',
    'sport',
    'learning',
  ];

  static String _tagLabel(String key, AppLocalizations l10n) {
    switch (key) {
      case 'productivity':
        return l10n.tagProductivity;
      case 'reflection':
        return l10n.tagReflection;
      case 'health':
        return l10n.tagHealth;
      case 'sport':
        return l10n.tagSport;
      case 'learning':
        return l10n.tagLearning;
      default:
        return key;
    }
  }

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
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.journalEditEntry : l10n.journalNewEntryTitle,
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
            child: Text(l10n.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          Text(
            l10n.journalMoodQuestion,
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
            l10n.journalContentQuestion,
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
              hintText: l10n.journalContentHint,
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
            l10n.journalTags,
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tagKeys.map((key) {
              final selected = _tags.contains(key);
              return FilterChip(
                label: Text(_tagLabel(key, l10n)),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    if (v) {
                      _tags.add(key);
                    } else {
                      _tags.remove(key);
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
