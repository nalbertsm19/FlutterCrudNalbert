import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/providers/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String?> _formData = {};

  void _loadFormData(User? user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['nome'] = user.nome;
      _formData['email'] = user.email;
      _formData['avatarURL'] = user.avatarURL;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as User?;

    _loadFormData(user);

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final isValid = _form.currentState?.validate() ?? false;

              if (isValid) {
                _form.currentState?.save();

                setState(() {
                  _isLoading = true;
                });

                await Provider.of<Users>(context, listen: false).put(
                  User(
                    id: _formData['id'] ?? '',
                    nome: _formData['nome'] ?? '',
                    email: _formData['email'] ?? '',
                    avatarURL: _formData['avatarURL'] ?? '',
                  ),
                );

                setState(() {
                  _isLoading = false;
                });

                // Navigate back to the list of users after saving
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['nome'],
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nome inválido';
                        }
                        if (value.trim().length < 3) {
                          return 'Nome muito pequeno. No mínimo 3 letras!';
                        }
                        return null;
                      },
                      onSaved: (value) => _formData['nome'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      onSaved: (value) => _formData['email'] = value,
                    ),
                    TextFormField(
                      initialValue: _formData['avatarURL'],
                      decoration: InputDecoration(labelText: 'URL do Avatar'),
                      onSaved: (value) => _formData['avatarURL'] = value,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
