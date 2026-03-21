import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.name = '',
    this.goals = const [],
    this.onboardingCompleted = false,
  });

  final String id;
  final String email;
  final String name;
  final List<String> goals;
  final bool onboardingCompleted;

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    List<String>? goals,
    bool? onboardingCompleted,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      goals: goals ?? this.goals,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props => [id, email, name, goals, onboardingCompleted];
}
