import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../config/app_data.dart';
import '../providers/settings_provider.dart';
import '../ui/components/app_icon.dart';
import '../ui/design_system.dart';

/// Epic Pro-Level About Screen with 30 Premium Sections
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
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _packageInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();
    final isDark = theme.brightness == Brightness.dark;
    final accent = settings.accentColor;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: AppIcon(
                  AppIconType.back,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroSection(
                accent: accent,
                isDark: isDark,
                version: _packageInfo?.version ?? '1.2.1',
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ═══════════════════════════════════════════════════════════
                // SECTION 1: Quick Stats Row
                // ═══════════════════════════════════════════════════════════
                _QuickStatsRow(
                  version: _packageInfo?.version ?? '1.2.1',
                  buildNum: _packageInfo?.buildNumber ?? '1',
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 2: What is Glaze? (Large intro card)
                // ═══════════════════════════════════════════════════════════
                _LargeIntroCard(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 3-6: Core Features (4 Big Cards)
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Core Features',
                  subtitle: 'What makes Glaze powerful',
                  icon: AppIconType.sparkle,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _CoreFeaturesGrid(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 7-8: Measurement System
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Precision Measurement',
                  subtitle: 'Industry-leading calculation engine',
                  icon: AppIconType.measurement,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _MeasurementSection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 9-10: Enquiry Management
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Enquiry Management',
                  subtitle: 'Complete customer lifecycle',
                  icon: AppIconType.enquiry,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _EnquirySection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 11-12: Document Generation
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Document Automation',
                  subtitle: 'Professional agreements instantly',
                  icon: AppIconType.file,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _DocumentSection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 13-22: Full Tech Stack (All 10 SVGs)
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Technology Stack',
                  subtitle: 'Built with cutting-edge tools',
                  icon: AppIconType.code,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _FullTechStackSection(isDark: isDark, accent: accent),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 23-24: Data Architecture
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Offline-First Architecture',
                  subtitle: 'Works anywhere, syncs everywhere',
                  icon: AppIconType.database,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ArchitectureSection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 25-26: Design System
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Premium Design System',
                  subtitle: 'Personalize your experience',
                  icon: AppIconType.palette,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _DesignSystemSection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 27-28: Window & Glass Configuration
                // ═══════════════════════════════════════════════════════════
                _SectionTitle(
                  title: 'Configuration Options',
                  subtitle: 'All window types supported',
                  icon: AppIconType.window,
                  accent: accent,
                ),
                const SizedBox(height: AppSpacing.lg),
                _ConfigurationSection(accent: accent, isDark: isDark),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 29: Open Source Licenses
                // ═══════════════════════════════════════════════════════════
                _OpenSourceCard(
                  accent: accent,
                  isDark: isDark,
                  packageInfo: _packageInfo,
                ),
                const SizedBox(height: AppSpacing.xxxl),

                // ═══════════════════════════════════════════════════════════
                // SECTION 30: Developer Credits
                // ═══════════════════════════════════════════════════════════
                _DeveloperCreditsCard(accent: accent, isDark: isDark),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HERO SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _HeroSection extends StatelessWidget {
  final Color accent;
  final bool isDark;
  final String version;

  const _HeroSection({
    required this.accent,
    required this.isDark,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accent.withValues(alpha: isDark ? 0.25 : 0.12),
            accent.withValues(alpha: isDark ? 0.08 : 0.03),
            theme.scaffoldBackgroundColor,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [accent, accent.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: AppIcon(
                  AppIconType.window,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // App Name
            Text(
              'Glaze',
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 42,
                letterSpacing: -1,
                color: accent,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Professional Window Measurement',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // Version Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: 0.3)),
              ),
              child: Text(
                'Version $version',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SECTION TITLE
// ══════════════════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final AppIconType icon;
  final Color accent;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: AppIcon(icon, size: 24, color: accent),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          height: 3,
          width: 50,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// QUICK STATS ROW
// ══════════════════════════════════════════════════════════════════════════════

class _QuickStatsRow extends StatelessWidget {
  final String version;
  final String buildNum;
  final Color accent;

  const _QuickStatsRow({
    required this.version,
    required this.buildNum,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = [
      ('v$version', 'Version', AppIconType.rocket, Colors.blue),
      ('Build $buildNum', 'Release', AppIconType.code, Colors.purple),
      ('Flutter', 'Framework', AppIconType.device, Colors.cyan),
      ('M3', 'Design', AppIconType.palette, Colors.orange),
    ];

    return Row(
      children: stats
          .map(
            (s) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: s.$4.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: AppIcon(s.$3, size: 18, color: s.$4),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      s.$1,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      s.$2,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// LARGE INTRO CARD
// ══════════════════════════════════════════════════════════════════════════════

class _LargeIntroCard extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _LargeIntroCard({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: isDark ? 0.15 : 0.08),
            accent.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(AppIconType.info, size: 28, color: accent),
              const SizedBox(width: AppSpacing.md),
              Text(
                'What is Glaze?',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Glaze is a high-performance, professional-grade application designed for precision window measurement, customer enquiry tracking, and automated work agreement generation.',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Built with a robust offline-first architecture, it ensures seamless operation in the field with secure background cloud synchronization.',
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CORE FEATURES GRID (4 Big Feature Cards)
// ══════════════════════════════════════════════════════════════════════════════

class _CoreFeaturesGrid extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _CoreFeaturesGrid({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final features = [
      (
        'Precision Measurement',
        'Automated SqFt calculations with sub-millimeter accuracy for any window configuration including complex shapes.',
        AppIconType.measurement,
        Colors.blue,
      ),
      (
        'Smart Enquiry Tracking',
        'Complete lifecycle management from lead capture to project completion with intelligent reminders and status updates.',
        AppIconType.enquiry,
        Colors.orange,
      ),
      (
        'Document Automation',
        'Generate professional PDF work agreements instantly with customizable templates and one-tap digital sharing.',
        AppIconType.file,
        Colors.green,
      ),
      (
        'Offline-First Design',
        'Full functionality without internet connection. Data syncs automatically and securely when connectivity is restored.',
        AppIconType.sync,
        Colors.purple,
      ),
    ];

    return Column(
      children: features
          .map(
            (f) => _BigFeatureCard(
              title: f.$1,
              description: f.$2,
              icon: f.$3,
              color: f.$4,
              isDark: isDark,
            ),
          )
          .toList(),
    );
  }
}

class _BigFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final AppIconType icon;
  final Color color;
  final bool isDark;

  const _BigFeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: isDark ? 0.15 : 0.08),
            color.withValues(alpha: isDark ? 0.05 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AppIcon(icon, size: 28, color: color),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// MEASUREMENT SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _MeasurementSection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _MeasurementSection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      (
        'Dynamic SqFt Calculations',
        'Automatic area computation with configurable divisors',
        AppIconType.calculator,
      ),
      (
        'Multi-Window Support',
        'Handle unlimited windows with individual measurements',
        AppIconType.window,
      ),
      (
        'Hold Item Management',
        'Track on-hold items separately with optional totals',
        AppIconType.pause,
      ),
      (
        'Notes & Details',
        'Add comprehensive notes to each measurement entry',
        AppIconType.edit,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < items.length - 1 ? AppSpacing.lg : 0,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.$2,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppIcon(item.$3, size: 22, color: accent),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ENQUIRY SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _EnquirySection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _EnquirySection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withValues(alpha: isDark ? 0.12 : 0.06),
            Colors.orange.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: const Column(
        children: [
          _EnquiryFeatureRow(
            icon: AppIconType.customer,
            title: 'Customer Profiling',
            value: 'Name, location, contact details',
            accent: Colors.orange,
          ),
          SizedBox(height: AppSpacing.lg),
          _EnquiryFeatureRow(
            icon: AppIconType.calendar,
            title: 'Smart Reminders',
            value: 'Date-based follow-up tracking',
            accent: Colors.orange,
          ),
          SizedBox(height: AppSpacing.lg),
          _EnquiryFeatureRow(
            icon: AppIconType.check,
            title: 'Status Management',
            value: 'Pending → In Progress → Completed',
            accent: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _EnquiryFeatureRow extends StatelessWidget {
  final AppIconType icon;
  final String title;
  final String value;
  final Color accent;

  const _EnquiryFeatureRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: AppIcon(icon, size: 22, color: accent),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DOCUMENT SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _DocumentSection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _DocumentSection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BigFeatureCard(
          title: 'PDF Work Agreements',
          description:
              'Generate professional, print-ready documents with customer details, measurements, terms and conditions.',
          icon: AppIconType.file,
          color: Colors.red,
          isDark: isDark,
        ),
        _BigFeatureCard(
          title: 'Multi-Channel Sharing',
          description:
              'Share via WhatsApp, Email, or any app on your device with one tap. Direct PDF export available.',
          icon: AppIconType.share,
          color: Colors.green,
          isDark: isDark,
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// FULL TECH STACK SECTION (All 10 SVG Icons)
// ══════════════════════════════════════════════════════════════════════════════

class _FullTechStackSection extends StatelessWidget {
  final bool isDark;
  final Color accent;

  const _FullTechStackSection({required this.isDark, required this.accent});

  static const _techStack = [
    (
      'Flutter',
      'Cross-platform UI framework',
      'assets/tech/flutter-icon.svg',
      Color(0xFF02569B),
    ),
    (
      'Dart',
      'Modern programming language',
      'assets/tech/dart-programming-language-icon.svg',
      Color(0xFF0175C2),
    ),
    (
      'Firebase',
      'Backend & cloud services',
      'assets/tech/google-firebase-icon.svg',
      Color(0xFFFFCA28),
    ),
    (
      'SQLite',
      'Local database engine',
      'assets/tech/sqlite-icon.svg',
      Color(0xFF003B57),
    ),
    (
      'Material 3',
      'Google design system',
      'assets/tech/material-design-svgrepo-com.svg',
      Color(0xFF757575),
    ),
    (
      'Android',
      'Mobile platform',
      'assets/tech/android-robot-bot-icon.svg',
      Color(0xFF3DDC84),
    ),
    (
      'VS Code',
      'Development IDE',
      'assets/tech/visual-studio-code-icon.svg',
      Color(0xFF007ACC),
    ),
    (
      'GitHub',
      'Version control',
      'assets/tech/github-icon.svg',
      Color(0xFF181717),
    ),
    (
      'Figma',
      'Design collaboration',
      'assets/tech/figma-icon.svg',
      Color(0xFFF24E1E),
    ),
    (
      'Docker',
      'Containerization',
      'assets/tech/docker-icon.svg',
      Color(0xFF2496ED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: _techStack
          .map(
            (tech) => Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tech.$4.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgPicture.asset(
                      tech.$3,
                      colorFilter: isDark && tech.$1 == 'GitHub'
                          ? const ColorFilter.mode(
                              Colors.white70,
                              BlendMode.srcIn,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tech.$1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          tech.$2,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tech.$4.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Core',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: tech.$4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ARCHITECTURE SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _ArchitectureSection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _ArchitectureSection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final steps = [
      (
        'Local Write',
        'All data writes go to SQLite first with a sync flag for tracking.',
        Colors.blue,
      ),
      (
        'Background Sync',
        'SyncService monitors connectivity and batches dirty records.',
        Colors.orange,
      ),
      (
        'Cloud Push',
        'Data is securely uploaded to Firebase Firestore when online.',
        Colors.green,
      ),
      (
        'Optimistic UI',
        'UI updates instantly while sync happens in the background.',
        Colors.purple,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: isDark ? 0.12 : 0.06),
            accent.withValues(alpha: isDark ? 0.04 : 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          final isLast = i == steps.length - 1;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: step.$3,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: step.$3.withValues(alpha: 0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.$2,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                        if (!isLast) const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
// ══════════════════════════════════════════════════════════════════════════════
// DESIGN SYSTEM SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _DesignSystemSection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _DesignSystemSection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BigFeatureCard(
          title: '24 Premium Accents',
          description:
              'Personalize your experience with a curated selection of vibrant accent colors that adapt to both light and dark modes.',
          icon: AppIconType.palette,
          color: accent,
          isDark: isDark,
        ),
        _BigFeatureCard(
          title: '10 Surface Variants',
          description:
              'Choose from 10 sophisticated background styles ranging from absolute pure black to warm paper-like surfaces.',
          icon: AppIconType.surface,
          color: Colors.grey,
          isDark: isDark,
        ),
        _BigFeatureCard(
          title: 'Icon Pack Support',
          description:
              'Switch between 10 different icon libraries including Material, Fluent, Phosphor, and more to match your aesthetic.',
          icon: AppIconType.icons,
          color: Colors.pink,
          isDark: isDark,
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// CONFIGURATION SECTION
// ══════════════════════════════════════════════════════════════════════════════

class _ConfigurationSection extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _ConfigurationSection({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon(AppIconType.window, size: 24, color: accent),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Supported Window Types',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppData.windowTypes
                .map(
                  (type) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: accent.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          type.code,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: accent,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          type.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Row(
            children: [
              AppIcon(AppIconType.glass, size: 24, color: Colors.cyan),
              SizedBox(width: AppSpacing.md),
              Text(
                'Glass Variants',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppData.glassTypes
                .map(
                  (glass) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.cyan.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      glass,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// OPEN SOURCE CARD
// ══════════════════════════════════════════════════════════════════════════════

class _OpenSourceCard extends StatelessWidget {
  final Color accent;
  final bool isDark;
  final PackageInfo? packageInfo;

  const _OpenSourceCard({
    required this.accent,
    required this.isDark,
    required this.packageInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: isDark ? 0.15 : 0.08),
            Colors.purple.withValues(alpha: isDark ? 0.15 : 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const AppIcon(AppIconType.code, size: 32, color: Colors.blue),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Open Source',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Powered by amazing open source packages',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () => showLicensePage(
              context: context,
              applicationName: 'Glaze',
              applicationVersion: packageInfo?.version ?? '1.2.1',
              applicationIcon: Padding(
                padding: const EdgeInsets.all(20),
                child: AppIcon(AppIconType.window, size: 48, color: accent),
              ),
            ),
            icon: const AppIcon(AppIconType.file, size: 18),
            label: const Text('View Licenses'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// DEVELOPER CREDITS CARD
// ══════════════════════════════════════════════════════════════════════════════

class _DeveloperCreditsCard extends StatelessWidget {
  final Color accent;
  final bool isDark;

  const _DeveloperCreditsCard({required this.accent, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppIcon(AppIconType.sparkle, size: 24, color: accent),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Crafted with ❤️ by',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Adarsh Tiwari',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: accent,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          '© 2026 Glaze. All rights reserved.',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}
