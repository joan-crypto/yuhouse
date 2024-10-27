import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yuhouse/auth/register.dart';
import 'package:yuhouse/auth/indexxxx.dart';
import 'package:yuhouse/utils/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Color _textColor = Colors.blue;

  String _email = '';
  String _password = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Autenticar usuario
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Verificar si userCredential.user no es null
        if (userCredential.user != null) {
          // Verificar si el usuario existe en la colección de Firestore
          DocumentSnapshot userDoc = await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (userDoc.exists) {
            // Usuario autenticado, navegar a la página de inicio
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Inicio()),
            );
          } else {
            // Usuario autenticado no existe en Firestore
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Usuario no encontrado en Firestore.')),
            );
          }
        } else {
          showErrorSnackbar(
              context, 'Error: No se pudo obtener el usuario autenticado.');
        }
      } on FirebaseAuthException catch (e) {
        String mensaje;
        if (e.code == 'user-not-found') {
          mensaje = 'No se encontró un usuario con este correo electrónico.';
        } else if (e.code == 'wrong-password') {
          mensaje = 'Contraseña incorrecta.';
        } else if (e.code == 'too-many-requests') {
          mensaje = 'Demasiados intentos fallidos. Intenta de nuevo más tarde.';
        } else if (e.code == 'network-request-failed') {
          mensaje = 'Error de red. Verifica tu conexión a internet.';
        } else {
          mensaje = 'El usuario no existe';
        }
        showErrorSnackbar(context, mensaje);
      } catch (e) {
        showErrorSnackbar(context, 'Error inesperado');
      }
    }
  }

  void _toRegister(BuildContext context) {
    setState(() {
      // Cambiar el color del texto
      _textColor = _textColor == Colors.blue
          ? const Color.fromARGB(255, 109, 163, 207)
          : Colors.blue;
    });

    // Navegar a la segunda página
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context)
              .size
              .height, // Ajusta al tamaño de la pantalla
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  height: 140,
                ),
                // Logo de la aplicación o imagen superior
                const SizedBox(height: 30),

                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 100,
                            color: Color.fromRGBO(181, 2, 2, 1),
                          ),
                          // Título del formulario
                          const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo para el correo electrónico
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese su email';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                  .hasMatch(value)) {
                                return 'Por favor, ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Campo para la contraseña
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                _password = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),

                          // Botón de iniciar sesión
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Color.fromRGBO(181, 2, 2, 1),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 80.0,
                              ),
                              child: Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Enlace para registrarse o recuperar contraseña
                GestureDetector(
                  onTap: () => _toRegister(context),
                  child: const Text(
                    '¿No tienes cuenta? Regístrate',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
