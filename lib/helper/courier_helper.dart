class CourierHelper {
  // Courier Information
  static const Map<String, dynamic> JNT = {
    'name': 'J&T',
    'website': 'https://www.jtexpress.my/',
  };
  static const Map<String, dynamic> POSLAJU = {
    'name': 'POS LAJU',
    'website': 'https://www.poslaju.com.my/',
  };
  static const Map<String, dynamic> DHL = {
    'name': 'DHL',
    'website': 'https://www.dhl.com/',
  };
  static const Map<String, dynamic> GDEX = {
    'name': 'GDEX',
    'website': 'https://www.gdexpress.com/',
  };

  // Helper method to get courier information by name
  static Map<String, dynamic>? getCourierInfo(String courierName) {
    final couriers = [JNT, POSLAJU, DHL, GDEX];

    for (final courier in couriers) {
      if (courier['name'].toLowerCase() == courierName.toLowerCase()) {
        return courier;
      }
    }

    return null; // Return null if no match is found
  }
}
