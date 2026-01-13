import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> users = [];
  bool isLoading = true;
  String? error;
  String searchQuery = '';
  String selectedRole = 'ALL';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final loadedUsers = await ApiService.getAllUsers();

      setState(() {
        users = loadedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Utilisateurs'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: isLoading
          ? const LoadingWidget(message: 'Chargement des utilisateurs...')
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Erreur: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadUsers,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredUsers().length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers()[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: _getRoleColor(user.role),
                            child: Text(
                              user.nom[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            '${user.nom} ${user.prenom}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(user.email),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(
                                  user.role,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: _getRoleColor(user.role).withOpacity(0.2),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditUserDialog(user);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Confirmer'),
                                      content: const Text('Supprimer cet utilisateur ?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
                                      ],
                                    ),
                                  );
                                  if (ok == true) {
                                    setState(() {
                                      users.removeWhere((u) => u.id == user.id);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Utilisateur supprimé (local)')));
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUserDialog();
        },
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<User> _filteredUsers() {
    var list = users;
    if (selectedRole != 'ALL') list = list.where((u) => u.role == selectedRole).toList();
    if (searchQuery.isNotEmpty) {
      list = list.where((u) => ('${u.nom} ${u.prenom} ${u.email}').toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    return list;
  }

  void _showAddUserDialog() {
    final _formKey = GlobalKey<FormState>();
    String nom = '';
    String prenom = '';
    String email = '';
    String role = 'ADHERENT';

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ajouter utilisateur'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v) => nom = v ?? ''),
                TextFormField(decoration: const InputDecoration(labelText: 'Prénom'), onSaved: (v) => prenom = v ?? ''),
                TextFormField(decoration: const InputDecoration(labelText: 'Email'), onSaved: (v) => email = v ?? ''),
                DropdownButtonFormField<String>(value: role, items: ['ADMIN','ENCADRANT','ADHERENT','INSCRIT'].map((r)=>DropdownMenuItem(value: r,child: Text(r))).toList(), onChanged: (v){role=v!;}),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () async {
            _formKey.currentState?.save();
            final newUser = User(id: DateTime.now().millisecondsSinceEpoch, email: email, nom: nom, prenom: prenom, role: role);
            setState((){ users.insert(0, newUser); });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Utilisateur ajouté (local)')));
          }, child: const Text('Ajouter')),
        ],
      ),
    );
  }

  void _showEditUserDialog(User user) {
    final _formKey = GlobalKey<FormState>();
    String nom = user.nom;
    String prenom = user.prenom;
    String email = user.email;
    String role = user.role;

    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Éditer utilisateur'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(initialValue: nom, decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v) => nom = v ?? ''),
                TextFormField(initialValue: prenom, decoration: const InputDecoration(labelText: 'Prénom'), onSaved: (v) => prenom = v ?? ''),
                TextFormField(initialValue: email, decoration: const InputDecoration(labelText: 'Email'), onSaved: (v) => email = v ?? ''),
                DropdownButtonFormField<String>(value: role, items: ['ADMIN','ENCADRANT','ADHERENT','INSCRIT'].map((r)=>DropdownMenuItem(value: r,child: Text(r))).toList(), onChanged: (v){role=v!;}),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () async {
            _formKey.currentState?.save();
            setState((){
              final idx = users.indexWhere((u)=>u.id==user.id);
              if(idx>=0) users[idx] = User(id: user.id, email: email, nom: nom, prenom: prenom, role: role);
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Utilisateur mis à jour (local)')));
          }, child: const Text('Enregistrer')),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.red.shade700;
      case 'ENCADRANT':
        return Colors.orange.shade700;
      case 'ADHERENT':
        return Colors.green.shade700;
      case 'INSCRIT':
        return Colors.grey.shade600;
      default:
        return Colors.blue.shade700;
    }
  }
}
