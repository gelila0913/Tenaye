import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TenayeBrandHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const TenayeBrandHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final trailingWidget = trailing;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and App Name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (canPop) ...[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      'assets/images/logo.jpg',
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ጤናዬ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (trailingWidget != null) trailingWidget,
            ],
          ),
          const SizedBox(height: 8),
          // Page Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            // Page Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
