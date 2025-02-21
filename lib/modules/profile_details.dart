import 'package:flutter/material.dart';
import '../../services/github_service.dart';

class ProfileDetails extends StatefulWidget {
  final String user;

  ProfileDetails({required this.user});

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  late Future<Map<String, dynamic>> _userDetails;

  @override
  void initState() {
    super.initState();
    _userDetails = DetailUser().getUserDetails(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Informações')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Nenhum dado encontrado'));
          }
          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Detalhes do usuário',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['avatar_url']),
                    radius: 50,
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${data['name'] ?? 'Não disponível'}',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(height: 1),
                Align(
                  alignment: Alignment.center,
                  child:
                      data['bio'] != null && data['bio'].isNotEmpty
                          ? Text(
                            '${data['bio']}',
                            style: TextStyle(fontSize: 22),
                            textAlign: TextAlign.center,
                          )
                          : SizedBox.shrink(),
                ),
                SizedBox(height: 5),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.group),
                    SizedBox(width: 5),
                    Text(
                      '${data['followers']} Seguidores',
                      style: TextStyle(fontSize: 19),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.visibility),
                    SizedBox(width: 5),
                    Text(
                      '${data['following']} Seguindo',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),

                Text(
                  'Repositórios públicos: ${data['public_repos']}',
                  style: TextStyle(fontSize: 19),
                ),
                Text(
                  'Localização: ${data['location'] ?? 'Não disponível'}',
                  style: TextStyle(fontSize: 19),
                ),
                Text(
                  'Empresa: ${data['company'] ?? 'Não disponível'}',
                  style: TextStyle(fontSize: 19),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
