class Property {
  final String id;
  final String? userId;

  // Step 1: Basic Details
  final String propertyName;
  final String propertyFor; // 'sell' or 'rent'
  final String? propertyTypeSell;
  final String? propertyTypeRent;
  final double? landExtent;
  final double? builtUpArea;
  final String? sizeRange;
  final String? bedrooms;
  final String? bathrooms;
  final int? floorNo;
  final int? totalFloors;
  final String? facingDirection;
  final String? furnishingStatus;
  final List<String>? furnishingItems;
  final List<String>? nearbyAmenities;

  // Step 2: Location
  final String state;
  final String city;
  final String? locality;
  final String? landmark;
  final String? pincode;
  final String? googleMapsLink;

  // Step 3: Pricing & Details
  final double? price;
  final double? pricePerSqft;
  final double? udsSqft;
  final double? maintenanceMonthly;
  final double? monthlyRent;
  final double? securityDeposit;
  final String? ageOfProperty;
  final String? possessionStatus;
  final String? transactionType;
  final String? ownershipType;
  final String? approvalStatus;
  final String? propertyDescription;
  final double? monthlyRentalIncome;
  final double? annualYield;
  final int? maxOccupancy;
  final double? ceilingHeight;

  // Lease Information
  final bool? isLeaseProperty;
  final String? leaseDuration;
  final String? lockInPeriod;
  final String? noticePeriod;
  final double? leaseRentMonthly;
  final double? leaseSecurityDeposit;
  final double? rentEscalationPercent;
  final String? occupancyStatus;
  final DateTime? leaseStartDate;
  final String? leaseType;
  final bool? registrationRequired;

  // Step 4: Media
  final String? coverImageUrl;
  final List<String>? imageUrls;
  final String? videoUrl;
  final String? virtualTourUrl;
  final String? arContentUrl;
  final String? vrContentUrl;

  // Step 5: Contact & Agent
  final String contactName;
  final String contactMobile;
  final String? contactEmail;
  final bool? whatsappAvailable;
  final String? listedBy;
  final String? agencyName;
  final String? reraNumber;
  final double? brokerFeePercent;
  final String? officeAddress;
  final String? companyName;
  final String? gstNumber;
  final String? companyAddress;

