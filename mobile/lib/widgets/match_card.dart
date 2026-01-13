import 'package:flutter/material.dart';
import '../models/models.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback? onTap;
  const MatchCard({Key? key, required this.match, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        title: Text(match.adversaire),
        subtitle: Text('${match.dateHeure} • ${match.lieu}'),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text('${match.scoreEquipe ?? '-'} - ${match.scoreAdversaire ?? '-'}'), Text(match.statut)]),
      ),
    );
  }
}
