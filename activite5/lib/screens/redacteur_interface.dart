// lib/screens/redacteur_interface.dart

import 'package:flutter/material.dart';
import '../models/redacteur.dart';
import '../services/database_manager.dart';

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _list = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    final list = await DatabaseManager.instance.getAllRedacteurs();
    setState(() => _list = list);
  }

  Future<void> _addRedacteur() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();
    if (nom.isEmpty || prenom.isEmpty || email.isEmpty) return;
    final r = Redacteur(nom: nom, prenom: prenom, email: email);
    await DatabaseManager.instance.insertRedacteur(r);
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    await _refreshList();
  }

  Future<void> _showEditDialog(Redacteur r) async {
    final nomC = TextEditingController(text: r.nom);
    final prenomC = TextEditingController(text: r.prenom);
    final emailC = TextEditingController(text: r.email);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier Rédacteur'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nomC,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: prenomC,
                decoration: const InputDecoration(labelText: 'Prénom'),
              ),
              TextField(
                controller: emailC,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nom = nomC.text.trim();
              final prenom = prenomC.text.trim();
              final email = emailC.text.trim();
              if (nom.isEmpty || prenom.isEmpty || email.isEmpty) return;
              final updated = Redacteur(
                id: r.id,
                nom: nom,
                prenom: prenom,
                email: email,
              );
              await DatabaseManager.instance.updateRedacteur(updated);
              Navigator.pop(context);
              await _refreshList();
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Redacteur r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer'),
        content: Text('Voulez-vous supprimer ${r.nom} ${r.prenom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await DatabaseManager.instance.deleteRedacteur(r.id!);
      await _refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestion des Rédacteurs')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter un Rédacteur'),
                    onPressed: _addRedacteur,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Expanded(
              child: _list.isEmpty
                  ? const Center(child: Text('Aucun rédacteur enregistré.'))
                  : ListView.builder(
                      itemCount: _list.length,
                      itemBuilder: (context, index) {
                        final r = _list[index];
                        return ListTile(
                          title: Text('${r.nom} ${r.prenom}'),
                          subtitle: Text(r.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _showEditDialog(r),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(r),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
