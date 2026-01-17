import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/property_model.dart';
import '../services/api_service.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/animated_buttons.dart';
import '../widgets/search_filter_widgets.dart';
import '../widgets/loading_widgets.dart';
import '../widgets/utility_widgets.dart';
import '../widgets/page_transitions.dart';
import '../config/theme_config.dart';
import 'property_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late TabController _tabController;
  List<Property> _properties = [];
  bool _isLoading = true;
  String _selectedStatus = 'all';
  String _searchQuery = '';
  double _scrollProgress = 0.0;

  // Dashboard stats
  int _totalProperties = 0;
  int _activeListings = 0;
  int _totalViews = 0;
  int _leadsThisMonth = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final progress = (_scrollController.offset / 100).clamp(0.0, 1.0);
      if (progress != _scrollProgress) {
        setState(() => _scrollProgress = progress);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      final properties = await _apiService.getProperties();

      setState(() {
        _properties = properties;
        _totalProperties = properties.length;
        _activeListings = properties.where((p) => p.featured).length;
        _totalViews = properties.length * 127; // Mock data
        _leadsThisMonth = 48; // Mock data
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _handleDeleteProperty(Property property) {
    GlassModal.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.spacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(ThemeConfig.spacingLG),
              decoration: BoxDecoration(
                color: ThemeConfig.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 48,
                color: ThemeConfig.error,
              ),
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            Text('Delete Property?', style: ThemeConfig.h4),
            const SizedBox(height: ThemeConfig.spacingMD),
            Text(
              'Are you sure you want to delete "${property.title}"? This action cannot be undone.',
              style: ThemeConfig.bodyMedium.copyWith(
                color: ThemeConfig.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.spacingXL),
            Row(
              children: [
                Expanded(
                  child: AnimatedOutlineButton(
                    text: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: ThemeConfig.spacingMD),
                Expanded(
                  child: AnimatedGradientButton(
                    text: 'Delete',
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Property deleted successfully'),
                          backgroundColor: ThemeConfig.success,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(ThemeConfig.radiusMedium),
                          ),
                        ),
                      );
                    },
                    gradientColors: [ThemeConfig.error, ThemeConfig.error.withOpacity(0.8)],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.background,
      appBar: _buildGlassAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDashboardTab(),
          _buildPropertiesTab(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar() {
    return GlassAppBar(
      scrollProgress: _scrollProgress,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConfig.spacingMD),
            decoration: BoxDecoration(
              gradient: ThemeConfig.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: ThemeConfig.spacingMD),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ThemeConfig.textPrimary,
                ),
              ),
              Text(
                'Manage your properties',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeConfig.textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        GradientIconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          size: 40,
        ),
        const SizedBox(width: ThemeConfig.spacingMD),
        GradientIconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
          size: 40,
        ),
        const SizedBox(width: ThemeConfig.spacingMD),
      ],
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: ThemeConfig.primaryGreen,
        indicatorWeight: 3,
        labelColor: ThemeConfig.primaryGreen,
        unselectedLabelColor: ThemeConfig.textSecondary,
        labelStyle: ThemeConfig.buttonMedium,
        tabs: const [
          Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined, size: 20)),
          Tab(text: 'Properties', icon: Icon(Icons.home_work_outlined, size: 20)),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          if (_isLoading)
            SkeletonGridLoader(
              itemCount: 4,
              crossAxisCount: ThemeConfig.getGridCrossAxisCount(context),
              childAspectRatio: 1.5,
            )
          else
            _buildStatsGrid(),

          const SizedBox(height: ThemeConfig.spacing2XL),

          // Quick Actions
          Text('Quick Actions', style: ThemeConfig.h4),
          const SizedBox(height: ThemeConfig.spacingLG),
          _buildQuickActions(),

          const SizedBox(height: ThemeConfig.spacing2XL),

          // Recent Activity
          Text('Recent Activity', style: ThemeConfig.h4),
          const SizedBox(height: ThemeConfig.spacingLG),
          _buildRecentActivity(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {
        'title': 'Total Properties',
        'value': _totalProperties,
        'icon': Icons.home_work,
        'color': ThemeConfig.primaryGreen,
        'change': '+12%',
      },
      {
        'title': 'Active Listings',
        'value': _activeListings,
        'icon': Icons.check_circle_outline,
        'color': ThemeConfig.secondaryBlue,
        'change': '+8%',
      },
      {
        'title': 'Total Views',
        'value': _totalViews,
        'icon': Icons.visibility_outlined,
        'color': ThemeConfig.secondaryPurple,
        'change': '+24%',
      },
      {
        'title': 'Leads This Month',
        'value': _leadsThisMonth,
        'icon': Icons.people_outline,
        'color': ThemeConfig.secondaryOrange,
        'change': '+15%',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ThemeConfig.getGridCrossAxisCount(context),
        childAspectRatio: 1.5,
        crossAxisSpacing: ThemeConfig.spacingLG,
        mainAxisSpacing: ThemeConfig.spacingLG,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: _buildStatCard(
                title: stat['title'] as String,
                value: stat['value'] as int,
                icon: stat['icon'] as IconData,
                color: stat['color'] as Color,
                change: stat['change'] as String,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required String change,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConfig.spacingMD),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConfig.spacingMD,
                  vertical: ThemeConfig.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: ThemeConfig.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConfig.radiusCircular),
                ),
                child: Text(
                  change,
                  style: ThemeConfig.caption.copyWith(
                    color: ThemeConfig.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConfig.spacingMD),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: value),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) => Text(
              NumberFormat('#,###').format(animatedValue),
              style: ThemeConfig.h2.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            title,
            style: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Add Property',
        'icon': Icons.add_home_outlined,
        'color': ThemeConfig.primaryGreen,
      },
      {
        'title': 'View Leads',
        'icon': Icons.people_outline,
        'color': ThemeConfig.secondaryBlue,
      },
      {
        'title': 'Reports',
        'icon': Icons.analytics_outlined,
        'color': ThemeConfig.secondaryPurple,
      },
      {
        'title': 'Settings',
        'icon': Icons.settings_outlined,
        'color': ThemeConfig.textSecondary,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: ThemeConfig.spacingMD,
        mainAxisSpacing: ThemeConfig.spacingMD,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 600 + (index * 100)),
          curve: Curves.easeOutBack,
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${action['title']} feature coming soon!'),
                    backgroundColor: ThemeConfig.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ThemeConfig.radiusMedium),
                    ),
                  ),
                );
              },
              child: GlassCard(
                padding: const EdgeInsets.all(ThemeConfig.spacingMD),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConfig.spacingMD),
                      decoration: BoxDecoration(
                        color: (action['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action['icon'] as IconData,
                        color: action['color'] as Color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: ThemeConfig.spacingMD),
                    Text(
                      action['title'] as String,
                      style: ThemeConfig.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      {
        'title': 'New property listed',
        'description': 'Luxury Villa in Green Valley',
        'time': '2 hours ago',
        'icon': Icons.add_circle_outline,
        'color': ThemeConfig.success,
      },
      {
        'title': 'Property updated',
        'description': 'Modern Apartment - Price reduced',
        'time': '5 hours ago',
        'icon': Icons.edit_outlined,
        'color': ThemeConfig.secondaryBlue,
      },
      {
        'title': 'New lead received',
        'description': 'Interested in Downtown property',
        'time': '1 day ago',
        'icon': Icons.person_add_outlined,
        'color': ThemeConfig.secondaryOrange,
      },
      {
        'title': 'Property sold',
        'description': 'Palm Residency Unit #204',
        'time': '2 days ago',
        'icon': Icons.check_circle,
        'color': ThemeConfig.primaryGreen,
      },
    ];

    return GlassCard(
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(30 * (1 - value), 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(ThemeConfig.spacingMD),
                          decoration: BoxDecoration(
                            color: (activity['color'] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            activity['icon'] as IconData,
                            color: activity['color'] as Color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: ThemeConfig.spacingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['title'] as String,
                                style: ThemeConfig.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                activity['description'] as String,
                                style: ThemeConfig.bodySmall.copyWith(
                                  color: ThemeConfig.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          activity['time'] as String,
                          style: ThemeConfig.caption.copyWith(
                            color: ThemeConfig.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    if (index < activities.length - 1) ...[
                      const SizedBox(height: ThemeConfig.spacingLG),
                      const Divider(height: 1),
                      const SizedBox(height: ThemeConfig.spacingLG),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPropertiesTab() {
    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: const EdgeInsets.all(ThemeConfig.spacingLG),
          child: Column(
            children: [
              GlassSearchBar(
                controller: _searchController,
                hintText: 'Search properties...',
                onChanged: (value) {
                  setState(() => _searchQuery = value.toLowerCase());
                },
              ),
              const SizedBox(height: ThemeConfig.spacingMD),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AnimatedFilterChip(
                      label: 'All',
                      isSelected: _selectedStatus == 'all',
                      onTap: () => setState(() => _selectedStatus = 'all'),
                    ),
                    const SizedBox(width: ThemeConfig.spacingMD),
                    AnimatedFilterChip(
                      label: 'Featured',
                      icon: Icons.star,
                      isSelected: _selectedStatus == 'featured',
                      onTap: () => setState(() => _selectedStatus = 'featured'),
                    ),
                    const SizedBox(width: ThemeConfig.spacingMD),
                    AnimatedFilterChip(
                      label: 'For Sale',
                      icon: Icons.sell,
                      isSelected: _selectedStatus == 'buy',
                      onTap: () => setState(() => _selectedStatus = 'buy'),
                    ),
                    const SizedBox(width: ThemeConfig.spacingMD),
                    AnimatedFilterChip(
                      label: 'For Rent',
                      icon: Icons.key,
                      isSelected: _selectedStatus == 'rent',
                      onTap: () => setState(() => _selectedStatus = 'rent'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Properties List
        Expanded(
          child: _isLoading
              ? SkeletonListLoader(itemCount: 6)
              : _buildPropertiesList(),
        ),
      ],
    );
  }

  Widget _buildPropertiesList() {
    var filteredProperties = _properties.where((property) {
      final matchesSearch = _searchQuery.isEmpty ||
          property.title.toLowerCase().contains(_searchQuery) ||
          property.locality.toLowerCase().contains(_searchQuery);

      final matchesStatus = _selectedStatus == 'all' ||
          (_selectedStatus == 'featured' && property.featured) ||
          property.purpose == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    if (filteredProperties.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No Properties Found',
        message: 'Try adjusting your search or filters',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        final property = filteredProperties[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 50)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: ThemeConfig.spacingLG),
                child: _buildPropertyCard(property),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPropertyCard(Property property) {
    return GlassCard(
      padding: const EdgeInsets.all(ThemeConfig.spacingLG),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
            child: property.images.isNotEmpty
                ? Image.network(
                    property.images.first,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: ThemeConfig.background,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: ThemeConfig.background,
                    child: const Icon(Icons.home_work, size: 40),
                  ),
          ),
          const SizedBox(width: ThemeConfig.spacingLG),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.title,
                        style: ThemeConfig.h6,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (property.featured)
                      StatusBadge.featured(),
                  ],
                ),
                const SizedBox(height: ThemeConfig.spacingXS),
                Text(
                  '${property.locality}, ${property.location}',
                  style: ThemeConfig.bodySmall.copyWith(
                    color: ThemeConfig.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: ThemeConfig.spacingMD),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConfig.spacingMD,
                        vertical: ThemeConfig.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: property.purpose == 'buy'
                            ? ThemeConfig.primaryGreen.withOpacity(0.1)
                            : ThemeConfig.secondaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            ThemeConfig.radiusCircular),
                      ),
                      child: Text(
                        property.purpose.toUpperCase(),
                        style: ThemeConfig.caption.copyWith(
                          color: property.purpose == 'buy'
                              ? ThemeConfig.primaryGreen
                              : ThemeConfig.secondaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: ThemeConfig.spacingMD),
                    Text(
                      property.getPriceFormatted(),
                      style: ThemeConfig.h6.copyWith(
                        color: ThemeConfig.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              GradientIconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {
                  PageTransitions.hero(
                    context,
                    PropertyDetailScreen(property: property),
                  );
                },
                size: 36,
              ),
              const SizedBox(height: ThemeConfig.spacingMD),
              GradientIconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Edit feature coming soon!'),
                      backgroundColor: ThemeConfig.primaryGreen,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(ThemeConfig.radiusMedium),
                      ),
                    ),
                  );
                },
                size: 36,
              ),
              const SizedBox(height: ThemeConfig.spacingMD),
              GestureDetector(
                onTap: () => _handleDeleteProperty(property),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: ThemeConfig.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConfig.radiusSmall),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: ThemeConfig.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