  // Metadata
  final String status;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Property({
    required this.id,
    this.userId,
    required this.propertyName,
    required this.propertyFor,
    this.propertyTypeSell,
    this.propertyTypeRent,
    this.landExtent,
    this.builtUpArea,
    this.sizeRange,
    this.bedrooms,
    this.bathrooms,
    this.floorNo,
    this.totalFloors,
    this.facingDirection,
    this.furnishingStatus,
    this.furnishingItems,
    this.nearbyAmenities,
    required this.state,
    required this.city,
    this.locality,
    this.landmark,
    this.pincode,
    this.googleMapsLink,
    this.price,
    this.pricePerSqft,
    this.udsSqft,
    this.maintenanceMonthly,
    this.monthlyRent,
    this.securityDeposit,
    this.ageOfProperty,
    this.possessionStatus,
    this.transactionType,
    this.ownershipType,
    this.approvalStatus,
    this.propertyDescription,
    this.monthlyRentalIncome,
    this.annualYield,
    this.maxOccupancy,
    this.ceilingHeight,
    this.isLeaseProperty,
    this.leaseDuration,
    this.lockInPeriod,
    this.noticePeriod,
    this.leaseRentMonthly,
    this.leaseSecurityDeposit,
    this.rentEscalationPercent,
    this.occupancyStatus,
    this.leaseStartDate,
    this.leaseType,
    this.registrationRequired,
    this.coverImageUrl,
    this.imageUrls,
    this.videoUrl,
    this.virtualTourUrl,
    this.arContentUrl,
    this.vrContentUrl,
    required this.contactName,
    required this.contactMobile,
    this.contactEmail,
    this.whatsappAvailable,
    this.listedBy,
    this.agencyName,
    this.reraNumber,
    this.brokerFeePercent,
    this.officeAddress,
    this.companyName,
    this.gstNumber,
    this.companyAddress,
    this.status = 'active',
    this.viewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from Supabase JSON to Property object
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      propertyName: json['property_name'] as String,
      propertyFor: json['property_for'] as String,
      propertyTypeSell: json['property_type_sell'] as String?,
      propertyTypeRent: json['property_type_rent'] as String?,
      landExtent: json['land_extent'] != null ? (json['land_extent'] as num).toDouble() : null,
      builtUpArea: json['built_up_area'] != null ? (json['built_up_area'] as num).toDouble() : null,
      sizeRange: json['size_range'] as String?,
      bedrooms: json['bedrooms'] as String?,
      bathrooms: json['bathrooms'] as String?,
      floorNo: json['floor_no'] as int?,
      totalFloors: json['total_floors'] as int?,
      facingDirection: json['facing_direction'] as String?,
      furnishingStatus: json['furnishing_status'] as String?,
      furnishingItems: json['furnishing_items'] != null
          ? List<String>.from(json['furnishing_items'] as List)
          : null,
      nearbyAmenities: json['nearby_amenities'] != null
          ? List<String>.from(json['nearby_amenities'] as List)
          : null,
      state: json['state'] as String,
      city: json['city'] as String,
      locality: json['locality'] as String?,
      landmark: json['landmark'] as String?,
      pincode: json['pincode'] as String?,
      googleMapsLink: json['google_maps_link'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      pricePerSqft: json['price_per_sqft'] != null ? (json['price_per_sqft'] as num).toDouble() : null,
      udsSqft: json['uds_sqft'] != null ? (json['uds_sqft'] as num).toDouble() : null,
      maintenanceMonthly: json['maintenance_monthly'] != null ? (json['maintenance_monthly'] as num).toDouble() : null,
      monthlyRent: json['monthly_rent'] != null ? (json['monthly_rent'] as num).toDouble() : null,
      securityDeposit: json['security_deposit'] != null ? (json['security_deposit'] as num).toDouble() : null,
      ageOfProperty: json['age_of_property'] as String?,
      possessionStatus: json['possession_status'] as String?,
      transactionType: json['transaction_type'] as String?,
      ownershipType: json['ownership_type'] as String?,
      approvalStatus: json['approval_status'] as String?,
      propertyDescription: json['property_description'] as String?,
      monthlyRentalIncome: json['monthly_rental_income'] != null ? (json['monthly_rental_income'] as num).toDouble() : null,
      annualYield: json['annual_yield'] != null ? (json['annual_yield'] as num).toDouble() : null,
      maxOccupancy: json['max_occupancy'] as int?,
      ceilingHeight: json['ceiling_height'] != null ? (json['ceiling_height'] as num).toDouble() : null,
      isLeaseProperty: json['is_lease_property'] as bool?,
      leaseDuration: json['lease_duration'] as String?,
      lockInPeriod: json['lock_in_period'] as String?,
      noticePeriod: json['notice_period'] as String?,
      leaseRentMonthly: json['lease_rent_monthly'] != null ? (json['lease_rent_monthly'] as num).toDouble() : null,
      leaseSecurityDeposit: json['lease_security_deposit'] != null ? (json['lease_security_deposit'] as num).toDouble() : null,
      rentEscalationPercent: json['rent_escalation_percent'] != null ? (json['rent_escalation_percent'] as num).toDouble() : null,
      occupancyStatus: json['occupancy_status'] as String?,
      leaseStartDate: json['lease_start_date'] != null ? DateTime.parse(json['lease_start_date'] as String) : null,
      leaseType: json['lease_type'] as String?,
      registrationRequired: json['registration_required'] as bool?,
      coverImageUrl: json['cover_image_url'] as String?,
      imageUrls: json['image_urls'] != null
          ? List<String>.from(json['image_urls'] as List)
          : null,
      videoUrl: json['video_url'] as String?,
      virtualTourUrl: json['virtual_tour_url'] as String?,
      arContentUrl: json['ar_content_url'] as String?,
      vrContentUrl: json['vr_content_url'] as String?,
      contactName: json['contact_name'] as String,
      contactMobile: json['contact_mobile'] as String,
      contactEmail: json['contact_email'] as String?,
      whatsappAvailable: json['whatsapp_available'] as bool?,
      listedBy: json['listed_by'] as String?,
      agencyName: json['agency_name'] as String?,
      reraNumber: json['rera_number'] as String?,
      brokerFeePercent: json['broker_fee_percent'] != null ? (json['broker_fee_percent'] as num).toDouble() : null,
      officeAddress: json['office_address'] as String?,
      companyName: json['company_name'] as String?,
      gstNumber: json['gst_number'] as String?,
      companyAddress: json['company_address'] as String?,
      status: json['status'] as String? ?? 'active',
      viewsCount: json['views_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert Property object to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'property_name': propertyName,
      'property_for': propertyFor,
      'property_type_sell': propertyTypeSell,
      'property_type_rent': propertyTypeRent,
      'land_extent': landExtent,
      'built_up_area': builtUpArea,
      'size_range': sizeRange,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floor_no': floorNo,
      'total_floors': totalFloors,
      'facing_direction': facingDirection,
      'furnishing_status': furnishingStatus,
      'furnishing_items': furnishingItems,
      'nearby_amenities': nearbyAmenities,
      'state': state,
      'city': city,
      'locality': locality,
      'landmark': landmark,
      'pincode': pincode,
      'google_maps_link': googleMapsLink,
      'price': price,
      'price_per_sqft': pricePerSqft,
      'uds_sqft': udsSqft,
      'maintenance_monthly': maintenanceMonthly,
      'monthly_rent': monthlyRent,
      'security_deposit': securityDeposit,
      'age_of_property': ageOfProperty,
      'possession_status': possessionStatus,
      'transaction_type': transactionType,
      'ownership_type': ownershipType,
      'approval_status': approvalStatus,
      'property_description': propertyDescription,
      'monthly_rental_income': monthlyRentalIncome,
      'annual_yield': annualYield,
      'max_occupancy': maxOccupancy,
      'ceiling_height': ceilingHeight,
      'is_lease_property': isLeaseProperty,
      'lease_duration': leaseDuration,
      'lock_in_period': lockInPeriod,
      'notice_period': noticePeriod,
      'lease_rent_monthly': leaseRentMonthly,
      'lease_security_deposit': leaseSecurityDeposit,
      'rent_escalation_percent': rentEscalationPercent,
      'occupancy_status': occupancyStatus,
      'lease_start_date': leaseStartDate?.toIso8601String(),
      'lease_type': leaseType,
      'registration_required': registrationRequired,
      'cover_image_url': coverImageUrl,
      'image_urls': imageUrls,
      'video_url': videoUrl,
      'virtual_tour_url': virtualTourUrl,
      'ar_content_url': arContentUrl,
      'vr_content_url': vrContentUrl,
      'contact_name': contactName,
      'contact_mobile': contactMobile,
      'contact_email': contactEmail,
      'whatsapp_available': whatsappAvailable,
      'listed_by': listedBy,
      'agency_name': agencyName,
      'rera_number': reraNumber,
      'broker_fee_percent': brokerFeePercent,
      'office_address': officeAddress,
      'company_name': companyName,
      'gst_number': gstNumber,
      'company_address': companyAddress,
      'status': status,
    };
  }

  // Get display property type
  String get propertyType {
    return propertyTypeSell ?? propertyTypeRent ?? 'Property';
  }

  // Get formatted price
  String get formattedPrice {
    if (propertyFor == 'sell' && price != null) {
      if (price! >= 10000000) {
        return '₹${(price! / 10000000).toStringAsFixed(2)} Cr';
      } else if (price! >= 100000) {
        return '₹${(price! / 100000).toStringAsFixed(2)} L';
      } else {
        return '₹${price!.toStringAsFixed(0)}';
      }
    } else if (propertyFor == 'rent' && monthlyRent != null) {
      return '₹${monthlyRent!.toStringAsFixed(0)}/month';
    }
    return 'Price on request';
  }

  // Get location string
  String get location {
    final parts = <String>[];
    if (locality != null && locality!.isNotEmpty) parts.add(locality!);
    parts.add(city);
    parts.add(state);
    return parts.join(', ');
  }
}
