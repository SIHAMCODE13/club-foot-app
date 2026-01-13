import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final role = user?.role ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Club Foot - $role'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: _buildBody(role),
      bottomNavigationBar: _buildBottomNav(role),
    );
  }

  Widget _buildBody(String role) {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard(role);
      case 1:
        return Center(child: Text('Équipes'));
      case 2:
        return Center(child: Text('Joueurs'));
      case 3:
        if (role == 'ADMIN') {
          return Center(child: Text('Utilisateurs'));
        }
        return Center(child: Text('Profil'));
      default:
        return Center(child: Text('Accueil'));
    }
  }

  Widget _buildDashboard(String role) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade800],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getRoleDescription(role),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          
          Text(
            'Actions disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          _buildActionGrid(role),
        ],
      ),
    );
  }

  Widget _buildActionGrid(String role) {
    List<ActionCard> actions = [];
    
    if (role == 'ADMIN') {
      actions = [
        ActionCard(
          title: 'Utilisateurs',
          icon: Icons.people,
          color: Colors.blue,
          onTap: () {
            Navigator.pushNamed(context, '/users');
          },
        ),
        ActionCard(
          title: 'Équipes',
          icon: Icons.groups,
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/equipes');
          },
        ),
        ActionCard(
          title: 'Joueurs',
          icon: Icons.sports_soccer,
          color: Colors.orange,
          onTap: () {
            Navigator.pushNamed(context, '/joueurs');
          },
        ),
        ActionCard(
          title: 'Entraînements',
          icon: Icons.fitness_center,
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, '/entrainements');
          },
        ),
        ActionCard(
          title: 'Matchs',
          icon: Icons.stadium,
          color: Colors.red,
          onTap: () {
            Navigator.pushNamed(context, '/matchs');
          },
        ),
        ActionCard(
          title: 'Cotisations',
          icon: Icons.payment,
          color: Colors.teal,
          onTap: () {
            Navigator.pushNamed(context, '/cotisations');
          },
        ),
      ];
    } else if (role == 'ENCADRANT') {
      actions = [
        ActionCard(
          title: 'Mes Équipes',
          icon: Icons.groups,
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/equipes');
          },
        ),
        ActionCard(
          title: 'Joueurs',
          icon: Icons.sports_soccer,
          color: Colors.orange,
          onTap: () {
            Navigator.pushNamed(context, '/joueurs');
          },
        ),
        ActionCard(
          title: 'Entraînements',
          icon: Icons.fitness_center,
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, '/entrainements');
          },
        ),
        ActionCard(
          title: 'Matchs',
          icon: Icons.stadium,
          color: Colors.red,
          onTap: () {
            Navigator.pushNamed(context, '/matchs');
          },
        ),
      ];
    } else {
      actions = [
        ActionCard(
          title: 'Équipes',
          icon: Icons.groups,
          color: Colors.green,
          onTap: () {
            Navigator.pushNamed(context, '/equipes');
          },
        ),
        ActionCard(
          title: 'Calendrier',
          icon: Icons.calendar_today,
          color: Colors.blue,
          onTap: () {
            Navigator.pushNamed(context, '/calendar');
          },
        ),
        ActionCard(
          title: 'Mes Cotisations',
          icon: Icons.payment,
          color: Colors.teal,
          onTap: () {
            Navigator.pushNamed(context, '/cotisations');
          },
        ),
        ActionCard(
          title: 'Mon Profil',
          icon: Icons.person,
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ];
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: action.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action.icon,
                    size: 40,
                    color: action.color,
                  ),
                  SizedBox(height: 12),
                  Text(
                    action.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBar _buildBottomNav(String role) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Accueil',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.groups),
        label: 'Équipes',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.sports_soccer),
        label: 'Joueurs',
      ),
    ];

    if (role == 'ADMIN') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Utilisateurs',
        ),
      );
    } else {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      );
    }

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green.shade700,
      unselectedItemColor: Colors.grey,
      items: items,
    );
  }

  String _getRoleDescription(String role) {
    switch (role) {
      case 'ADMIN':
        return 'Vous avez accès à toutes les fonctionnalités de gestion';
      case 'ENCADRANT':
        return 'Gérez vos équipes, joueurs et entraînements';
      case 'ADHERENT':
        return 'Consultez les informations du club';
      case 'INSCRIT':
        return 'Votre compte est en attente de validation';
      default:
        return '';
    }
  }
}

class ActionCard {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}