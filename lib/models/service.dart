class Service {
  final String id;
  final String nom;
  final String description;
  final List<String> employeIds;
  
  Service({
    required this.id,
    required this.nom,
    required this.description,
    this.employeIds = const [],
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nom': nom,
    'description': description,
    'employeIds': employeIds,
  };
  
  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json['id'],
    nom: json['nom'],
    description: json['description'],
    employeIds: List<String>.from(json['employeIds'] ?? []),
  );
}