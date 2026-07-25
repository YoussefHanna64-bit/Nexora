import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/feedback/presentation/manager/feedback_cubit.dart';
import 'package:nexora/features/feedback/presentation/manager/feedback_state.dart';
import 'package:nexora/features/feedback/presentation/widgets/type_selector.dart';

class ReportBugTab extends StatefulWidget {
  const ReportBugTab({super.key});

  @override
  State<ReportBugTab> createState() => _ReportBugTabState();
}

class _ReportBugTabState extends State<ReportBugTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  String _selectedType = "bug";

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return BlocConsumer<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          _messageController.clear();
          AppSnackbars.showSuccess(context, l10n.feedbackSentSuccess);
        } else if (state is FeedbackError) {
          AppSnackbars.showError(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is FeedbackLoading;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  l10n.feedbackType,
                  style: AppTextStyles.bold14Black.copyWith(color: onSurface),
                ),
                const SizedBox(height: 12),
                TypeSelector(
                  selectedType: _selectedType,
                  onTypeSelected: isLoading
                      ? null
                      : (type) {
                          setState(() {
                            _selectedType = type;
                          });
                        },
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.describe,
                  style: AppTextStyles.bold14Black.copyWith(color: onSurface),
                ),
                const SizedBox(height: 12),
                CustomTextFormField(
                  hintText: l10n.feedbackHint,
                  controller: _messageController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  validator: (val) => Validators.feedback(context, val),
                ),
                const SizedBox(height: 12),
                CustomPrimaryButton(
                  buttonText: l10n.submitFeedback,
                  isLoading: isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<FeedbackCubit>().submitFeedback(
                            message: _messageController.text.trim(),
                            type: _selectedType,
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
