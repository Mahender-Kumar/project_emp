import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/services/generate_tags.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  /// set an employee
  Future<void> saveEmployee(Employee employee, {List? tags}) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    await _firestore.collection("employees").doc(employee.id).set({
      ...employee.toMap(),
      'tags': tags ?? [],
    }, SetOptions(merge: true));
  }

  /// 🔹 Get active to-dos (not deleted)
  Stream<QuerySnapshot<Map<String, dynamic>>> getEmployees() {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");

    return _firestore.collection("employees").snapshots();
  }

  Future<void> moveToTrash(Employee employee) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore.collection("employees").doc(employee.id).delete();
    await _firestore.collection("deleted_employees").doc(employee.id).set({
      ...employee.toMap(),
    });
  }

  Stream<List<Map<String, dynamic>>> getDeletedEmployee() {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    return _firestore
        .collection("deleted_employees")
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => {'id': doc.id, ...doc.data()})
                  .toList(),
        );
  }

  ///  Permanently delete a to-do from trash
  Future<void> deletePermanently(String employeeId) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    await _firestore.collection("employees").doc(employeeId).delete();
  }

  ///  Clear all deleted employee
  Future<void> clearTrash() async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User is not logged in");
    final batch = _firestore.batch();
    final querySnapshot =
        await _firestore.collection("deleted_employees").get();
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
}
