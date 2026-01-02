class Todo {
  final int id;
  final String title;
  final bool completed;
  final bool isSynced; 

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    this.isSynced = true,
  });

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
    bool? isSynced,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'completed': completed ? 1 : 0,
    'is_synced': isSynced ? 1 : 0,
  };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    id: map['id'],
    title: map['title'],
    completed: map['completed'] == 1,
    isSynced: map['is_synced'] == 1,
  );
}
