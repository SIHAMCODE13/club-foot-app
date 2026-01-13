import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool edit = false;
  final _form = GlobalKey<FormState>();
  String? nom;
  String? prenom;
  String? email;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    nom ??= user?.nom;
    prenom ??= user?.prenom;
    email ??= user?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!edit) ...[
            Text('${user?.nom ?? ''} ${user?.prenom ?? ''}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user?.email ?? ''),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: ()=> setState(()=> edit=true), child: const Text('Éditer profil'))
          ] else Form(key: _form, child: Column(children: [TextFormField(initialValue: nom, decoration: const InputDecoration(labelText: 'Nom'), onSaved: (v)=> nom = v), TextFormField(initialValue: prenom, decoration: const InputDecoration(labelText: 'Prénom'), onSaved: (v)=> prenom = v), TextFormField(initialValue: email, decoration: const InputDecoration(labelText: 'Email'), onSaved: (v)=> email = v), const SizedBox(height:12), Row(children: [TextButton(onPressed: ()=> setState(()=> edit=false), child: const Text('Annuler')), ElevatedButton(onPressed: (){ _form.currentState?.save(); // local update only
            // Update provider user locally if available
            if (user != null) {
              auth.updateLocalUser(nom: nom, prenom: prenom, email: email);
            }
            setState(()=> edit=false);
          }, child: const Text('Enregistrer'))])]))
        ]),
      ),
    );
  }
}
