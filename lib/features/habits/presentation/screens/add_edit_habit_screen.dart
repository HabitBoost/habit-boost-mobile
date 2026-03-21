import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_boost/app/di/injection_container.dart';
import 'package:habit_boost/app/router/routes.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/constants/app_strings.dart';
import 'package:habit_boost/features/habits/domain/entities/habit.dart';
import 'package:habit_boost/features/habits/presentation/bloc/habit_form_bloc.dart';
import 'package:habit_boost/features/habits/presentation/widgets/habit_icon.dart';

class AddEditHabitScreen extends StatelessWidget {
  const AddEditHabitScreen({this.habit, super.key});

  final Habit? habit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HabitFormBloc>()
        ..add(HabitFormInitialized(habit: habit)),
      child: _AddEditHabitView(isEditing: habit != null),
    );
  }
}

class _AddEditHabitView extends StatelessWidget {
  const _AddEditHabitView({required this.isEditing});

  final bool isEditing;

  static const _categories = [
    'Спорт',
    'Здоровье',
    'Продуктивность',
    'Ментальное здоровье',
    'Питание',
    'Обучение',
  ];

  static const _colors = [
    '#4CAF50',
    '#FF6B6B',
    '#6366F1',
    '#D97706',
    '#22C55E',
    '#EC4899',
    '#3B82F6',
    '#8B5CF6',
  ];

  static const _icons = [
    'dumbbell',
    'run',
    'water',
    'book',
    'meditation',
    'sleep',
    'food',
    'code',
    'music',
    'walk',
    'bike',
    'heart',
    'star',
    'pill',
    'brush',
    'plant',
    'sun',
    'write',
  ];

  static const _dayLabels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    return BlocListener<HabitFormBloc, HabitFormState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.status == HabitFormStatus.saved) {
          context.pop(true);
        }
        if (state.status == HabitFormStatus.deleted) {
          context.go(Routes.home);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isEditing ? AppStrings.editHabit : AppStrings.addHabit,
          ),
          actions: [
            if (isEditing)
              IconButton(
                onPressed: () => _confirmDelete(context),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.accentCoral,
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: BlocBuilder<HabitFormBloc, HabitFormState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field
                  const _SectionLabel(label: AppStrings.habitTitle),
                  const SizedBox(height: AppDimensions.paddingS),
                  TextFormField(
                    initialValue: state.title,
                    onChanged: (v) => context
                        .read<HabitFormBloc>()
                        .add(HabitFormTitleChanged(v)),
                    decoration: const InputDecoration(
                      hintText: 'Например: Утренняя пробежка',
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Icon picker
                  const _SectionLabel(label: 'Иконка'),
                  const SizedBox(height: AppDimensions.paddingS),
                  _buildIconPicker(context, state),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Color picker
                  const _SectionLabel(label: 'Цвет'),
                  const SizedBox(height: AppDimensions.paddingS),
                  _buildColorPicker(context, state),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Category chips
                  const _SectionLabel(label: 'Категория'),
                  const SizedBox(height: AppDimensions.paddingS),
                  _buildCategoryChips(context, state),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Day selector
                  const _SectionLabel(label: 'Дни недели'),
                  const SizedBox(height: AppDimensions.paddingS),
                  _buildDaySelector(context, state),

                  const SizedBox(height: AppDimensions.paddingL),

                  // Reminder toggle
                  _buildReminderSection(context, state),

                  const SizedBox(height: AppDimensions.paddingXL),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          state.status == HabitFormStatus.submitting
                              ? null
                              : () => context
                                  .read<HabitFormBloc>()
                                  .add(
                                    const HabitFormSubmitted(
                                      userId: 'local_user',
                                    ),
                                  ),
                      child: state.status == HabitFormStatus.submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(AppStrings.save),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingL),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIconPicker(
    BuildContext context,
    HabitFormState state,
  ) {
    final selectedColor = _parseColor(state.color);

    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: _icons.map((icon) {
        final isSelected = state.icon == icon;
        return GestureDetector(
          onTap: () => context
              .read<HabitFormBloc>()
              .add(HabitFormIconChanged(icon)),
          child: Container(
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(color: selectedColor, width: 2)
                  : null,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(2),
            child: HabitIcon(
              icon: icon,
              color: isSelected
                  ? selectedColor
                  : AppColors.textSecondary,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    HabitFormState state,
  ) {
    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: _colors.map((color) {
        final isSelected = state.color == color;
        final colorValue = _parseColor(color);
        return GestureDetector(
          onTap: () => context
              .read<HabitFormBloc>()
              .add(HabitFormColorChanged(color)),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorValue,
              borderRadius: BorderRadius.circular(10),
              border: isSelected
                  ? Border.all(
                      color: AppColors.textPrimary,
                      width: 3,
                    )
                  : null,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryChips(
    BuildContext context,
    HabitFormState state,
  ) {
    return Wrap(
      spacing: AppDimensions.paddingS,
      runSpacing: AppDimensions.paddingS,
      children: _categories.map((cat) {
        final isSelected = state.category == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (_) => context
              .read<HabitFormBloc>()
              .add(HabitFormCategoryChanged(cat)),
        );
      }).toList(),
    );
  }

  Widget _buildDaySelector(
    BuildContext context,
    HabitFormState state,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = index + 1;
        final isSelected = state.scheduleDays.contains(day);
        return GestureDetector(
          onTap: () => context
              .read<HabitFormBloc>()
              .add(HabitFormDayToggled(day)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.bgCard,
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusChip,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              _dayLabels[index],
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildReminderSection(
    BuildContext context,
    HabitFormState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Напоминание'),
          value: state.reminderEnabled,
          onChanged: (_) => context
              .read<HabitFormBloc>()
              .add(const HabitFormReminderToggled()),
        ),
        if (state.reminderEnabled)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Время'),
            trailing: Text(
              '${state.reminderHour.toString().padLeft(2, '0')}'
              ':${state.reminderMinute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay(
                  hour: state.reminderHour,
                  minute: state.reminderMinute,
                ),
              );
              if (time != null && context.mounted) {
                context.read<HabitFormBloc>().add(
                      HabitFormReminderTimeChanged(
                        hour: time.hour,
                        minute: time.minute,
                      ),
                    );
              }
            },
          ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteHabit),
        content: const Text(
          'Вы уверены, что хотите удалить эту привычку?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context
                  .read<HabitFormBloc>()
                  .add(const HabitFormDeleteRequested());
            },
            child: const Text(
              AppStrings.deleteHabit,
              style: TextStyle(color: AppColors.accentCoral),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
