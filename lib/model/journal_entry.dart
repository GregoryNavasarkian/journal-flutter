final String journal = 'journal';

class JournalFields {
  static final List<String> values = [id, title, body, rating];
  static final String id = '_id';
  static final String title = 'title';
  static final String body = 'body';
  static final String rating = 'rating';
}

class JournalEntry {
  final int? id;
  final String title;
  final String body;
  final int rating;

  const JournalEntry({
    this.id,
    required this.title,
    required this.body,
    required this.rating,
  });

  Map<String, Object?> toJson() => {
        JournalFields.id: id,
        JournalFields.title: title,
        JournalFields.body: body,
        JournalFields.rating: rating,
      };

  static JournalEntry fromJson(Map<String, Object?> json) => JournalEntry(
        id: json[JournalFields.id] as int?,
        title: json[JournalFields.title] as String,
        body: json[JournalFields.body] as String,
        rating: json[JournalFields.rating] as int,
      );

  JournalEntry copy({
    int? id,
    String? title,
    String? body,
    int? rating,
  }) =>
      JournalEntry(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        rating: rating ?? this.rating,
      );

}