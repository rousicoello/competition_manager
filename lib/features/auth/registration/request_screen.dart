import 'package:flutter/material.dart';

class RegistrationRequestScreen extends StatefulWidget {
  const RegistrationRequestScreen({super.key});

  @override
  State<RegistrationRequestScreen> createState() => _RegistrationRequestScreenState();
}

class _RegistrationRequestScreenState extends State<RegistrationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _institutionController = TextEditingController();
  
  String? _selectedRole;
  bool _isLoading = false;

  final List<String> _roles = ['Coach', 'Juez', 'Estudiante'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Completa tus datos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tu solicitud será revisada por un administrador',
                style: TextStyle(color: Colors.grey),
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
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu email';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
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
              const SizedBox(height: 16),

              // Rol solicitado
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Rol solicitado',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecciona un rol';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Institución (opcional)
              TextFormField(
                controller: _institutionController,
                decoration: const InputDecoration(
                  labelText: 'Institución (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school),
                ),
              ),
              const SizedBox(height: 24),

              // Documentos
              const Text(
                'Documentos requeridos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Subir cédula
              ListTile(
                leading: const Icon(Icons.description),
                title: const Text('Copia de cédula'),
                subtitle: const Text('PDF o imagen'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Aquí irá la lógica para subir archivo
                  },
                  child: const Text('Subir'),
                ),
              ),

              // Subir documento de respaldo (opcional)
              ListTile(
                leading: const Icon(Icons.file_present),
                title: const Text('Documento de respaldo (opcional)'),
                subtitle: const Text('Carnet, certificado, etc.'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Aquí irá la lógica para subir archivo
                  },
                  child: const Text('Subir'),
                ),
              ),

              const SizedBox(height: 24),

              // Botón enviar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Enviar Solicitud',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Enlace para registro con código
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register-with-code');
                  },
                  child: const Text('¿Tienes un código de invitación? Regístrate aquí'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simular envío a API
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Mostrar mensaje de éxito
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Solicitud enviada'),
          content: const Text(
            'Tu solicitud ha sido enviada. Un administrador la revisará y te contactará.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Volver a login
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }
}