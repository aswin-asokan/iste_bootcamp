import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  late final DatabaseReference _dbRef;

  DatabaseService() {
    _dbRef = _firebaseDatabase.ref();
  }

  DatabaseReference get ref => _dbRef;

  Future<String> createTodo(
    String userId,
    Map<String, dynamic> taskData,
  ) async {
    DatabaseReference newTodoRef = _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .push();
    await newTodoRef.set(taskData);
    return newTodoRef.key!;
  }

  Future<void> updateTodo(
    String userId,
    String todoId,
    Map<String, dynamic> todoData,
  ) async {
    await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .child(todoId)
        .update(todoData);
  }

  Future<void> deleteTodo(String userId, String todoId) async {
    await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .child(todoId)
        .remove();
  }

  Future<List<Map<String, dynamic>>> getAllTodos(String userId) async {
    final snapshot = await _dbRef
        .child('users')
        .child(userId)
        .child('todos')
        .once();
    final data = snapshot.snapshot.value as Map?;

    if (data == null) return [];

    return data.entries.map((entry) {
      return {
        'key': entry.key,
        'task': entry.value['task'],
        'isChecked': entry.value['isChecked'],
      };
    }).toList();
  }
}
