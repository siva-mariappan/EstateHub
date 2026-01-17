import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/property_service.dart';
import 'property_detail_screen.dart';

class PropertiesListScreen extends StatefulWidget {
  final String? propertyFor; // 'sell' or 'rent'
  final String? city;

  const PropertiesListScreen({
    Key? key,
    this.propertyFor,
    this.city,
  }) : super(key: key);

  @override
  State<PropertiesListScreen> createState() => _PropertiesListScreenState();
}

class _PropertiesListScreenState extends State<PropertiesListScreen> {
  final PropertyService _propertyService = PropertyService();
  List<Property> _properties = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Property> properties;

      if (widget.city != null) {
        properties = await _propertyService.fetchPropertiesByCity(widget.city!);
      } else if (widget.propertyFor != null) {
        properties = await _propertyService.fetchPropertiesByType(widget.propertyFor!);
      } else {
        properties = await _propertyService.fetchAllProperties();
      }

      setState(() {
        _properties = properties;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load properties: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getTitle(),
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF111827)),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  String _getTitle() {
    if (widget.city != null) {
      return 'Properties in ${widget.city}';
    } else if (widget.propertyFor == 'sell') {
      return 'Properties for Sale';
    } else if (widget.propertyFor == 'rent') {
      return 'Properties for Rent';
    }
    return 'All Properties';
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF10B981),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchProperties,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_properties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No properties found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new listings',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchProperties,
      color: const Color(0xFF10B981),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _properties.length,
        itemBuilder: (context, index) {
          return _buildPropertyCard(_properties[index]);
        },
      ),
    );
  }

  Widget _buildPropertyCard(Property property) {
    return GestureDetector(
      onTap: () {
        // Navigate to detail screen
        // TODO: Update property_detail_screen to fetch by ID
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Property: ${property.propertyName}'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            _buildPropertyImage(property),

            // Property Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    property.formattedPrice,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Property Name & Type
                  Text(
                    property.propertyName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Property Features
                  _buildPropertyFeatures(property),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyImage(Property property) {
    final imageUrl = property.coverImageUrl ?? (property.imageUrls?.isNotEmpty == true ? property.imageUrls!.first : null);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: Stack(
        children: [
          // Image
          imageUrl != null
              ? Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    );
                  },
                )
              : _buildPlaceholderImage(),

          // Property Type Badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: property.propertyFor == 'sell'
                    ? const Color(0xFF10B981)
                    : const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                property.propertyFor == 'sell' ? 'FOR SALE' : 'FOR RENT',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.home_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildPropertyFeatures(Property property) {
    final features = <Widget>[];

    // Bedrooms
    if (property.bedrooms != null) {
      features.add(_buildFeatureChip(
        icon: Icons.bed_outlined,
        label: property.bedrooms!,
      ));
    }

    // Bathrooms
    if (property.bathrooms != null) {
      features.add(_buildFeatureChip(
        icon: Icons.bathroom_outlined,
        label: '${property.bathrooms} Bath',
      ));
    }

    // Area
    if (property.builtUpArea != null) {
      features.add(_buildFeatureChip(
        icon: Icons.square_foot,
        label: '${property.builtUpArea!.toStringAsFixed(0)} sqft',
      ));
    } else if (property.landExtent != null) {
      features.add(_buildFeatureChip(
        icon: Icons.square_foot,
        label: '${property.landExtent!.toStringAsFixed(0)} sqft',
      ));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: features,
    );
  }

  Widget _buildFeatureChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFD1FAE5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF10B981),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF065F46),
            ),
          ),
        ],
      ),
    );
  }
}
