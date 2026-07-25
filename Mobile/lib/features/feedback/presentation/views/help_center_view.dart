import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/features/feedback/presentation/widgets/faq_tab.dart';
import 'package:nexora/features/feedback/presentation/widgets/report_bug_tab.dart';

class HelpCenterView extends StatelessWidget {
  const HelpCenterView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar(
          title: l10n.helpCenter,
          showBackButton: true,
        ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              labelStyle: AppTextStyles.bold14Primary,
              unselectedLabelStyle:
                  AppTextStyles.regular14Grey.copyWith(color: onSurface),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: l10n.faq),
                Tab(text: l10n.reportABug),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  const FaqTab(),
                  const ReportBugTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
