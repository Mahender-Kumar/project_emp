import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/services/generate_tags.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  final String todosCollection = "todos";
  final String trashCollection = "deleted_todos";

  /// 🔹 Add a new to-do
  Future<void> addTodo(Employee todo, {List? tags}) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    await _firestore.collection("users").doc(user.uid).collection("todos").add({
      ...todo.toMap(),
      'tags': tags ?? [],
    });
  }

  /// 🔹 Edit an existing to-do
  Future<void> saveEmployee(Employee todo, {List? tags}) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(todosCollection)
        .doc(todo.id)
        .set({...todo.toMap(), 'tags': tags ?? []}, SetOptions(merge: true));
  }

  /// 🔹 Mark a to-do as done or undone
  Future<void> toggleTodoStatus(String todoId, bool isDone) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(todosCollection)
        .doc(todoId)
        .update({
          'isCompleted': isDone,
          'updatedAt': Timestamp.now(),
          'timestamp': Timestamp.now(),
        });
  }

  /// 🔹 Move a to-do to trash (soft delete)
  Future<void> moveToTrash(Employee todo) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(trashCollection)
        .doc(todo.id)
        .set({...todo.toMap()});
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(todosCollection)
        .doc(todo.id)
        .delete();
  }

  /// 🔹 Get active to-dos (not deleted)
  Stream<List<Map<String, dynamic>>> getCurrentEmployees() {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return _firestore
        .collection("employees")
        .where('status', isEqualTo: 'hired')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList(),
        );
  }
  Stream<List<Map<String, dynamic>>> getPreviousEmployees() {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return _firestore
        .collection("employees")
        .where('status', isEqualTo: 'left')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList(),
        );
  }

  /// 🔹 Retrieve all deleted todos from Firestore
  Stream<List<Map<String, dynamic>>> getDeletedTodos() {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return _firestore
        .collection("users")
        .doc(user.uid)
        .collection(trashCollection)
        .orderBy('deletedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList(),
        );
  }

  /// 🔹 Restore a deleted to-do (move back to active todos)
  Future<void> restoreDeletedTodo(Employee todo) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(todosCollection)
        .doc(todo.id)
        .set({...todo.toMap()});
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(trashCollection)
        .doc(todo.id)
        .delete();
  }

  /// 🔹 Permanently delete a to-do from trash
  Future<void> deletePermanently(String todoId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore
        .collection("users")
        .doc(user.uid)
        .collection(trashCollection)
        .doc(todoId)
        .delete();
  }

  /// 🔹 Clear all deleted todos
  Future<void> clearTrash() async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    final batch = _firestore.batch();
    final querySnapshot =
        await _firestore
            .collection("users")
            .doc(user.uid)
            .collection(trashCollection)
            .get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<Map<String, dynamic>>> searchTodos(String input) {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    final tags = generateTags(input);

    Query query = _firestore
        .collection("users")
        .doc(user.uid)
        .collection(todosCollection);

    // If input is empty, return all todos (limit to 10)
    if (input.isEmpty || tags.isEmpty) {
      query = query.limit(10);
    } else {
      query = query.where('tags', arrayContainsAny: tags);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => {
                  'id': doc.id,
                  ...(doc.data() as Map<String, dynamic>), // Explicit cast
                },
              )
              .toList(),
    );
  }

  Stream<List<Map<String, dynamic>>> fetchHistory(DateTime selectedDay) {
    return _firestore
        .collection('users/${AuthService().currentUser!.uid}/todos')
        .where('isCompleted', isEqualTo: true)
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day),
          ),
        )
        .where(
          'timestamp',
          isLessThan: Timestamp.fromDate(
            DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1),
          ),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
