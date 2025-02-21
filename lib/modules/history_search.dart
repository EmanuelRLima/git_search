import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  final List<String> searchHistory;

  const HistoryScreen({super.key, required this.searchHistory});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<String> searchHistory;

  @override
  void initState() {
    super.initState();
    searchHistory = widget.searchHistory;
  }

  void _clearHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Pesquisas'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: _clearHistory),
        ],
      ),
      body:
          searchHistory.isEmpty
              ? Center(child: Text('Nenhum histórico disponível'))
              : ListView.builder(
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(searchHistory[index]),
                    onTap: () {
                      Navigator.pop(context, searchHistory[index]);
                    },
                  );
                },
              ),
    );
  }
}
