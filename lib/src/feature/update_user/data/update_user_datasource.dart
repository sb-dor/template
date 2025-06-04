abstract interface class IUpdateUserDataSource {
  Future<bool> updateUser({required String name, required String email});
}

final class UpdateUserDataSource implements IUpdateUserDataSource {
  @override
  Future<bool> updateUser({required String name, required String email}) async {
    // Simulate a network call or database update
    await Future.delayed(const Duration(seconds: 1));
    // Here you would typically make an API call or database operation to update the user
    return true;
  }
}
