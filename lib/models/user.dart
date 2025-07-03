abstract class User {
  final String id;
  final String nom;
  final String tel;
  
  User({required this.id, required this.nom, required this.tel});
}

class Admin extends User {
  final String login;
  final String password;
  
  Admin({
    required String id,
    required String nom,
    required String tel,
    required this.login,
    required this.password,
  }) : super(id: id, nom: nom, tel: tel);
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'tel': tel,
    'login': login,
    'password': password,
    'type': 'admin'
  };
  
  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
    id: json['id'],
    nom: json['nom'],
    tel: json['tel'],
    login: json['login'],
    password: json['password'],
  );
}

class Manager extends User {
  final double salaire;
  final double prime;
  
  Manager({
    required String id,
    required String nom,
    required String tel,
    required this.salaire,
    required this.prime,
  }) : super(id: id, nom: nom, tel: tel);
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'tel': tel,
    'salaire': salaire,
    'prime': prime,
    'type': 'manager'
  };
  
  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
    id: json['id'],
    nom: json['nom'],
    tel: json['tel'],
    salaire: json['salaire'].toDouble(),
    prime: json['prime'].toDouble(),
  );
}