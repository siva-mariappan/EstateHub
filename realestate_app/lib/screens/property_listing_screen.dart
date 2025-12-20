import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../services/api_service.dart';
import '../widgets/property_card.dart';
import 'property_detail_screen.dart';

class PropertyListingScreen extends StatefulWidget {
  final String? initialPurpose;

  const PropertyListingScreen({Key? key, this.initialPurpose})
      : super(key: key);

  @override
  State<PropertyListingScreen> createState() => _PropertyListingScreenState();
}

class _PropertyListingScreenState extends State<PropertyListingScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Property> _properties = [];
  List<Property> _filteredProperties = [];
  bool _isLoading = true;
  String _error = '';
  String _selectedPurpose = 'all';
  String _selectedType = 'all';
  int? _selectedBedrooms;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedPurpose = widget.initialPurpose ?? 'all';
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final properties = await _apiService.getProperties(
        purpose: _selectedPurpose != 'all' ? _selectedPurpose : null,
        type: _selectedType != 'all' ? _selectedType : null,
        bedrooms: _selectedBedrooms,
      );

      setState(() {
        _properties = properties;
        _filteredProperties = properties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    _loadProperties();
  }

  void _applyLocalFilters() {
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredProperties = _properties;
      } else {
        _filteredProperties = _properties.where((property) {
          return property.title.toLowerCase().contains(_searchQuery) ||
              property.locality.toLowerCase().contains(_searchQuery) ||
              property.location.toLowerCase().contains(_searchQuery);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetails(Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(property: property),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.home_work_rounded,
                color: Color(0xFF10B981),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'EstateHub',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Properties',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() => _searchQuery = value.toLowerCase());
                _applyLocalFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search by locality, title...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF10B981)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                          _applyLocalFilters();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all', _selectedPurpose, (value) {
                    setState(() => _selectedPurpose = value);
                    _applyFilters();
                  }),
                  _buildFilterChip('Buy', 'buy', _selectedPurpose, (value) {
                    setState(() => _selectedPurpose = value);
                    _applyFilters();
                  }),
                  _buildFilterChip('Rent', 'rent', _selectedPurpose, (value) {
                    setState(() => _selectedPurpose = value);
                    _applyFilters();
                  }),
                  _buildFilterChip('Flat', 'flat', _selectedPurpose, (value) {
                    setState(() => _selectedPurpose = value);
                    _applyFilters();
                  }),
                ],
              ),
            ),
          ),
          // Property count
          if (!_isLoading && _filteredProperties.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                '${_filteredProperties.length} ${_filteredProperties.length == 1 ? 'Property' : 'Properties'} Found',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ),
          // Property list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading properties',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _error,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : _filteredProperties.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.home_outlined,
                                    size: 80, color: Colors.grey[300]),
                                const SizedBox(height: 24),
                                Text(
                                  'No Properties Found',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try adjusting your filters or search criteria',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPurpose = 'all';
                                      _selectedType = 'all';
                                      _selectedBedrooms = null;
                                      _searchController.clear();
                                      _searchQuery = '';
                                    });
                                    _applyFilters();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Clear Filters'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadProperties,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.15,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _filteredProperties.length,
                              itemBuilder: (context, index) {
                                return PropertyCard(
                                  property: _filteredProperties[index],
                                  onTap: () => _navigateToDetails(
                                      _filteredProperties[index]),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String selectedValue,
    Function(String) onSelected,
  ) {
    final isSelected = selectedValue == value;

    // Get icon based on label
    IconData? icon;
    Color? iconColor;
    switch (label.toLowerCase()) {
      case 'all':
        icon = Icons.grid_view_rounded;
        iconColor = isSelected ? Colors.white : const Color(0xFF10B981);
        break;
      case 'buy':
        icon = Icons.home_rounded;
        iconColor = isSelected ? Colors.white : const Color(0xFF10B981);
        break;
      case 'rent':
        icon = Icons.key_rounded;
        iconColor = isSelected ? Colors.white : Colors.orange;
        break;
      case 'flat':
        icon = Icons.apartment_rounded;
        iconColor = isSelected ? Colors.white : Colors.purple;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: icon != null
            ? Icon(
                icon,
                size: 18,
                color: iconColor,
              )
            : null,
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) => onSelected(value),
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF10B981),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Property Type'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'plot', child: Text('Plot')),
                DropdownMenuItem(value: 'flat', child: Text('Flat')),
                DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int?>(
              value: _selectedBedrooms,
              decoration: const InputDecoration(labelText: 'Bedrooms'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(value: 1, child: Text('1 BHK')),
                DropdownMenuItem(value: 2, child: Text('2 BHK')),
                DropdownMenuItem(value: 3, child: Text('3 BHK')),
                DropdownMenuItem(value: 4, child: Text('4+ BHK')),
              ],
              onChanged: (value) {
                setState(() => _selectedBedrooms = value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _applyFilters();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}