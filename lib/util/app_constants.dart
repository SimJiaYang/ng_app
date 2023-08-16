import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String url = dotenv.env['APP_BASE_URL']!;
  static String prefix = dotenv.env['APP_URL_PREFIX']!;
  static const String APP_NAME = "Nursery Garden App";
  static const String APP_VERSION = 'v 0.0.1';
  static const String APP_URI = '';
  static final String BASE_URI = url + prefix;
  static final String NO_MORE_DATA = 'No More Data...';
  static final String APP_KEY = dotenv.env['APP_KEY']!;

  // Dialog Type
  static const String DIALOG_SUCCESS = 'success';
  static const String DIALOG_FAILED = 'failed';
  static const String DIALOG_ERROR = 'error';
  static const String DIALOG_INFORMATION = 'information';
  static const String DIALOG_ALERT = 'alert';
  static const String DIALOG_CONFIRMATION = 'confirmation';
  static const String DIALOG_CUSTOM = 'custom';
  static const String DIALOG_WARNING = 'warning';

  // Shackbar Type
  static const String SNACKBAR_SUCCESS = 'success';
  static const String SNACKBAR_ERROR = 'error';
  static const String SNACKBAR_WARNING = 'warning';
  static const String SNACKBAR_INFO = 'info';

  // Upload Image/File
  static const String UPLOAD_IMAGE = '/upload_file';

  // Auth
  static const String REGISTER_URI = '/register';
  static const String LOGIN_URI = '/login';
  static const String LOGOUT_URI = '/logout';

  // Plant
  static const String PLANT_URI = '/plant';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
}
