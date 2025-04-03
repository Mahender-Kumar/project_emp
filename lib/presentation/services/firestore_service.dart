import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/services/generate_tags.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// 🔹 Edit an existing to-do
  Future<void> saveEmployee(Employee employee, {List? tags}) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    await _firestore.collection("employees").doc(employee.id).set({
      ...employee.toMap(),
      'tags': tags ?? [],
    }, SetOptions(merge: true));
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
        .orderBy('deletedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList(),
        );
  }
  // /// 🔹 Restore a deleted to-do (move back to active todos)
  // Future<void> restoreDeletedTodo(Employee todo) async {
  //   final user = _authService.currentUser;
  //   if (user == null) throw Exception("User is not logged in");
  //   await _firestore.collection("users").doc(todo.id).set({...todo.toMap()});
  //   await _firestore.collection("users").doc(todo.id).delete();
  // }

  /// 🔹 Permanently delete a to-do from trash
  Future<void> deletePermanently(String todoId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore.collection("users").doc(todoId).delete();
  }

  /// 🔹 Clear all deleted todos
  Future<void> clearTrash() async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    final batch = _firestore.batch();
    final querySnapshot = await _firestore.collection("users").get();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  Stream<List<Map<String, dynamic>>> searchEmployee(String input) {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    final tags = generateTags(input);

    Query query = _firestore.collection("employees");

    // If input is empty, (limit to 10)
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
