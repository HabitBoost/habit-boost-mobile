import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_boost/features/journal/data/datasources/journal_remote_datasource.dart';
import 'package:habit_boost/features/journal/domain/entities/journal_entry.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: JournalRemoteDataSource)
class JournalFirestoreDataSource implements JournalRemoteDataSource {
  const JournalFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _journalCol(String userId) =>
      _firestore.collection('users').doc(userId).collection('journal');

  @override
  Future<List<JournalEntry>> getEntries(String userId) async {
    final snapshot =
        await _journalCol(userId).orderBy('date', descending: true).get();
    return snapshot.docs.map((doc) => _entryFromDoc(doc, userId)).toList();
  }

  @override
  Future<void> upsertEntry(JournalEntry entry, String userId) async {
    await _journalCol(userId).doc(entry.id).set(
          _entryToMap(entry),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> deleteEntry(String entryId, String userId) async {
    await _journalCol(userId).doc(entryId).delete();
  }

  JournalEntry _entryFromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    String userId,
  ) {
    final d = doc.data();
    return JournalEntry(
      id: doc.id,
      userId: userId,
      date: (d['date'] as Timestamp).toDate(),
      content: d['content'] as String? ?? '',
      mood: Mood.fromString(d['mood'] as String? ?? 'neutral'),
      tags: (d['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (d['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> _entryToMap(JournalEntry e) {
    return {
      'date': Timestamp.fromDate(e.date),
      'content': e.content,
      'mood': e.mood.name,
      'tags': e.tags,
      'createdAt': e.createdAt != null
          ? Timestamp.fromDate(e.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt':
          Timestamp.fromDate(e.updatedAt ?? DateTime.now()),
    };
  }
}
