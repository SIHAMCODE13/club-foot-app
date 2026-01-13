import 'package:flutter/material.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';

class Cotisation {
  final int id;
  final String user;
  final double amount;
  bool paid;

  Cotisation({required this.id, required this.user, required this.amount, this.paid = false});
}

class CotisationsScreen extends StatefulWidget {
  const CotisationsScreen({Key? key}) : super(key: key);

  @override
  State<CotisationsScreen> createState() => _CotisationsScreenState();
}

class _CotisationsScreenState extends State<CotisationsScreen> {
  List<Cotisation> list = [];
  bool isLoading = true;
  String? error;
  String filter = 'ALL';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      list = [
        Cotisation(id: 1, user: 'member@club.com', amount: 50.0, paid: false),
        Cotisation(id: 2, user: 'john@club.com', amount: 75.0, paid: true),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotisations'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setState(() => filter = v),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'ALL', child: Text('Tous')),
              const PopupMenuItem(value: 'PAID', child: Text('Payés')),
              const PopupMenuItem(value: 'UNPAID', child: Text('Impayés')),
            ],
          )
        ],
      ),
      body: isLoading
          ? const LoadingWidget(message: 'Chargement...')
          : _filtered().isEmpty
              ? const EmptyState(title: 'Aucune cotisation')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filtered().length,
                  itemBuilder: (c, i) {
                    final co = _filtered()[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(co.user),
                        subtitle: Text('${co.amount}€'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!co.paid)
                              TextButton(onPressed: () => _markPaid(co), child: const Text('Marquer payé')),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(co)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(onPressed: _add, child: const Icon(Icons.add)),
    );
  }

  List<Cotisation> _filtered(){
    switch(filter){
      case 'PAID': return list.where((c)=> c.paid).toList();
      case 'UNPAID': return list.where((c)=> !c.paid).toList();
      default: return list;
    }
  }

  void _markPaid(Cotisation c) {
    setState(() => c.paid = true);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paiement enregistré (local)')));
  }

  void _delete(Cotisation c) {
    setState(() => list.removeWhere((x) => x.id == c.id));
  }

  void _add() {
    final _form = GlobalKey<FormState>();
    String user = '';
    double amount = 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enregistrer cotisation'),
        content: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(decoration: const InputDecoration(labelText: 'Email adhérent'), onSaved: (v) => user = v ?? ''),
              TextFormField(decoration: const InputDecoration(labelText: 'Montant'), keyboardType: TextInputType.number, onSaved: (v) => amount = double.tryParse(v ?? '0') ?? 0),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(onPressed: () {
            _form.currentState?.save();
            setState(() => list.insert(0, Cotisation(id: DateTime.now().millisecondsSinceEpoch, user: user, amount: amount)));
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cotisation ajoutée (local)')));
          }, child: const Text('Ajouter')),
        ],
      ),
    );
  }
}
