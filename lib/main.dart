import 'package:flutter/material.dart';
import '../services/github_service.dart';
import '../modules/filter_screen.dart';
import '../modules/history_search.dart';
import '../modules/profile_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _search = TextEditingController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _users = [];
  List<String> _searchHistory = [];

  String _location = '';
  String _language = '';
  int _followers = 0;
  int _repos = 0;

  void _searchUsers() async {
    setState(() {
      _isLoading = true;
    });

    final GitHubService service = GitHubService();
    try {
      List<Map<String, dynamic>> users = await service.searchUsers(
        _search.text,
        location: _location,
        language: _language,
        followers: _followers,
        repos: _repos,
      );

      setState(() {
        _users = users;
        _isLoading = false;
      });

      if (_search.text.isNotEmpty) {
        setState(() {
          _searchHistory.add(_search.text);
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        print('Erro ao carregar os dados: $e');
      });

      print('Erro ao carregar os dados: $e');
    }
  }

  void _clearSearch() async {
    setState(() {
      _search.text = '';
    });
    _users = [];
  }

  void _navigateToFilterScreen() async {
    final filters = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FilterScreen(
              location: _location,
              language: _language,
              followers: _followers,
              repos: _repos,
            ),
      ),
    );

    if (filters != null) {
      setState(() {
        _location = filters['location'];
        _language = filters['language'];
        _followers = filters['followers'];
        _repos = filters['repos'];
      });
    }
  }

  void _navigateToHistoryScreen() async {
    final selectedSearch = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(searchHistory: _searchHistory),
      ),
    );

    if (selectedSearch != null) {
      _search.text = selectedSearch;
      _searchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar de usuários GitHub')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _search,
              decoration: InputDecoration(
                labelText: 'Pesquise o usuário',
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _search.text.isNotEmpty
                        ? IconButton(
                          icon: Icon(Icons.close),
                          onPressed: _clearSearch,
                        )
                        : SizedBox.shrink(),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchUsers,
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_alt),
                      onPressed: _navigateToFilterScreen,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : _users.isEmpty
                ? Center(child: Text('Nada pesquisado ainda'))
                : Expanded(
                  child: ListView.builder(
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _users[index]['avatar_url'],
                          ),
                        ),
                        title: Text(_users[index]['login']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProfileDetails(
                                    user: _users[index]['login'],
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            _navigateToHistoryScreen();
          }
        },
      ),
    );
  }
}
