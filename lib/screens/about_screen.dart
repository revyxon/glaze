import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../ui/design_system.dart';
import '../ui/components/app_icon.dart';
import '../ui/components/pro_motion.dart'; // Import Animation Wrapper

// Import Modular Sections
import 'about_sections/about_header.dart';
import 'about_sections/feature_cards.dart';
import 'about_sections/tech_stack.dart';
import 'about_sections/system_diagnostics.dart';
import 'about_sections/developer_info.dart';
import 'about_sections/legal_section.dart';
import 'about_sections/app_timeline.dart'; // New
import 'about_sections/pro_tips_carousel.dart'; // New

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true, // For clearer header viewing
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: theme.scaffoldBackgroundColor.withValues(
              alpha: 0.8,
            ), // Glassy
            surfaceTintColor: Colors.transparent,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.surface.withValues(
                  alpha: 0.5,
                ),
                child: IconButton(
                  icon: AppIcon(AppIconType.back, size: 20),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Back',
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRect(
                child: Container(
                  // Subtle Gradient Overlay for Pro Feel
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            expandedHeight: 0,
            toolbarHeight: 60,
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 0. Hero Header
                AboutHeader(packageInfo: _packageInfo),

                const SizedBox(height: AppSpacing.xxl),

                // 1. Pro Tips (Carousel) - Interactive Start
                ProMotion(index: 1, child: const ProTipsCarousel()),

                const SizedBox(height: 50),

                // 2. Core Feature Cards
                ProMotion(index: 2, child: const FeatureCards()),

                const SizedBox(height: 50),

                // 3. Evolution Timeline
                ProMotion(index: 3, child: const AppTimeline()),

                const SizedBox(height: 50),

                // 4. Tech Stack Grid
                ProMotion(index: 4, child: const TechStack()),

                const SizedBox(height: 50),

                // 5. System Diagnostics
                ProMotion(index: 5, child: const SystemDiagnostics()),

                const SizedBox(height: 50),

                // 6. Developer Profile
                ProMotion(index: 6, child: const DeveloperInfo()),

                const SizedBox(height: 50),

                // 7. Legal Links
                ProMotion(index: 7, child: const LegalSection()),

                const SizedBox(height: 80),

                // 8. Footer
                ProMotion(
                  index: 8,
                  child: Center(
                    child: Column(
                      children: [
                        AppIcon(
                          AppIconType.premium,
                          size: 24,
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ENGINEERED FOR EXCELLENCE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
