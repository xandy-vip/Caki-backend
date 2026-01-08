import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _isRegister = false;

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final url = Uri.parse('https://caki-backend.onrender.com/auth/login');
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userController.text,
          'password': _passController.text,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['token'] != null) {
        AuthService().token = data['token'];
        if (data['userId'] != null) {
          AuthService().userId = data['userId'].toString();
          // Verifica perfil no Firestore
          final docRef = FirebaseFirestore.instance
              .collection('users')
              .doc(AuthService().userId);
          final doc = await docRef.get();
          final dataPerfil = doc.data() ?? {};
          final nick = dataPerfil['nick'] ?? '';
          final sexo = dataPerfil['sexo'] ?? '';
          final pais = dataPerfil['pais'] ?? '';
          final dataNascimento = dataPerfil['dataNascimento'] ?? '';
          if (nick.isEmpty ||
              sexo.isEmpty ||
              pais.isEmpty ||
              dataNascimento.isEmpty) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                  initialName: dataPerfil['nome'] ?? '',
                  initialEmail: dataPerfil['email'] ?? '',
                ),
              ),
            );
          }
        }
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = data['error'] ?? 'Falha no login';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final url = Uri.parse('https://caki-backend.onrender.com/auth/register');
    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _userController.text,
          'password': _passController.text,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200 && data['message'] != null) {
        // Cria usuário no Firebase Auth para email verification
        try {
          UserCredential cred =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _userController.text,
            password: _passController.text,
          );
          await cred.user?.sendEmailVerification();
        } catch (e) {
          // Se já existe, ignora
        }
        setState(() {
          _isRegister = false;
          _error = 'Cadastro realizado! Verifique seu email.';
        });
      } else {
        setState(() {
          _error = data['error'] ?? 'Falha no cadastro';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro de conexão';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _loading = false;
        });
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      AuthService().userId = userCredential.user?.uid;
      AuthService().token = await userCredential.user?.getIdToken();

      // Cria documento do usuário no Firestore se não existir
      final user = userCredential.user;
      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final doc = await docRef.get();
        if (!doc.exists) {
          await docRef.set({
            'nome': user.displayName ?? '',
            'email': user.email ?? '',
            'fotoUrl': user.photoURL ?? '',
          });
        }
        final data = doc.data() ?? {};
        final nick = data['nick'] ?? '';
        final sexo = data['sexo'] ?? '';
        final pais = data['pais'] ?? '';
        final dataNascimento = data['dataNascimento'] ?? '';
        if (nick.isEmpty ||
            sexo.isEmpty ||
            pais.isEmpty ||
            dataNascimento.isEmpty) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfileScreen(
                      initialName: user.displayName,
                      initialEmail: user.email,
                    )),
          );
        }
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao entrar com Google';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isRegister ? 'Cadastro' : 'Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              SizedBox(height: 12),
              TextField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              if (_error != null) ...[
                Text(_error!,
                    style: TextStyle(
                        color: _error == 'Cadastro realizado! Faça login.'
                            ? Colors.green
                            : Colors.red)),
                SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: _loading ? null : (_isRegister ? _register : _login),
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(_isRegister ? 'Cadastrar' : 'Entrar'),
              ),
              if (!_isRegister) ...[
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Image.asset(
                    'assets/google_logo.png',
                    height: 24,
                  ),
                  label: Text('Entrar com Google'),
                  onPressed: _loading ? null : _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
              TextButton(
                onPressed: _loading
                    ? null
                    : () {
                        setState(() {
                          _isRegister = !_isRegister;
                          _error = null;
                        });
                      },
                child: Text(_isRegister
                    ? 'Já tem conta? Login'
                    : 'Não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
