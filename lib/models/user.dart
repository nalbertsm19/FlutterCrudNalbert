import 'package:flutter/material.dart';

class User {
  final String id;
  final String nome;
  final String email;
  final String avatarURL;

  const User({
    required this.id,
    required this.nome,
    required this.email,
    required this.avatarURL,
  });
}
