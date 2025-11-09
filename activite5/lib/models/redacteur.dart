// lib/models/redacteur.dart

class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  factory Redacteur.fromMap(Map<String, dynamic> map) => Redacteur(
    id: map['id'] as int?,
    nom: map['nom'] as String,
    prenom: map['prenom'] as String,
    email: map['email'] as String,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'nom': nom, 'prenom': prenom, 'email': email};
    if (id != null) map['id'] = id;
    return map;
  }
}
