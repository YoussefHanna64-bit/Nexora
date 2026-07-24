import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_images.dart';
import 'package:nexora/features/onboarding/presentation/widgets/onboarding_page.dart';

class OnboardingPages {
  static List<OnboardingPage> build(AppLocalizations l10n) {
    return [
      OnboardingPage(
        title: l10n.onboardingTitle1,
        subtitle: l10n.onboardingSubtitle1,
        image: AppImages.onboarding1,
      ),
      OnboardingPage(
        title: l10n.onboardingTitle2,
        subtitle: l10n.onboardingSubtitle2,
        image: AppImages.onboarding2,
      ),
      OnboardingPage(
        title: l10n.onboardingTitle3,
        subtitle: l10n.onboardingSubtitle3,
        image: AppImages.onboarding3,
      ),
    ];
  }
}
