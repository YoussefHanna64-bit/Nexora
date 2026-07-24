import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nexora/core/di/dependency_injection.dart';
import 'package:nexora/core/localization/language_cubit.dart';
import 'package:nexora/core/routers/app_router.dart';
import 'package:nexora/core/theme/app_theme.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/banner/presentation/manager/banner_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:nexora/features/category/presentation/manager/category_cubit.dart';
import 'package:nexora/features/brands/domain/usecases/get_brands_use_case.dart';
import 'package:nexora/features/brands/presentation/manager/brand_cubit.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'core/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path),
  );

  setupGetIt();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      BlocProvider<LanguageCubit>(create: (context) => LanguageCubit()),
      BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
      BlocProvider<CategoryCubit>(
          create: (context) =>
              CategoryCubit(getIt<GetCategoriesUseCase>())..fetchCategories()),
      BlocProvider<BrandCubit>(
          create: (context) =>
              BrandCubit(getIt<GetBrandsUseCase>())..fetchBrands()),
      BlocProvider<BannerCubit>(create: (context) => getIt<BannerCubit>()),
      BlocProvider<CartCubit>(create: (context) => getIt<CartCubit>()),
      BlocProvider<WishlistCubit>(create: (context) => getIt<WishlistCubit>()),
      BlocProvider<ProfileCubit>(create: (context) => getIt<ProfileCubit>()),
      BlocProvider<AddressCubit>(create: (context) => getIt<AddressCubit>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(builder: (context, locale) {
      return BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Nexora',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            locale: locale,
            routerConfig: appRouter,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
          );
        },
      );
    });
  }
}
