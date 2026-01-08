import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/perfil_service.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  final String? initialName;
  final String? initialEmail;
  const EditProfileScreen({this.initialName, this.initialEmail, Key? key})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _nickController;
  String _sexo = '';
  String _pais = '';
  DateTime? _dataNascimento;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _nickController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nickController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final userId = AuthService().userId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não autenticado!')),
      );
      return;
    }
    final dados = {
      'nome': _nameController.text,
      'email': _emailController.text,
      'nick': _nickController.text,
      'sexo': _sexo,
      'pais': _pais,
      'dataNascimento': _dataNascimento?.toIso8601String() ?? '',
    };
    try {
      await PerfilService().salvarPerfil(userId: userId, dados: dados);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil salvo com sucesso!')),
      );
      Navigator.pop(context, dados);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar perfil: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _nickController,
                decoration: InputDecoration(labelText: 'Nick'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _sexo.isNotEmpty ? _sexo : null,
                items: [
                  DropdownMenuItem(value: 'Homem', child: Text('Homem')),
                  DropdownMenuItem(value: 'Mulher', child: Text('Mulher')),
                ],
                onChanged: (value) {
                  setState(() => _sexo = value ?? '');
                },
                decoration: InputDecoration(labelText: 'Sexo'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _pais.isNotEmpty ? _pais : null,
                items: [
                  DropdownMenuItem(value: 'Brasil', child: Text('🇧🇷 Brasil')),
                  DropdownMenuItem(
                      value: 'Estados Unidos',
                      child: Text('🇺🇸 Estados Unidos')),
                  DropdownMenuItem(value: 'Egito', child: Text('🇪🇬 Egito')),
                  DropdownMenuItem(value: 'Índia', child: Text('🇮🇳 Índia')),
                  // Adicione mais países/bandeiras se quiser
                ],
                onChanged: (value) {
                  setState(() => _pais = value ?? '');
                },
                decoration: InputDecoration(labelText: 'País/Bandeira'),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_dataNascimento == null
                    ? 'Selecionar data de nascimento'
                    : 'Data de nascimento: ${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000, 1, 1),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => _dataNascimento = picked);
                  }
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text('Salvar'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseFirestore.instance.collection('test').add({
                      'timestamp': DateTime.now().toIso8601String(),
                      'msg': 'Teste Firestore',
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Teste Firestore: SUCESSO!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Teste Firestore: ERRO: $e')),
                    );
                  }
                },
                child: Text('Testar conexão Firestore'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
