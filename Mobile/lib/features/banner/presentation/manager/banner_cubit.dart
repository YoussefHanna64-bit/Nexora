import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/banner/domain/usecases/get_active_banners_use_case.dart';
import 'package:nexora/features/banner/presentation/manager/banner_state.dart';

class BannerCubit extends Cubit<BannerState> {
  final GetActiveBannersUseCase getActiveBannersUseCase;

  BannerCubit(this.getActiveBannersUseCase) : super(BannerInitial());

  Future<void> fetchBanners() async {
    emit(BannerLoading());

    final result = await getActiveBannersUseCase();

    result.fold(
      (failure) {
        emit(BannerError(failure.message));
      },
      (banners) {
        emit(BannerLoaded(banners));
      },
    );
  }
}
