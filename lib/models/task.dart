class Task {
  int? id;
  String title;
  String description;
  String deadline;
  bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      deadline: map['deadline'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}