import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class EntrainementsScreen extends StatefulWidget {
  const EntrainementsScreen({Key? key}) : super(key: key);

  @override
  State<EntrainementsScreen> createState() => _EntrainementsScreenState();
}

class _EntrainementsScreenState extends State<EntrainementsScreen> {
  List<Entrainement> list = [];
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
      final loaded = await ApiService.getAllEntrainements('ADMIN');
      setState(()=> list = loaded);
    } catch (e) {
      setState(()=> error = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entraînements')),
      body: isLoading ? const LoadingWidget(message: 'Chargement...') :
        error != null ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size:48, color: Colors.red), const SizedBox(height:8), Text('Erreur: $error'), const SizedBox(height:8), ElevatedButton(onPressed: _load, child: const Text('Réessayer'))])) :
        RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher entraînement'),
                onChanged: (v) => setState(() => search = v),
              ),
              const SizedBox(height: 12),
              if (_filtered().isEmpty)
                const EmptyState(title: 'Aucun entraînement')
              else
                Column(
                  children: _filtered()
                      .map((e) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(e.lieu),
                              subtitle: Text('${e.dateHeure} • ${e.objectif ?? ''}'),
                              trailing: PopupMenuButton<String>(
                                onSelected: (v) {
                                  if (v == 'edit') _edit(e);
                                  if (v == 'delete') _delete(e);
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Éditer')),
                                  const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                )
            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
    );
  }

  List<Entrainement> _filtered(){
    if(search.isEmpty) return list;
    return list.where((e)=> ('${e.lieu} ${e.objectif}').toLowerCase().contains(search.toLowerCase())).toList();
  }

  void _add() {
    final _form = GlobalKey<FormState>();
    int equipeId = 0;
    String date = '';
    String lieu = '';
    String obj = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Créer entraînement'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Lieu'), onSaved: (v) => lieu = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Date/Heure'), onSaved: (v) => date = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Objectif'), onSaved: (v) => obj = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => list.insert(0, Entrainement(id: DateTime.now().millisecondsSinceEpoch, equipeId: equipeId, dateHeure: date, lieu: lieu, objectif: obj)));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entraînement créé (local)')));
          }, child: const Text('Créer')),
        ],
      ),
    );
  }

  void _edit(Entrainement e) {
    final _form = GlobalKey<FormState>();
    String lieu = e.lieu;
    String date = e.dateHeure;
    String obj = e.objectif ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Éditer entraînement'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(initialValue: lieu, decoration: const InputDecoration(labelText: 'Lieu'), onSaved: (v) => lieu = v ?? ''),
              TextFormField(initialValue: date, decoration: const InputDecoration(labelText: 'Date/Heure'), onSaved: (v) => date = v ?? ''),
              TextFormField(initialValue: obj, decoration: const InputDecoration(labelText: 'Objectif'), onSaved: (v) => obj = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => list[list.indexWhere((x) => x.id == e.id)] = Entrainement(id: e.id, equipeId: e.equipeId, dateHeure: date, lieu: lieu, objectif: obj));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entraînement mis à jour (local)')));
          }, child: const Text('Enregistrer')),
        ],
      ),
    );
  }

  void _delete(Entrainement e) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer'),
        content: const Text('Supprimer cet entraînement ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          TextButton(onPressed: () {
            setState(() => list.removeWhere((x) => x.id == e.id));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entraînement supprimé (local)')));
          }, child: const Text('Supprimer')),
        ],
      ),
    );
  }
}
