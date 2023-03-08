import 'package:flutter/material.dart';
import 'package:iron_kids/styles/appTheme.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Formlogin(),
          ],
        ),
      ),
    );
  }
}

//Formulario del login
class Formlogin extends StatelessWidget {
  const Formlogin({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.gray500,
        borderRadius: AppTheme.borderRadiusXL,
      ),
      child: Column(
        children: [
          Text(
            '¡Bienvenido de vuelta!',
            style: AppTheme.headlineSmall(context),
          ),
          AppTheme.spacingWidget3, //espaciador
          Text(
            'Ingresa tus datos en la parte de abajo',
            style: AppTheme.bodySmallMedium(context),
          ),
          AppTheme.spacingWidget7, //espaciador
          InputField(
            controller: _emailController,
            placeholder: 'Ingresa tu correo electrónico',
          ),
          AppTheme.spacingWidget5, //espaciador
          InputField(
            controller: _passwordController,
            placeholder: 'Ingresa tu contraseña',
          ),
          AppTheme.spacingWidget5,
          Text(
            '¿Olvidaste tu contraseña?',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: AppTheme.gray500,
              fontSize: 13, //Mencionar a Axel sobre este inconveniente
            ),
          ),
          AppTheme.spacingWidget5,
          const ButtonUI(text: 'Inicia sesión'),
        ],
      ),
    );
  }
}

//Widget de los Inputs
class InputField extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final String placeholder;
  InputField({
    super.key,
    required this.controller,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.gray50,
        borderRadius: AppTheme.borderRadiusL,
        border: Border.all(
          color: AppTheme.gray300,
          width: 1.0,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
            hintStyle: AppTheme.labelLarge(context)),
        obscureText: true,
      ),
    );
  }
}

//Widget boton
class ButtonUI extends StatelessWidget {
  final String text;

  const ButtonUI({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implementar la lógica de autenticación aquí
        final String email = _emailController.text.trim();
        final String password = _passwordController.text.trim();
        // Validar las credenciales y continuar a la siguiente pantalla
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary500,
        minimumSize: const Size(350, 58),
        shape: RoundedRectangleBorder(
          borderRadius:
              AppTheme.borderRadiusL, // personaliza el radio de los bordes
        ),
      ),
      child: Text((text != null) ? text : 'Inserta texto'),
    );
  }
}
