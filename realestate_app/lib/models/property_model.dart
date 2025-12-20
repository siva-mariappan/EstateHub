class Property {
  final int id;
  final String title;
  final String type;
  final String purpose;
  final double area;
  final double price;
  final String location;
  final String locality;
  final int? bedrooms;
  final int? bathrooms;
  final String? furnishing;
  final String description;
  final List<String> amenities;
  final List<String> images;
  final bool verified;
  final bool featured;
  final String agentName;
  final String agentPhone;
  final List<String>? nearbySchools;
  final List<String>? nearbyHospitals;
  final List<String>? nearbyMetro;
  final DateTime createdAt;

  Property({
    required this.id,
    required this.title,
    required this.type,
    required this.purpose,
    required this.area,
    required this.price,
    required this.location,
    required this.locality,
    this.bedrooms,
    this.bathrooms,
    this.furnishing,
    required this.description,
    required this.amenities,
    required this.images,
    required this.verified,
    required this.featured,
    required this.agentName,
    required this.agentPhone,
    this.nearbySchools,
    this.nearbyHospitals,
    this.nearbyMetro,
    required this.createdAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      purpose: json['purpose'],
      area: double.parse(json['area'].toString()),
      price: double.parse(json['price'].toString()),
      location: json['location'],
      locality: json['locality'],
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      furnishing: json['furnishing'],
      description: json['description'],
      amenities: List<String>.from(json['amenities'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      verified: json['verified'] ?? false,
      featured: json['featured'] ?? false,
      agentName: json['agent_name'],
      agentPhone: json['agent_phone'],
      nearbySchools: json['nearby_schools'] != null
          ? List<String>.from(json['nearby_schools'])
          : null,
      nearbyHospitals: json['nearby_hospitals'] != null
          ? List<String>.from(json['nearby_hospitals'])
          : null,
      nearbyMetro: json['nearby_metro'] != null
          ? List<String>.from(json['nearby_metro'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String getPriceFormatted() {
    if (purpose == 'rent') {
      return '₹${(price / 1000).toStringAsFixed(0)}K/month';
    } else {
      if (price >= 10000000) {
        return '₹${(price / 10000000).toStringAsFixed(2)} Cr';
      } else if (price >= 100000) {
        return '₹${(price / 100000).toStringAsFixed(2)} L';
      } else {
        return '₹${price.toStringAsFixed(0)}';
      }
    }
  }

  String getBHKString() {
    if (bedrooms == null) return '';
    return '$bedrooms BHK';
  }
}