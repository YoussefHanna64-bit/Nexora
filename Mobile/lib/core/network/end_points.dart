class EndPoints {
  static const String baseUrl = "http://192.168.1.5:5000/api";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String refreshToken = "/auth/refresh";
  static const String forgotPassword = "/auth/forgotPassword";
  static const String verifyOTP = "/auth/verifyOTP";
  static const String resetPassword = "/auth/resetPassword";
  static const String products = "/products";
  static const String activeBanners = "/banners/active";
  static const String categories = "/categories";
  static const String cart = "/cart";
  static const String wishlist = "/wishlist";
  static const String orders = "/orders";
  static const String myOrders = "/orders/my-orders";
  static const String paymentIntent = "/payments/payment-intent";
  static const String users = "/users";
  static const String me = "$users/me";
  static const String updateUser = "$users/updateUser";
  static const String updatePassword = "$users/updatePassword";
  static const String uploadProfilePicture = "$users/uploadProfilePicture";
  static const String addresses = "$users/addresses";
}
