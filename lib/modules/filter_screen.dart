import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final String location;
  final String language;
  final int followers;
  final int repos;

  FilterScreen({
    required this.location,
    required this.language,
    required this.followers,
    required this.repos,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController _locationController;
  late TextEditingController _languageController;
  late TextEditingController _followersController;
  late TextEditingController _reposController;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.location);
    _languageController = TextEditingController(text: widget.language);
    _followersController = TextEditingController(
      text: widget.followers.toString(),
    );
    _reposController = TextEditingController(text: widget.repos.toString());
  }

  @override
  void dispose() {
    _locationController.dispose();
    _languageController.dispose();
    _followersController.dispose();
    _reposController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    Navigator.pop(context, {
      'location': _locationController.text = '',
      'language': _languageController.text = '',
      'followers': int.tryParse(_followersController.text) ?? 0,
      'repos': int.tryParse(_reposController.text) ?? 0,
    });
  }

  void _applyFilters() {
    Navigator.pop(context, {
      'location': _locationController.text,
      'language': _languageController.text,
      'followers': int.tryParse(_followersController.text) ?? 0,
      'repos': int.tryParse(_reposController.text) ?? 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Filtros de Pesquisa')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Localização',
                suffixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _languageController,
              decoration: InputDecoration(
                labelText: 'Linguagem de Programação',
                suffixIcon: Icon(Icons.code),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _followersController,
              decoration: InputDecoration(
                labelText: 'Número de Seguidores',
                suffixIcon: Icon(Icons.group),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _reposController,
              decoration: InputDecoration(
                labelText: 'Número de Repositórios',
                suffixIcon: Icon(Icons.storage),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearFilters,
                  child: Text('Limpar Filtros'),
                ),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Aplicar Filtros'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
