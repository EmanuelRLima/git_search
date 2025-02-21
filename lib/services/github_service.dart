import 'dart:convert';
import 'package:http/http.dart' as http;

class GitHubService {
  Future<List<Map<String, dynamic>>> searchUsers(
    String query, {
    String location = '',
    String language = '',
    int followers = 0,
    int repos = 0,
  }) async {
    String url = 'https://api.github.com/search/users?q=$query';
    if (location.isNotEmpty) url += '+location:$location';
    if (language.isNotEmpty) url += '+language:$language';
    if (followers > 0) url += '+followers:>=$followers';
    if (repos > 0) url += '+repos:>=$repos';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> dataUsers = data['items'];
      return List<Map<String, dynamic>>.from(dataUsers);
    } else {
      List<dynamic> dataUsers = [];
      return List<Map<String, dynamic>>.from(dataUsers);
    }
  }
}

class DetailUser {
  Future<Map<String, dynamic>> getUserDetails(String username) async {
    final url = Uri.parse('https://api.github.com/users/$username');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar dados do usuário');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
