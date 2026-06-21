import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class PaymentService {
  Future<Either<Failure, void>> processPayment(String clientSecret);
}
