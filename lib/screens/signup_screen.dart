import 'package:flutter/material.dart';
import 'package:iron_kids/styles/app_theme.dart';
import 'package:iron_kids/styles/widgets.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageBack(),
          FormSignUp(),
        ],
      ),
    );
  }
}

class ImageBack extends StatelessWidget {
  const ImageBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.amber,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://firebasestorage.googleapis.com/v0/b/iron-kids-app.appspot.com/o/OtherResources%2Fbackground.png?alt=media&token=eca452ff-3ffe-4eda-9bde-612bc4f0a9e7'),
          ),
        ),
        child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/iron-kids-app.appspot.com/o/Ilustraciones%2FMotherhood.png?alt=media&token=8d51fdd4-297b-468e-91ff-bcf2158196f4'),
      ),
    );
  }
}

class FormSignUp extends StatelessWidget {
  FormSignUp({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing6),
      decoration: BoxDecoration(
        color: AppTheme.primary400,
        borderRadius: AppTheme.borderRadiusM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTheme.spacingWidget8,
          Text(
            'Registrarse',
            style: textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          AppTheme.spacingWidget2,
          Text(
            '¡Créate una cuenta para que puedas guardar tus controles y registros!',
            style: textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          AppTheme.spacingWidget7,
          InputField(
            controller: emailController,
            placeholder: 'Ingresa tu correo',
            iconLeft: Icons.person_2_outlined,
          ),
          AppTheme.spacingWidget5,
          InputField(
            controller: passwordController,
            placeholder: 'Ingresa tu contraseña',
            iconLeft: Icons.lock_outline_rounded,
            iconRight: Icons.remove_red_eye_outlined,
          ),
          AppTheme.spacingWidget5,
          const ButtonPrimary(
            'Inicia sesión',
            size: 2,
          ),
          AppTheme.spacingWidget6,
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: AppTheme.gray400,
                height: 2,
                width: 100,
              ),
              Text(
                'O registrate con',
                style: textTheme.bodySmall,
              ),
              Container(
                color: AppTheme.gray400,
                height: 2,
                width: 100,
              ),
            ],
          )
        ],
      ),
    );
  }
}
