import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/service.dart';

class DataService {
  static const String _servicesKey = 'services';
  static const String _employesKey = 'employes';
  static const String _adminsKey = 'admins';
  
  // Services
  Future<List<Service>> getServices() async {
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = prefs.getString(_servicesKey) ?? '[]';
    final List<dynamic> servicesList = json.decode(servicesJson);
    return servicesList.map((json) => Service.fromJson(json)).toList();
  }
  
  Future<void> saveService(Service service) async {
    final services = await getServices();
    services.add(service);
    await _saveServices(services);
  }
  
  Future<void> _saveServices(List<Service> services) async {
    final prefs = await SharedPreferences.getInstance();
    final servicesJson = json.encode(services.map((s) => s.toJson()).toList());
    await prefs.setString(_servicesKey, servicesJson);
  }
  
  // Employés
  Future<List<Manager>> getEmployes() async {
    final prefs = await SharedPreferences.getInstance();
    final employesJson = prefs.getString(_employesKey) ?? '[]';
    final List<dynamic> employesList = json.decode(employesJson);
    return employesList.map((json) => Manager.fromJson(json)).toList();
  }
  
  Future<void> saveEmploye(Manager employe) async {
    final employes = await getEmployes();
    employes.add(employe);
    await _saveEmployes(employes);
  }
  
  Future<void> _saveEmployes(List<Manager> employes) async {
    final prefs = await SharedPreferences.getInstance();
    final employesJson = json.encode(employes.map((e) => e.toJson()).toList());
    await prefs.setString(_employesKey, employesJson);
  }
  
  // Admins
  Future<List<Admin>> getAdmins() async {
    final prefs = await SharedPreferences.getInstance();
    final adminsJson = prefs.getString(_adminsKey) ?? '[]';
    final List<dynamic> adminsList = json.decode(adminsJson);
    return adminsList.map((json) => Admin.fromJson(json)).toList();
  }
  
  Future<Admin?> authenticateAdmin(String login, String password) async {
    final admins = await getAdmins();
    try {
      return admins.firstWhere(
        (admin) => admin.login == login && admin.password == password,
      );
    } catch (e) {
      return null;
    }
  }
  
  Future<void> initializeDefaultAdmin() async {
    final admins = await getAdmins();
    if (admins.isEmpty) {
      final defaultAdmin = Admin(
        id: '1',
        nom: 'Administrateur',
        tel: '0123456789',
        login: 'gestionnaire',
        password: 'motdepasse2024',
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_adminsKey, json.encode([defaultAdmin.toJson()]));
    }
  }
  
  // Initialiser les services informatiques par défaut
  Future<void> initializeDefaultServices() async {
    final services = await getServices();
    if (services.isEmpty) {
      final defaultServices = [
        Service(
          id: '1',
          nom: 'Développement Web',
          description: 'Création et maintenance d\'applications web modernes avec React, Angular, Vue.js',
        ),
        Service(
          id: '2',
          nom: 'Développement Mobile',
          description: 'Applications mobiles natives et cross-platform (Flutter, React Native)',
        ),
        Service(
          id: '3',
          nom: 'Infrastructure & DevOps',
          description: 'Gestion des serveurs, cloud computing, CI/CD, Docker, Kubernetes',
        ),
        Service(
          id: '4',
          nom: 'Cybersécurité',
          description: 'Audit de sécurité, protection des données, tests de pénétration',
        ),
        Service(
          id: '5',
          nom: 'Intelligence Artificielle',
          description: 'Machine Learning, Deep Learning, traitement du langage naturel',
        ),
        Service(
          id: '6',
          nom: 'Support Technique',
          description: 'Assistance utilisateur, maintenance hardware/software, helpdesk',
        ),
        Service(
          id: '7',
          nom: 'Analyse de Données',
          description: 'Business Intelligence, Data Science, visualisation de données',
        ),
        Service(
          id: '8',
          nom: 'Gestion de Projet IT',
          description: 'Coordination projets informatiques, méthodologies Agile/Scrum',
        ),
      ];
      
      await _saveServices(defaultServices);
    }
  }

  // Méthodes pour modifier et supprimer des services
  Future<void> updateService(Service updatedService) async {
    final services = await getServices();
    final index = services.indexWhere((s) => s.id == updatedService.id);
    if (index != -1) {
      services[index] = updatedService;
      await _saveServices(services);
    }
  }

  Future<void> deleteService(String serviceId) async {
    final services = await getServices();
    services.removeWhere((s) => s.id == serviceId);
    await _saveServices(services);
  }

  // Méthodes pour modifier et supprimer des employés
  Future<void> updateEmploye(Manager updatedEmploye) async {
    final employes = await getEmployes();
    final index = employes.indexWhere((e) => e.id == updatedEmploye.id);
    if (index != -1) {
      employes[index] = updatedEmploye;
      await _saveEmployes(employes);
    }
  }

  Future<void> deleteEmploye(String employeId) async {
    final employes = await getEmployes();
    employes.removeWhere((e) => e.id == employeId);
    await _saveEmployes(employes);
  }
}