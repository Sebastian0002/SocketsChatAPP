// To parse this JSON data, do
//
//     final user = userFromMap(jsonString);

import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));
UserSignUp userSignUpFromMap(String str) => UserSignUp.fromMap(json.decode(str));
String userSignUpToMap(UserSignUp data) => json.encode(data.toMap());

class User {
    final String email;
    final String nombre;
    final bool online;
    final String uid;
    String? token;


    User({
        required this.email,
        required this.nombre,
        required this.online,
        required this.uid,
        this.token,
    });

    factory User.fromMap(Map<String, dynamic> json) => User(
        online: json["online"],
        email: json["email"],
        nombre: json["nombre"],
        uid: json["uid"],
        token: json["token"] ?? ""
    );

    factory User.empty() => User(
        online: false,
        email: "",
        nombre: "",
        uid: "",
        token: ""
    );
}

class UserSignUp {
    final String email;
    final String nombre;
    final String password;

    UserSignUp({
        required this.email,
        required this.nombre,
        required this.password,
    });

    factory UserSignUp.fromMap(Map<String, dynamic> json) => UserSignUp(
        email: json["email"],
        nombre: json["nombre"],
        password: json["password"],
    );
    
    factory UserSignUp.empty() => UserSignUp(
        email: "",
        nombre: "",
        password: "",
    );

    Map<String, dynamic> toMap() => {
        "email": email,
        "nombre": nombre,
        "password": password,
    };
}

