import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property.dart';
import '../services/property_service.dart';
import 'property_details_screen.dart';

class OwnerAdminScreen extends StatefulWidget {
  const OwnerAdminScreen({Key? key}) : super(key: key);

  @override
  State<OwnerAdminScreen> createState() => _OwnerAdminScreenState();
}

class _OwnerAdminScreenState extends State<OwnerAdminScreen>
    with SingleTickerProviderStateMixin {
  final PropertyService _propertyService = PropertyService();

  late TabController _tabController;
  List<Property> _allProperties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedStatus = 'all';

  // Stats
  int _totalProperties = 0;
  int _activeListings = 0;
  int _pendingApprovals = 0;
  int _totalUsers = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadAdminData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    try {
      setState(() => _isLoading = true);

      // Load all properties (including all statuses for admin)
      final properties = await _propertyService.fetchAllProperties(includeAllStatuses: true);

      // Get stats from Supabase
      final supabase = Supabase.instance.client;

      // Count total users
      final usersResponse = await supabase
          .from('users')
          .select('id');

      setState(() {
        _allProperties = properties;
        _filteredProperties = properties;
        _totalProperties = properties.length;
        _activeListings = properties.where((p) => p.status == 'active').length;
        _pendingApprovals = properties.where((p) => p.status == 'pending').length;
        _totalUsers = (usersResponse as List).length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading admin data: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load data: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  void _filterProperties() {
    setState(() {
      _filteredProperties = _allProperties.where((property) {
        // Filter by search query
        bool matchesSearch = _searchQuery.isEmpty ||
            property.propertyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (property.locality?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

        // Filter by status
        bool matchesStatus = _selectedStatus == 'all' ||
            property.status == _selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _updatePropertyStatus(Property property, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('properties')
          .update({'status': newStatus})
          .eq('id', property.id);

      await _loadAdminData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property status updated to $newStatus'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  Future<void> _deleteProperty(Property property) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Property',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${property.propertyName}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await Supabase.instance.client
            .from('properties')
            .delete()
            .eq('id', property.id);

        await _loadAdminData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete property: $e'),
              backgroundColor: Colors.red.shade600,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)))
          : Column(
              children: [
                _buildStatsCards(),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPropertiesTab(),
                      _buildUsersTab(),
                      _buildAnalyticsTab(),
                      _buildSettingsTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Owner Admin Panel',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'System Management',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF111827)),
          onPressed: _loadAdminData,
          tooltip: 'Refresh Data',
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Close Admin Panel',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _buildStatCard(
            'Total Properties',
            _totalProperties.toString(),
            Icons.home_work,
            const Color(0xFF10B981),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Active Listings',
            _activeListings.toString(),
            Icons.check_circle,
            const Color(0xFF3B82F6),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Pending',
            _pendingApprovals.toString(),
            Icons.pending,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            'Total Users',
            _totalUsers.toString(),
            Icons.people,
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF10B981),
        unselectedLabelColor: const Color(0xFF6B7280),
        indicatorColor: const Color(0xFF10B981),
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Properties', icon: Icon(Icons.home, size: 20)),
          Tab(text: 'Users', icon: Icon(Icons.people, size: 20)),
          Tab(text: 'Analytics', icon: Icon(Icons.analytics, size: 20)),
          Tab(text: 'Settings', icon: Icon(Icons.settings, size: 20)),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab() {
    return Column(
      children: [
        // Search and Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search properties...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFB),
                ),
                onChanged: (value) {
                  _searchQuery = value;
                  _filterProperties();
                },
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    _buildFilterChip('Active', 'active'),
                    _buildFilterChip('Pending', 'pending'),
                    _buildFilterChip('Inactive', 'inactive'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Properties List
        Expanded(
          child: _filteredProperties.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 64, color: Color(0xFF9CA3AF)),
                      SizedBox(height: 16),
                      Text(
                        'No properties found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredProperties.length,
                  itemBuilder: (context, index) {
                    final property = _filteredProperties[index];
                    return _buildPropertyCard(property);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = value;
            _filterProperties();
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF10B981).withOpacity(0.2),
        checkmarkColor: const Color(0xFF10B981),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    final statusColor = property.status == 'active'
        ? const Color(0xFF10B981)
        : property.status == 'pending'
            ? const Color(0xFFF59E0B)
            : const Color(0xFF6B7280);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PropertyDetailsScreen(property: property),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: property.coverImageUrl != null
                    ? Image.network(
                        property.coverImageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: const Color(0xFFE5E7EB),
                        child: const Icon(Icons.home, color: Color(0xFF6B7280)),
                      ),
              ),
              const SizedBox(width: 12),
              // Property Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.propertyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${property.locality}, ${property.city}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            property.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          property.propertyFor,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 18),
                        SizedBox(width: 8),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  if (property.status != 'active')
                    const PopupMenuItem(
                      value: 'activate',
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 18, color: Color(0xFF10B981)),
                          SizedBox(width: 8),
                          Text('Activate'),
                        ],
                      ),
                    ),
                  if (property.status != 'inactive')
                    const PopupMenuItem(
                      value: 'deactivate',
                      child: Row(
                        children: [
                          Icon(Icons.block, size: 18, color: Color(0xFFF59E0B)),
                          SizedBox(width: 8),
                          Text('Deactivate'),
                        ],
                      ),
                    ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Color(0xFFDC2626)),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Color(0xFFDC2626))),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'view') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailsScreen(property: property),
                      ),
                    );
                  } else if (value == 'activate') {
                    _updatePropertyStatus(property, 'active');
                  } else if (value == 'deactivate') {
                    _updatePropertyStatus(property, 'inactive');
                  } else if (value == 'delete') {
                    _deleteProperty(property);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 64, color: Color(0xFF9CA3AF)),
            SizedBox(height: 16),
            Text(
              'User Management',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'View and manage all registered users',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Analytics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          _buildAnalyticsCard(
            'Total Properties',
            _totalProperties.toString(),
            Icons.home_work,
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'Active Listings',
            _activeListings.toString(),
            Icons.check_circle,
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'Pending Approvals',
            _pendingApprovals.toString(),
            Icons.pending,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 12),
          _buildAnalyticsCard(
            'Registered Users',
            _totalUsers.toString(),
            Icons.people,
            const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Admin Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsTile(
          'Database Management',
          'Manage database and backups',
          Icons.storage,
          () {},
        ),
        _buildSettingsTile(
          'System Configuration',
          'Configure system settings',
          Icons.settings,
          () {},
        ),
        _buildSettingsTile(
          'Email Templates',
          'Manage email notifications',
          Icons.email,
          () {},
        ),
        _buildSettingsTile(
          'Security Settings',
          'Manage security and permissions',
          Icons.security,
          () {},
        ),
        _buildSettingsTile(
          'Reports',
          'Generate system reports',
          Icons.analytics,
          () {},
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF10B981)),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
