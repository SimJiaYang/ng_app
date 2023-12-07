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

  // Params
  static const String CUSTOM_STATUS = 'custom';
  static const String ACTIVE_STATUS = '1';

  // Plant Type
  static const String LOTUS = "lotus";
  static const String DESERT_ROSE = "desert rose";
  static const String HYDRANGEAS = "hydrangeas";
  static const String CACTUS = "cactus";

  // Product Type
  static const String POT = "pot";
  static const String SOIL = "soil";

  // Address Tye
  static const String ADDRESS_PACK = 'Seller is preparing your parcel';
  static const String ADDRESS_SHIP = 'Your parcel is on the way';
  static const String ADDRESS_DELIVER = 'Your parcel has been delivered';

  // Upload Image/File
  static const String UPLOAD_IMAGE = '/upload_file';

  // Auth
  static const String REGISTER_URI = '/register';
  static const String LOGIN_URI = '/login';
  static const String LOGOUT_URI = '/logout';

  // User
  static const String PROFILE_URI = '/profile';
  static const String PROFILE_UPDATE_URI = '/profile/update';
  static const String PROFILE_IMAGE_UPLOAD_URI = '/profile/avatar/update';
  static const String USER_INFO = '/user/info';
  static const String CHANGE_PASSWORD_URI = '/profile/password/update';

  // Plant
  static const String PLANT_LIST_URI = '/plantlist';
  static const String PLANT_SEARCH = '/plant/search';
  static const String PLANT_SEARCH_KEYWORD = '/plant/search/keyword';

  // Product
  static const String PRODUCT_LIST_URI = '/productlist';
  static const String PRODUCT_SEARCH = '/product/search';
  static const String PRODUCT_SEARCH_KEYWORD = '/product/search/keyword';

  // Cart
  static const String CART_URI = '/cart';
  static const String ADD_TO_CART_URI = '/cart/add';
  static const String DELETE_CART_URI = '/cart/delete';
  static const String UPDATE_CART_URI = '/cart/update';

  // Customize
  static const String CUSTOMIZE_ITEM_URI = '/custom';
  static const String CUSTOMIZE_ITEM_ADD_ORDER = '/custom/order';

  // Order
  static const String ORDER_URI = '/order';
  static const String ORDER_CREATE_URL = '/order/create';
  static const String ORDER_DETAIL_URI = '/order/detail';
  static const String ORDER_RECEIPT_URI = '/order/receipt';
  static const String ORDER_CANCEL_URI = '/order/cancel';

  // Payment
  static const String PAYMENT_URI = '/order/payment/intent';
  static const String PAYMENT_SUCCESS_HANDLING = '/order/payment/succeed';

  // Address
  static const String ADDRESS_URI = '/address';
  static const String ADD_ADDRESS_URI = '/address/add';
  static const String UPDATE_ADDRESS_URI = '/address/update';
  static const String DELETE_ADDRESS_URI = '/address/delete';

  // Delivery
  static const String DELIVERY_URI = '/delivery';
  static const String DELIVERY_DETAIL_URI = '/delivery/detail';
  static const String DELIVERY_RECEIPT_URI = '/delivery/receipt';

  // Shared Key
  static const String THEME = 'theme';
  static const String TOKEN = 'token';
  static const String PLANT_TOKEN = 'plant_token';
  static const String PRODUCT_TOKEN = 'product_token';
}
