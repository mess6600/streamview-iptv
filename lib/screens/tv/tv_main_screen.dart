import 'package:flutter/material.dart';
import 'tv_home_screen.dart';
import 'tv_epg_screen.dart';
import 'tv_favorites_screen.dart';
import 'tv_settings_screen.dart';
import '../../utils/theme.dart';

class TVMainScreen extends StatefulWidget {
  const TVMainScreen({super.key});

  @override
  State<TVMainScreen> createState() => _TVMainScreenState();
}

class _TVMainScreenState extends State<TVMainScreen> {
  int _currentIndex = 0;
  final FocusNode _focusNode = FocusNode();

  final List<Widget> _screens = [
    const TVHomeScreen(),
    const TVEPGScreen(),
    const TVFavoritesScreen(),
    const TVSettingsScreen(),
  ];

  final List<_NavItem> _navItems = [
    _NavItem('Live', Icons.live_tv, 0),
    _NavItem('EPG', Icons.view_list, 1),
    _NavItem('Favorites', Icons.favorite, 2),
    _NavItem('Settings', Icons.settings, 3),
  ];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onNavItemSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // TV Sidebar Navigation
          Container(
            width: 200,
            color: AppTheme.surfaceColor,
            child: Column(
              children: [
                // App Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.live_tv,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'StreamView',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(color: Color(0xFF333333), height: 1),

                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) {
                      return _TVNavItem(
                        item: _navItems[index],
                        isSelected: _currentIndex == index,
                        onTap: () => _onNavItemSelected(index),
                      );
                    },
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: AppTheme.textMuted.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final int index;

  _NavItem(this.label, this.icon, this.index);
}

class _TVNavItem extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _TVNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_TVNavItem> createState() => _TVNavItemState();
}

class _TVNavItemState extends State<_TVNavItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected || _isFocused;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Focus(
        onFocusChange: (focused) => setState(() => _isFocused = focused),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: isActive
                  ? Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 1)
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  color: isActive ? AppTheme.primaryColor : AppTheme.textMuted,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.item.label,
                  style: TextStyle(
                    color: isActive ? AppTheme.primaryColor : AppTheme.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
