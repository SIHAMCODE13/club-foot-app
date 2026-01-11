import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/models.dart';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ==================== AUTH ====================
  
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConfig.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception('Échec de connexion');
    }
  }

  static Future<Map<String, dynamic>> register(User user, String password) async {
    final userData = user.toJson();
    userData['password'] = password;
    
    final response = await http.post(
      Uri.parse(ApiConfig.register),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Échec d\'inscription');
    }
  }

  static Future<void> logout() async {
    await removeToken();
  }

  // ==================== USERS ====================
  
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(
      Uri.parse(ApiConfig.adminUsers),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des utilisateurs');
    }
  }

  // ==================== JOUEURS ====================
  
  static Future<List<Joueur>> getAllJoueurs(String role) async {
    String url;
    if (role == 'ADMIN') {
      url = ApiConfig.adminJoueurs;
    } else if (role == 'ENCADRANT') {
      url = ApiConfig.encadrantJoueurs;
    } else {
      url = ApiConfig.adherentJoueurs;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Joueur.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des joueurs');
    }
  }

  // ==================== ÉQUIPES ====================
  
  static Future<List<Equipe>> getAllEquipes(String role) async {
    String url;
    if (role == 'ADMIN') {
      url = ApiConfig.adminEquipes;
    } else if (role == 'ENCADRANT') {
      url = ApiConfig.encadrantEquipes;
    } else {
      url = ApiConfig.adherentEquipes;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Equipe.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des équipes');
    }
  }

  // ==================== ENTRAÎNEMENTS ====================
  
  static Future<List<Entrainement>> getAllEntrainements(String role) async {
    String url;
    if (role == 'ADMIN') {
      url = ApiConfig.adminEntrainements;
    } else if (role == 'ENCADRANT') {
      url = ApiConfig.encadrantEntrainements;
    } else {
      url = ApiConfig.adherentEntrainements;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Entrainement.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des entraînements');
    }
  }

  // ==================== MATCHS ====================
  
  static Future<List<Match>> getAllMatchs(String role) async {
    String url;
    if (role == 'ADMIN') {
      url = ApiConfig.adminMatchs;
    } else if (role == 'ENCADRANT') {
      url = ApiConfig.encadrantMatchs;
    } else {
      url = ApiConfig.adherentMatchs;
    }

    final response = await http.get(
      Uri.parse(url),
      headers: await getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Match.fromJson(json)).toList();
    } else {
      throw Exception('Erreur de chargement des matchs');
    }
  }
}