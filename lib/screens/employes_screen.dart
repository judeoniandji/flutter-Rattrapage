import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/service.dart';
import '../services/data_service.dart';

class EmployesScreen extends StatefulWidget {
  @override
  _EmployesScreenState createState() => _EmployesScreenState();
}

class _EmployesScreenState extends State<EmployesScreen> {
  final DataService _dataService = DataService();
  List<Manager> _employes = [];
  List<Service> _services = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final employes = await _dataService.getEmployes();
    final services = await _dataService.getServices();
    setState(() {
      _employes = employes;
      _services = services;
      _isLoading = false;
    });
  }
  
  Future<void> _showAddEmployeDialog() async {
    final _nomController = TextEditingController();
    final _telController = TextEditingController();
    final _salaireController = TextEditingController();
    final _primeController = TextEditingController();
    Service? _selectedService;
    
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Ajouter un Employé'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _telController,
                  decoration: InputDecoration(
                    labelText: 'Téléphone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _salaireController,
                  decoration: InputDecoration(
                    labelText: 'Salaire',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _primeController,
                  decoration: InputDecoration(
                    labelText: 'Prime',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Service>(
                  value: _selectedService,
                  decoration: InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                  ),
                  items: _services.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child: Text(service.nom),
                    );
                  }).toList(),
                  onChanged: (service) {
                    setDialogState(() {
                      _selectedService = service;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            // Dans la méthode _showAddEmployeDialog(), après l'ajout d'un employé :
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _telController.text.isNotEmpty &&
                    _salaireController.text.isNotEmpty &&
                    _primeController.text.isNotEmpty &&
                    _selectedService != null) { // Ajout de la validation du service
                  final employe = Manager(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nom: _nomController.text,
                    tel: _telController.text,
                    salaire: double.parse(_salaireController.text),
                    prime: double.parse(_primeController.text),
                  );
                  
                  await _dataService.saveEmploye(employe);
                  
                  // Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Employé ${employe.nom} ajouté avec succès !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  Navigator.pop(context);
                  _loadData(); // Recharger la liste
                } else {
                  // Afficher un message d'erreur si des champs sont vides
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _showEditEmployeDialog(Manager employe) async {
    final _nomController = TextEditingController(text: employe.nom);
    final _telController = TextEditingController(text: employe.tel);
    final _salaireController = TextEditingController(text: employe.salaire.toString());
    final _primeController = TextEditingController(text: employe.prime.toString());
    
    return showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Modifier Employé'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _telController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _salaireController,
                decoration: InputDecoration(
                  labelText: 'Salaire',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _primeController,
                decoration: InputDecoration(
                  labelText: 'Prime',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nomController.text.isNotEmpty &&
                    _telController.text.isNotEmpty &&
                    _salaireController.text.isNotEmpty &&
                    _primeController.text.isNotEmpty) {
                  final updatedEmploye = Manager(
                    id: employe.id,
                    nom: _nomController.text,
                    tel: _telController.text,
                    salaire: double.parse(_salaireController.text),
                    prime: double.parse(_primeController.text),
                  );
                  
                  await _dataService.updateEmploye(updatedEmploye);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Employé ${updatedEmploye.nom} modifié avec succès !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  Navigator.pop(context);
                  _loadData();
                }
              },
              child: Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteEmploye(Manager employe) async {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirmer la suppression'),
          ],
        ),
        content: Text('Êtes-vous sûr de vouloir supprimer l\'employé "${employe.nom}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _dataService.deleteEmploye(employe.id);
              Navigator.pop(context);
              _loadData();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Employé supprimé avec succès !'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Employés (${_employes.length})'), // Afficher le nombre
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData, // Bouton pour actualiser
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _employes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Aucun employé enregistré',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _employes.length,
                  itemBuilder: (context, index) {
                    final employe = _employes[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: // Dans le ListView.builder :
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Text(
                            employe.nom.substring(0, 1).toUpperCase(), // Afficher la première lettre
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          employe.nom,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${employe.id}'),
                            Text('Tel: ${employe.tel}'),
                            Text('Salaire: ${employe.salaire.toStringAsFixed(2)} FCFA'),
                            Text('Prime: ${employe.prime.toStringAsFixed(2)} FCFA'),
                            Text('Total: ${(employe.salaire + employe.prime).toStringAsFixed(2)} FCFA',
                                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditEmployeDialog(employe);
                            } else if (value == 'delete') {
                              _confirmDeleteEmploye(employe);
                            } else if (value == 'details') {
                              // Afficher les détails de l'employé
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Détails de ${employe.nom}'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('ID: ${employe.id}'),
                                      Text('Nom: ${employe.nom}'),
                                      Text('Téléphone: ${employe.tel}'),
                                      Text('Salaire: ${employe.salaire.toStringAsFixed(2)} FCFA'),
                                      Text('Prime: ${employe.prime.toStringAsFixed(2)} FCFA'),
                                      Text('Total: ${(employe.salaire + employe.prime).toStringAsFixed(2)} FCFA',
                                           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Fermer'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'details',
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Détails'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.orange),
                                  SizedBox(width: 8),
                                  Text('Modifier'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Supprimer'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEmployeDialog,
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
      ),
    );
  }
}