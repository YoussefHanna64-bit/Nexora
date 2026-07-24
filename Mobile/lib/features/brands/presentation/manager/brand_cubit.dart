import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/brands/domain/usecases/get_brands_use_case.dart';
import 'package:nexora/features/brands/presentation/manager/brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  final GetBrandsUseCase getBrandsUseCase;

  BrandCubit(this.getBrandsUseCase) : super(BrandInitial());

  Future<void> fetchBrands() async {
    emit(BrandLoading());

    final result = await getBrandsUseCase();

    result.fold(
      (failure) {
        emit(BrandError(message: failure.message));
      },
      (brands) {
        emit(BrandLoaded(brands));
      },
    );
  }
}
