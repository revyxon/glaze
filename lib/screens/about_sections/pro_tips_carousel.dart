import 'package:flutter/material.dart';
import '../../ui/design_system.dart';
import '../../ui/components/app_icon.dart';

class ProTipsCarousel extends StatefulWidget {
  const ProTipsCarousel({super.key});

  @override
  State<ProTipsCarousel> createState() => _ProTipsCarouselState();
}

class _ProTipsCarouselState extends State<ProTipsCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  final List<Map<String, dynamic>> _tips = [
    {
      'icon': AppIconType.calculator,
      'title': 'L-Corner Shortcuts',
      'desc':
          'For L-Corner windows, you can toggle between Formula A and Formula B instantly by tapping the formula icon in the input screen.',
      'color': Colors.blue,
    },
    {
      'icon': AppIconType.sync,
      'title': 'Force Sync',
      'desc':
          'Pull down from the top of the main dashboard to trigger an immediate cloud synchronization cycle.',
      'color': Colors.green,
    },
    {
      'icon': AppIconType.print,
      'title': 'Custom Invoices',
      'desc':
          'Long press the "Print" button to access advanced PDF settings like hiding prices or including technician notes.',
      'color': Colors.purple,
    },
    {
      'icon': AppIconType.theme,
      'title': 'OLED Mode',
      'desc':
          'Switch to "Dark Mode" in settings to activate True Black interface, saving battery on OLED screens.',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PRO TIPS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.7),
                ),
              ),
              _buildIndicators(context),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _tips.length,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemBuilder: (context, index) {
              final tip = _tips[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (tip['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: (tip['color'] as Color).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: AppIcon(
                              tip['icon'],
                              color: tip['color'],
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tip['title'],
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: tip['color'],
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              tip['desc'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIndicators(BuildContext context) {
    return Row(
      children: List.generate(_tips.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(left: 4),
          width: _currentPage == index ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
