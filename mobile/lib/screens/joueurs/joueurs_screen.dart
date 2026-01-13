import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class JoueursScreen extends StatelessWidget {
  const JoueursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _JoueursBody();
  }
}

class _JoueursBody extends StatefulWidget {
  const _JoueursBody({Key? key}) : super(key: key);

  @override
  State<_JoueursBody> createState() => _JoueursBodyState();
}

class _JoueursBodyState extends State<_JoueursBody> {
  List<Joueur> joueurs = [];
  bool isLoading = true;
  String? error;
  String search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState((){isLoading=true; error=null;});
      final authRole = 'ADMIN';
      final loaded = await ApiService.getAllJoueurs(authRole);
      setState(()=> joueurs = loaded);
    } catch (e) {
      setState(()=> error = e.toString());
    } finally { setState(()=> isLoading=false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joueurs')),
      body: isLoading ? const LoadingWidget(message: 'Chargement des joueurs...') :
        error != null ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size: 48, color: Colors.red), const SizedBox(height:8), Text('Erreur: $error'), const SizedBox(height:8), ElevatedButton(onPressed: _load, child: const Text('Réessayer'))])) :
        RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher joueur'), onChanged: (v)=> setState(()=> search = v)),
              const SizedBox(height:12),
              if (_filtered().isEmpty)
                const EmptyState(title: 'Aucun joueur trouvé')
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _filtered().length,
                  itemBuilder: (context, index) {
                    final j = _filtered()[index];
                    return Card(
                      child: InkWell(
                        onTap: () => _showDetails(j),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              CircleAvatar(radius: 28, child: Text(j.nom.isNotEmpty ? j.nom[0].toUpperCase() : '?')),
                              const SizedBox(height: 8),
                              Text('${j.nom} ${j.prenom}', textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text(j.poste),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, child: const Icon(Icons.add)),
    );
  }

  List<Joueur> _filtered(){
    if(search.isEmpty) return joueurs;
    return joueurs.where((j) => ('${j.nom} ${j.prenom} ${j.poste}').toLowerCase().contains(search.toLowerCase())).toList();
  }

  void _showDetails(Joueur j){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${j.nom} ${j.prenom}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Poste: ${j.poste}'),
            if (j.numeroMaillot != null) Text('N°${j.numeroMaillot}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fermer')),
        ],
      ),
    );
  }

  void _showAddDialog(){
    final _form = GlobalKey<FormState>();
    String nom = '';
    String prenom = '';
    String poste = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ajouter joueur'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v) => nom = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Prénom'), onSaved: (v) => prenom = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Poste'), onSaved: (v) => poste = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              _form.currentState?.save();
              setState(() => joueurs.insert(0, Joueur(id: DateTime.now().millisecondsSinceEpoch, nom: nom, prenom: prenom, poste: poste)));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Joueur ajouté (local)')));
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
