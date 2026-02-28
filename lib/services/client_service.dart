import '../models/client_model.dart';

class ClientService {
  static final List<ClientModel> _mockClients = [
    ClientModel(
      id: 'client-001',
      name: 'Infosys Limited',
      industry: 'Technology',
      contactName: 'Vikram Nair',
      contactEmail: 'vikram.nair@infosys.com',
      contactPhone: '9876001234',
      region: 'South',
      assignedEmployeeIds: ['emp-001'],
      status: ClientStatus.active,
      createdAt: DateTime(2023, 2, 10),
      notes: 'Key enterprise client. Quarterly review in Dec.',
    ),
    ClientModel(
      id: 'client-002',
      name: 'HDFC Bank',
      industry: 'Banking & Finance',
      contactName: 'Sanjana Reddy',
      contactEmail: 'sanjana.r@hdfcbank.com',
      contactPhone: '9876002345',
      region: 'North',
      assignedEmployeeIds: ['emp-001', 'emp-002'],
      status: ClientStatus.active,
      createdAt: DateTime(2023, 3, 5),
      notes: 'Focus on digital banking campaign. High priority.',
    ),
    ClientModel(
      id: 'client-003',
      name: 'Reliance Retail',
      industry: 'Retail',
      contactName: 'Aarav Shah',
      contactEmail: 'aarav.shah@relianceretail.com',
      contactPhone: '9876003456',
      region: 'West',
      assignedEmployeeIds: ['emp-002'],
      status: ClientStatus.active,
      createdAt: DateTime(2023, 4, 20),
    ),
    ClientModel(
      id: 'client-004',
      name: 'Bajaj Finserv',
      industry: 'Banking & Finance',
      contactName: 'Deepa Krishnan',
      contactEmail: 'deepa.k@bajajfinserv.com',
      contactPhone: '9876004567',
      region: 'South',
      assignedEmployeeIds: ['emp-003'],
      status: ClientStatus.active,
      createdAt: DateTime(2023, 5, 8),
      notes: 'Insurance product launch campaign in Q4.',
    ),
    ClientModel(
      id: 'client-005',
      name: 'Tata Consultancy',
      industry: 'Technology',
      contactName: 'Rahul Verma',
      contactEmail: 'rahul.v@tcs.com',
      contactPhone: '9876005678',
      region: 'East',
      assignedEmployeeIds: ['emp-003', 'emp-004'],
      status: ClientStatus.inactive,
      createdAt: DateTime(2022, 11, 15),
      notes: 'Contract renewal pending.',
    ),
  ];

  Future<List<ClientModel>> getClients() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockClients);
  }

  Future<ClientModel?> getClient(String clientId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockClients.firstWhere((c) => c.id == clientId);
    } catch (_) {
      return null;
    }
  }

  Future<ClientModel> createClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockClients.add(client);
    return client;
  }

  Future<ClientModel> updateClient(ClientModel client) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final idx = _mockClients.indexWhere((c) => c.id == client.id);
    if (idx != -1) {
      _mockClients[idx] = client;
    }
    return client;
  }
}

final clientService = ClientService();
