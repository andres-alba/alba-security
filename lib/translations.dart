import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'welcome_text': 'Security Guard',
          'welcome_button': 'Log In',
          'back_button_alert': 'Do you really want to exit',
          'login_email': 'Enter your email',
          'login_pass': 'Enter your password',
          'settings_phone': 'Phone Number',
          'settings_email': 'Email',
          'settings_signout': 'Sign out',
          'settings_language': 'Language',
          'settings_account': 'Account',
          'settings_security': 'Security',
          'settings_common': 'Common',
          'settings_lockapp': 'Lock app in background',
        },
        'es_CO': {
          'hello': 'Hola',
          'welcome_text': 'Vigilante de Seguridad',
          'welcome_button': 'Iniciar',
          'back_button_alert': 'En serio quieres salirte? ',
          'login_email': 'Correo electronico',
          'login_pass': 'clave',
          'settings_phone': 'Numero telefonico',
          'settings_email': 'Correo Electronico',
          'settings_signout': 'Salir de Cuenta',
          'settings_language': 'Idioma',
          'settings_account': 'Cuenta',
          'settings_security': 'Seguridad',
          'settings_common': 'En Comun',
          'settings_lockapp': 'Bloquear app en fondo',
        }
      };
}
