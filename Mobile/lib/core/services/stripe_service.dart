import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nexora/core/constants/api_keys.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/orders/domain/services/payment_service.dart';

class StripeService implements PaymentService {
  StripeService() {
    Stripe.publishableKey = ApiKeys.stripePublishableKey;
  }

  @override
  Future<Either<Failure, void>> processPayment(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Nexora",
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      return const Right(null);
    } on StripeException catch (e) {
      return Left(ServerFailure(
          e.error.localizedMessage ?? "Payment cancelled or failed"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
