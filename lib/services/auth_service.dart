class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _token;
  String? _userId; // Agora é String (MongoDB _id)

  String? get token => _token;
  set token(String? value) => _token = value;

  String? get userId => _userId;
  set userId(String? value) => _userId = value;

  void clear() {
    _token = null;
    _userId = null;
  }
}
