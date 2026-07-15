import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: "STRIPE_PUBLISHABLE_KEY", obfuscate: true)
  static final String stripePublishableKey = _Env.stripePublishableKey;

  @EnviedField(varName: "GOOGLE_CLIENT_ID", obfuscate: true)
  static final String googleClientId = _Env.googleClientId;
}
