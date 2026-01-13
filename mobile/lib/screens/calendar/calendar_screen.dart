import 'package:flutter/material.dart';
import '../entrainements/entrainements_screen.dart';
import '../matchs/matchs_screen.dart';
import '../../services/api_service.dart';
import '../../models/models.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Entrainement> entr = [];
  List<Match> matchs = [];
  bool isLoading = true;
  String? error;

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
      final e = await ApiService.getAllEntrainements('ADMIN');
      final m = await ApiService.getAllMatchs('ADMIN');
      setState(() {
        entr = e;
        matchs = m;
      });
    } catch (ex) { setState(()=> error = ex.toString()); } finally { setState(()=> isLoading=false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier')),
      body: isLoading ? const LoadingWidget(message: 'Chargement du calendrier...') :
        error != null ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, size:48, color: Colors.red), Text('Erreur: $error'), ElevatedButton(onPressed: _load, child: const Text('Réessayer'))])) :
        RefreshIndicator(onRefresh: _load, child: ListView(padding: const EdgeInsets.all(16), children: _buildItems())),
    );
  }

  List<Widget> _buildItems(){
    final items = <Widget>[];
    if(entr.isEmpty && matchs.isEmpty) return [const EmptyState(title: 'Aucun événement')];
    items.add(const Text('Entraînements', style: TextStyle(fontWeight: FontWeight.bold)));
    items.addAll(entr.map((e)=> ListTile(title: Text(e.lieu), subtitle: Text(e.dateHeure))));
    items.add(const SizedBox(height:12));
    items.add(const Text('Matchs', style: TextStyle(fontWeight: FontWeight.bold)));
    items.addAll(matchs.map((m)=> ListTile(title: Text('vs ${m.adversaire}'), subtitle: Text('${m.dateHeure} • ${m.lieu}'))));
    return items;
  }
}
