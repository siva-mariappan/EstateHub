import 'package:image_picker/image_picker.dart';
import '../screens/add_property_screen_1.dart';

// This class holds all form data from all 5 screens
class PropertyFormData {
  // Step 1: Basic Details
  String? propertyName;
  PropertyFor? propertyFor;
  SellPropertyType? sellPropertyType;
  RentPropertyType? rentPropertyType;
  String? landExtent;
  String? builtUpArea;
  String? sizeRange;
  String? bedrooms;
  String? bathrooms;
  String? floorNo;
  String? totalFloors;
  FacingDirection? facingDirection;
  FurnishingStatus? furnishingStatus;
  List<String>? furnishingItems;
  List<String>? nearbyAmenities;

  // Step 2: Location
  String? state;
  String? city;
  String? locality;
  String? landmark;
  String? pincode;
  String? googleMapsLink;

  // Step 3: Pricing & Details
  String? price;
  String? pricePerSqft;
  String? udsSqft;
  String? maintenance;
  String? monthlyRent;
  String? securityDeposit;
  String? ageOfProperty;
  String? possessionStatus;
  String? transactionType;
  String? ownershipType;
  String? approvalStatus;
  String? propertyDescription;
  String? monthlyRentalIncome;
  String? annualYield;
  String? maxOccupancy;
  String? ceilingHeight;

  // Lease Information
  bool? isLeaseProperty;
  String? leaseDuration;
  String? lockInPeriod;
  String? noticePeriod;
  String? overallLeaseAmount;
  String? rentEscalationPercent;
  String? leaseType;
  bool? registrationRequired;

  // Step 4: Media
  List<XFile>? images;
  XFile? video;
  String? virtualTourUrl;
  XFile? arFile;
  XFile? vrFile;

  // Step 5: Contact & Agent
  String? contactName;
  String? contactMobile;
  String? contactEmail;
  bool? whatsappAvailable;
  String? listedBy;
  String? agencyName;
  String? reraNumber;
  String? brokerFeePercent;
  String? officeAddress;
  String? companyName;
  String? gstNumber;
  String? companyAddress;

  PropertyFormData();

  // Convert to JSON for Supabase
  Map<String, dynamic> toJson({
    String? userId,
    String? coverImageUrl,
    List<String>? imageUrls,
    String? videoUrl,
    String? arContentUrl,
    String? vrContentUrl,
  }) {
    return {
      'user_id': userId,
      'property_name': propertyName,
      'property_for': propertyFor?.name,
      'property_type_sell': sellPropertyType?.displayName,
      'property_type_rent': rentPropertyType?.displayName,
      'land_extent': landExtent != null ? double.tryParse(landExtent!) : null,
      'built_up_area': builtUpArea != null ? double.tryParse(builtUpArea!) : null,
      'size_range': sizeRange,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'floor_no': floorNo != null ? int.tryParse(floorNo!) : null,
      'total_floors': totalFloors != null ? int.tryParse(totalFloors!) : null,
      'facing_direction': facingDirection?.displayName,
      'furnishing_status': furnishingStatus?.displayName,
      'furnishing_items': furnishingItems,
      'nearby_amenities': nearbyAmenities,
      'state': state,
      'city': city,
      'locality': locality,
      'landmark': landmark,
      'pincode': pincode,
      'google_maps_link': googleMapsLink,
      'price': price != null ? double.tryParse(price!) : null,
      'price_per_sqft': pricePerSqft != null ? double.tryParse(pricePerSqft!) : null,
      'uds_sqft': udsSqft != null ? double.tryParse(udsSqft!) : null,
      'maintenance_monthly': maintenance != null ? double.tryParse(maintenance!) : null,
      'monthly_rent': monthlyRent != null ? double.tryParse(monthlyRent!) : null,
      'security_deposit': securityDeposit != null ? double.tryParse(securityDeposit!) : null,
      'age_of_property': ageOfProperty,
      'possession_status': possessionStatus,
      'transaction_type': transactionType,
      'ownership_type': ownershipType,
      'approval_status': approvalStatus,
      'property_description': propertyDescription,
      'monthly_rental_income': monthlyRentalIncome != null ? double.tryParse(monthlyRentalIncome!) : null,
      'annual_yield': annualYield != null ? double.tryParse(annualYield!) : null,
      'max_occupancy': maxOccupancy != null ? int.tryParse(maxOccupancy!) : null,
      'ceiling_height': ceilingHeight != null ? double.tryParse(ceilingHeight!) : null,
      'is_lease_property': isLeaseProperty,
      'lease_duration': leaseDuration,
      'lock_in_period': lockInPeriod,
      'notice_period': noticePeriod,
      'overall_lease_amount': overallLeaseAmount != null ? double.tryParse(overallLeaseAmount!) : null,
      'rent_escalation_percent': rentEscalationPercent != null ? double.tryParse(rentEscalationPercent!) : null,
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
      'broker_fee_percent': brokerFeePercent != null ? double.tryParse(brokerFeePercent!) : null,
      'office_address': officeAddress,
      'company_name': companyName,
      'gst_number': gstNumber,
      'company_address': companyAddress,
      'status': 'active',
    };
  }
}
