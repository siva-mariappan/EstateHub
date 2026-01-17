import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/property_model.dart';

class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback onTap;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive adjustments
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;

    return Card(
      elevation: 0, // Flat design like Image 2
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFECEDEE), // Light gray background like Image 2
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with badges
              _buildImageSection(isCompact),
              // Property details
              _buildDetailsSection(context, isCompact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isCompact) {
    return AspectRatio(
      aspectRatio: 1.8, // Fixed aspect ratio for consistent layout
      child: Stack(
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: property.images.isNotEmpty
                  ? property.images[0]
                  : 'https://via.placeholder.com/400',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      const Color(0xFF3B82F6).withOpacity(0.1),
                    ],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF10B981),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.2),
                      const Color(0xFF3B82F6).withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  size: 56,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
          
          // Top badges and favorite button
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side badges
                Row(
                  children: [
                    // Verified badge
                    if (property.verified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.verified, color: Colors.white, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Featured badge - REMOVED as requested
                  ],
                ),
                
                // Favorite button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    size: 20,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          
          // Property type badge at bottom of image
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    property.purpose == 'rent' 
                        ? Icons.key_outlined 
                        : Icons.shopping_bag_outlined,
                    size: 16,
                    color: const Color(0xFF111827),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    property.purpose == 'rent' ? 'For Rent' : 'For Buy',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, bool isCompact) {
    return Padding(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Title - GREEN like in Image 2
          Text(
            property.title,
            style: TextStyle(
              fontSize: isCompact ? 16 : 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF10B981), // Green color matching Image 2
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isCompact ? 8 : 10),
          
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: isCompact ? 14 : 16,
                color: const Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${property.locality}, ${property.location}',
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          // Property details row (BHK, Bath, sqft)
          if (_hasPropertyDetails()) ...[
            SizedBox(height: isCompact ? 8 : 10),
            _buildPropertyDetailsRow(isCompact),
          ],
          
          SizedBox(height: isCompact ? 12 : 16),
          
          // Price and Button Row - responsive
          _buildPriceAndButtonRow(context, isCompact),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsRow(bool isCompact) {
    return Wrap(
      spacing: isCompact ? 12 : 16,
      runSpacing: 8,
      children: [
        if (property.bedrooms != null && property.bedrooms! > 0)
          _buildDetailItem(
            Icons.bed_outlined,
            property.getBHKString(),
            isCompact,
          ),
        if (property.bathrooms != null && property.bathrooms! > 0)
          _buildDetailItem(
            Icons.bathtub_outlined,
            '${property.bathrooms} Bath',
            isCompact,
          ),
        if (property.area > 0)
          _buildDetailItem(
            Icons.straighten,
            '${property.area.toInt()} sqft',
            isCompact,
          ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text, bool isCompact) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: isCompact ? 14 : 16,
          color: const Color(0xFF6B7280),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: isCompact ? 12 : 13,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndButtonRow(BuildContext context, bool isCompact) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 1200 
        ? screenWidth / 3 
        : screenWidth > 800 
            ? screenWidth / 2 
            : screenWidth;
    
    // Stack vertically for very narrow cards
    final shouldStack = cardWidth < 280;
    
    if (shouldStack) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceText(isCompact),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildViewDetailsButton(isCompact),
          ),
        ],
      );
    }
    
    // Normal horizontal layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildPriceText(isCompact)),
        const SizedBox(width: 12),
        _buildViewDetailsButton(isCompact),
      ],
    );
  }

  Widget _buildPriceText(bool isCompact) {
    return Text(
      property.getPriceFormatted(),
      style: TextStyle(
        fontSize: isCompact ? 20 : 24,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1F2937), // Dark gray/black
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildViewDetailsButton(bool isCompact) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 16 : 20,
          vertical: isCompact ? 10 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        'View Details',
        style: TextStyle(
          fontSize: isCompact ? 13 : 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  bool _hasPropertyDetails() {
    return (property.bedrooms != null && property.bedrooms! > 0) ||
           (property.bathrooms != null && property.bathrooms! > 0) ||
           property.area > 0;
  }
}