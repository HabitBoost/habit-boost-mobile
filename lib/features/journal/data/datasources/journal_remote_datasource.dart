import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';

abstract class JournalRemoteDataSource {
  Future<List<JournalEntry>> getEntries(String userId);
  Future<void> upsertEntry(JournalEntry entry, String userId);
  Future<void> deleteEntry(String entryId, String userId);
}
