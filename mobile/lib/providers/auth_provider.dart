import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      _user = User.fromJson(response['user']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id.toString());
      await prefs.setString('userRole', _user!.role);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(User user, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await ApiService.register(user, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _user = null;
    notifyListeners();
  }

  Future<void> checkAuthentication() async {
    final token = await ApiService.getToken();
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userRole = prefs.getString('userRole');
      
      if (userId != null && userRole != null) {
        _user = User(
          id: int.parse(userId),
          email: '',
          nom: '',
          prenom: '',
          role: userRole,
        );
        notifyListeners();
      }
    }
  }

  // Update local user fields (used by Profile screen for local edits)
  void updateLocalUser({String? nom, String? prenom, String? email}) {
    if (_user == null) return;
    _user = User(
      id: _user!.id,
      email: email ?? _user!.email,
      nom: nom ?? _user!.nom,
      prenom: prenom ?? _user!.prenom,
      telephone: _user!.telephone,
      adresse: _user!.adresse,
      dateNaissance: _user!.dateNaissance,
      photo: _user!.photo,
      role: _user!.role,
      actif: _user!.actif,
      dateInscription: _user!.dateInscription,
      derniereConnexion: _user!.derniereConnexion,
    );
    notifyListeners();
  }
}