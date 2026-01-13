import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/match_card.dart';
import '../../widgets/empty_state.dart';

class MatchsScreen extends StatefulWidget {
  const MatchsScreen({Key? key}) : super(key: key);

  @override
  State<MatchsScreen> createState() => _MatchsScreenState();
}

class _MatchsScreenState extends State<MatchsScreen> {
  List<Match> list = [];
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
      final loaded = await ApiService.getAllMatchs('ADMIN');
      setState(()=> list = loaded);
    } catch (e) {
      setState(()=> error = e.toString());
    } finally { setState(()=> isLoading=false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matchs')),
      body: isLoading ? const LoadingWidget(message: 'Chargement des matchs...') :
        error != null ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size:48, color: Colors.red), const SizedBox(height:8), Text('Erreur: $error'), const SizedBox(height:8), ElevatedButton(onPressed: _load, child: const Text('Réessayer'))])) :
        RefreshIndicator(
          onRefresh: _load,
          child: ListView(padding: const EdgeInsets.all(16), children: [
            TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Rechercher match'), onChanged: (v)=> setState(()=> search=v)),
            const SizedBox(height:12),
            if (_filtered().isEmpty) const EmptyState(title: 'Aucun match') else Column(children: _filtered().map((m)=> MatchCard(match: m, onTap: ()=> _showDetails(m))).toList())
          ]),
        ),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
    );
  }

  List<Match> _filtered(){
    if(search.isEmpty) return list;
    return list.where((m)=> ('${m.adversaire} ${m.lieu}').toLowerCase().contains(search.toLowerCase())).toList();
  }

  void _showDetails(Match m){
  }

  void _scoreKeeper(Match m){
    int team = m.scoreEquipe ?? 0;
    int adv = m.scoreAdversaire ?? 0;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (c, setS) {
          return AlertDialog(
            title: const Text('Scorekeeper'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${team} - ${adv}', style: const TextStyle(fontSize: 24)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () => setS(() => team++), icon: const Icon(Icons.add)),
                    IconButton(onPressed: () => setS(() => team = (team > 0 ? team - 1 : 0)), icon: const Icon(Icons.remove)),
                    const SizedBox(width: 12),
                    IconButton(onPressed: () => setS(() => adv++), icon: const Icon(Icons.add)),
                    IconButton(onPressed: () => setS(() => adv = (adv > 0 ? adv - 1 : 0)), icon: const Icon(Icons.remove)),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    list[list.indexWhere((x) => x.id == m.id)] = Match(
                      id: m.id,
                      equipeId: m.equipeId,
                      adversaire: m.adversaire,
                      dateHeure: m.dateHeure,
                      lieu: m.lieu,
                      scoreEquipe: team,
                      scoreAdversaire: adv,
                      statut: 'EN_COURS',
                    );
                  });
                  Navigator.pop(context);
                },
                child: const Text('Enregistrer'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _add() {
    final _form = GlobalKey<FormState>();
    String adv = '';
    String date = '';
    String lieu = '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Créer match'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Adversaire'), onSaved: (v) => adv = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Date/Heure'), onSaved: (v) => date = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Lieu'), onSaved: (v) => lieu = v ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => list.insert(0, Match(id: DateTime.now().millisecondsSinceEpoch, equipeId: 0, adversaire: adv, dateHeure: date, lieu: lieu)));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match créé (local)')));
          }, child: const Text('Créer')),
        ],
      ),
    );
  }
}
