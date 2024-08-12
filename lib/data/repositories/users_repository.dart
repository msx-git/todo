import '../models/user.dart';
import '../services/firebase_user_service.dart';

class UsersRepository {
  final FirebaseUserService _firebaseUserService;

  UsersRepository({required FirebaseUserService firebaseUserService})
      : _firebaseUserService = firebaseUserService;

  Stream<List<User>> getUsers() {
    return _firebaseUserService.getUsers();
  }

  Future<void> addUser(User user) async {
    await _firebaseUserService.addUser(user);
  }

  Future<void> editUser(String id, User user) async {
    await _firebaseUserService.editUser(id, user);
  }

  Future<void> deleteUser(String id) async {
    await _firebaseUserService.deleteUser(id);
  }
}
