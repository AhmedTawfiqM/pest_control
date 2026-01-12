import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../localization/app_localizations.dart';
import '../localization/language_cubit.dart';
import '../localization/app_language.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        final currentLanguage = AppLanguage.fromLanguageCode(locale.languageCode);

        return Row(
          children: AppLanguage.values.map((language) {
            final isSelected = currentLanguage == language;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _LanguageOption(
                  language: language,
                  isSelected: isSelected,
                  onTap: () {
                    context.read<LanguageCubit>().changeLanguage(language);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.languageChanged),
                        backgroundColor: AppTheme.success,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              language.flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                language.nativeName,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

