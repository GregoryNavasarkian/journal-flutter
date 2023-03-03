const String journal = 'journal_entries';

class JournalFields {
  static final List<String> values = [id, title, body, rating, date];
  static const String id = 'id';
  static const String title = 'title';
  static const String body = 'body';
  static const String rating = 'rating';
  static const String date = 'date';
}

class JournalEntry {
  final int? id;
  final String title;
  final String body;
  final int rating;
  final String date;

  const JournalEntry({
    this.id,
    required this.title,
    required this.body,
    required this.rating,
    required this.date,
  });

  Map<String, Object?> toJson() => {
        JournalFields.id: id,
        JournalFields.title: title,
        JournalFields.body: body,
        JournalFields.rating: rating,
        JournalFields.date: date,
      };
  
  static JournalEntry fromJson(Map<String, Object?> json) => JournalEntry(
        id: json[JournalFields.id] as int?,
        title: json[JournalFields.title] as String,
        body: json[JournalFields.body] as String,
        rating: json[JournalFields.rating] as int,
        date: json[JournalFields.date] as String,
      );

  JournalEntry copy({
    int? id,
    String? title,
    String? body,
    int? rating,
    String? date
  }) =>
      JournalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        rating: rating ?? this.rating,
        date: date ?? this.date,
      );

}