import 'package:flutter/material.dart';

class RegisterWithCodeScreen extends StatefulWidget {
  const RegisterWithCodeScreen({super.key});

  @override
  State<RegisterWithCodeScreen> createState() => _RegisterWithCodeScreenState();
}

class _RegisterWithCodeScreenState extends State<RegisterWithCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _codeValidated = false;
  bool _isLoading = false;
  String? _validatedRole;

  // Campos del formulario completo
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro con código'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_codeValidated) ...[
                // Solo mostrar campo de código si no está validado
                const Text(
                  'Ingresa tu código de invitación',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Código de invitación',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.confirmation_number),
                    hintText: 'Ej: INV-2024-ABCDEF',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa el código';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _validateCode,
                    child: const Text('Validar código'),
                  ),
                ),
              ],

              if (_codeValidated) ...[
                // Mostrar formulario completo si el código es válido
                const Text(
                  'Completa tu registro',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rol asignado: $_validatedRole',
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Contraseña
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirmar contraseña
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Nombres
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombres',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tus nombres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Apellidos
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Apellidos',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tus apellidos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Cédula
                TextFormField(
                  controller: _idNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Cédula/Pasaporte',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu cédula';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Teléfono
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa tu teléfono';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botón completar registro
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _completeRegistration,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Completar registro'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _validateCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular validación con API
      await Future.delayed(const Duration(seconds: 1));

      // Aquí conectarás con tu API para validar el código
      // Por ahora simulamos que siempre es válido
      
      setState(() {
        _isLoading = false;
        _codeValidated = true;
        _validatedRole = 'Coach'; // Esto vendría de la API
      });
    }
  }

  void _completeRegistration() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular registro
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¡Registro exitoso!'),
          content: const Text('Tu cuenta ha sido creada. Ya puedes iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a login
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      );
    }
  }
}