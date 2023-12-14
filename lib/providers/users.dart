import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:http/http.dart' as http;

class Users extends ChangeNotifier {
  static const _baseUrl =
      'https://flutter-atividade-default-rtdb.firebaseio.com/';
  Map<String, User> _items = {};

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  Future<void> put(User user) async {
    if (user == null) {
      return;
    }

    try {
      if (user.id != null && user.id.trim().isNotEmpty) {
        final response = await http.put(
          Uri.parse("$_baseUrl/users/${user.id}.json"),
          body: json.encode({
            'nome': user.nome,
            'email': user.email,
            'avatarURL': user.avatarURL,
          }),
        );

        if (response.statusCode == 200) {
          _items.update(
            user.id,
            (_) => User(
              id: user.id,
              nome: user.nome,
              email: user.email,
              avatarURL: user.avatarURL,
            ),
          );
        }
      } else {
        final response = await http.post(
          Uri.parse("$_baseUrl/users.json"),
          body: json.encode({
            'nome': user.nome,
            'email': user.email,
            'avatarURL': user.avatarURL,
          }),
        );

        final responseBody = json.decode(response.body);
        if (responseBody != null && responseBody.containsKey('name')) {
          final id = responseBody['name'];
          _items.putIfAbsent(
            id,
            () => User(
              id: id,
              nome: user.nome,
              email: user.email,
              avatarURL: user.avatarURL,
            ),
          );
        }
      }

      notifyListeners();
    } catch (error) {
      print('Erro ao realizar operação: $error');
      // Adicione tratamento de erro adequado conforme necessário
    }
  }

  void remove(User user) {
    if (user != null && user.id != null) {
      _items.remove(user.id);
      notifyListeners();
    }
  }
}
