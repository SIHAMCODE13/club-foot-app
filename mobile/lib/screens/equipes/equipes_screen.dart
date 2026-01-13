import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class EquipesScreen extends StatefulWidget {
  const EquipesScreen({Key? key}) : super(key: key);

  @override
  State<EquipesScreen> createState() => _EquipesScreenState();
}

class _EquipesScreenState extends State<EquipesScreen> {
  List<Equipe> equipes = [];
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
      setState(() {
        isLoading = true;
        error = null;
      });
      final loaded = await ApiService.getAllEquipes('ADMIN');
      setState(() => equipes = loaded);
    } catch (e) {
      setState(()=> error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Équipes')),
      body: isLoading ? const LoadingWidget(message: 'Chargement des équipes...') :
        error != null ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size: 48, color: Colors.red), const SizedBox(height:8), Text('Erreur: $error'), const SizedBox(height:8), ElevatedButton(onPressed: _load, child: const Text('Réessayer'))])) :
        RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher équipe'), onChanged: (v)=> setState(()=> search = v)),
              const SizedBox(height:12),
              if (_filtered().isEmpty) const EmptyState(title: 'Aucune équipe') else Column(children: _filtered().map((e) => Card(margin: const EdgeInsets.only(bottom:12), child: ListTile(title: Text(e.nom), subtitle: Text(e.categorie ?? ''), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(icon: const Icon(Icons.edit), onPressed: ()=> _showEdit(e)), IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: ()=> _delete(e))])))).toList())
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: _showAdd, child: const Icon(Icons.add)),
    );
  }

  List<Equipe> _filtered(){
    if(search.isEmpty) return equipes;
    return equipes.where((e)=> ('${e.nom} ${e.categorie}').toLowerCase().contains(search.toLowerCase())).toList();
  }

  void _showAdd(){
    final _form = GlobalKey<FormState>();
    String nom = '';
    String cat = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Créer équipe'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v) => nom = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Catégorie'), onSaved: (v) => cat = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => equipes.insert(0, Equipe(id: DateTime.now().millisecondsSinceEpoch, nom: nom, categorie: cat)));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Équipe créée (local)')));
          }, child: const Text('Créer')),
        ],
      ),
    );
  }

  void _showEdit(Equipe e){
    final _form = GlobalKey<FormState>();
    String nom = e.nom;
    String cat = e.categorie ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Éditer équipe'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(initialValue: nom, decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v) => nom = v ?? ''),
              TextFormField(initialValue: cat, decoration: const InputDecoration(labelText: 'Catégorie'), onSaved: (v) => cat = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => equipes[equipes.indexWhere((x) => x.id == e.id)] = Equipe(id: e.id, nom: nom, categorie: cat));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Équipe mise à jour (local)')));
          }, child: const Text('Enregistrer')),
        ],
      ),
    );
  }

  void _delete(Equipe e) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Supprimer cette équipe ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(onPressed: () {
            setState(() => equipes.removeWhere((x) => x.id == e.id));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Équipe supprimée (local)')));
          }, child: const Text('Supprimer')),
        ],
      ),
    );
  }
}
