import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property.dart';

class PropertyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all properties (optionally including all statuses for admin)
  Future<List<Property>> fetchAllProperties({bool includeAllStatuses = false}) async {
    try {
      var query = _supabase
          .from('properties')
          .select();

      // Only filter by active status if not admin mode
      if (!includeAllStatuses) {
        query = query.eq('status', 'active');
      }

      final response = await query.order('created_at', ascending: false);

      print('📊 fetchAllProperties response type: ${response.runtimeType}');

      // Check if response is an error (Map with error key)
      if (response is Map) {
        print('⚠️ Supabase returned an error: $response');
        return [];
      }

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('❌ Error fetching properties: $e');
      return [];
    }
  }

  // Fetch properties by type (buy/rent)
  Future<List<Property>> fetchPropertiesByType(String propertyFor) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('status', 'active')
          .eq('property_for', propertyFor)
          .order('created_at', ascending: false);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('Error fetching properties by type: $e');
      rethrow;
    }
  }

  // Fetch properties by city
  Future<List<Property>> fetchPropertiesByCity(String city) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('status', 'active')
          .eq('city', city)
          .order('created_at', ascending: false);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('Error fetching properties by city: $e');
      rethrow;
    }
  }

  // Fetch single property by ID
  Future<Property?> fetchPropertyById(String propertyId) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('id', propertyId)
          .single();

      return Property.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching property: $e');
      return null;
    }
  }

  // Fetch user's properties
  Future<List<Property>> fetchUserProperties(String userId) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('Error fetching user properties: $e');
      rethrow;
    }
  }

  // Search properties by multiple criteria
  Future<List<Property>> searchProperties({
    String? propertyFor,
    String? state,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? propertyType,
    String? bedrooms,
  }) async {
    try {
      var query = _supabase
          .from('properties')
          .select()
          .eq('status', 'active');

      if (propertyFor != null) {
        query = query.eq('property_for', propertyFor);
      }

      if (state != null) {
        query = query.eq('state', state);
      }

      if (city != null) {
        query = query.eq('city', city);
      }

      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }

      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      if (propertyType != null) {
        if (propertyFor == 'sell') {
          query = query.eq('property_type_sell', propertyType);
        } else {
          query = query.eq('property_type_rent', propertyType);
        }
      }

      if (bedrooms != null) {
        query = query.eq('bedrooms', bedrooms);
      }

      final response = await query.order('created_at', ascending: false);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('Error searching properties: $e');
      rethrow;
    }
  }

  // Increment property views
  Future<void> incrementPropertyViews(String propertyId) async {
    try {
      // Get current property
      final property = await fetchPropertyById(propertyId);
      if (property != null) {
        // Update views count
        await _supabase
            .from('properties')
            .update({'views_count': property.viewsCount + 1})
            .eq('id', propertyId);

        // Record view in property_views table
        await _supabase.from('property_views').insert({
          'property_id': propertyId,
          'user_id': _supabase.auth.currentUser?.id,
          'viewed_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error incrementing views: $e');
    }
  }

  // Get saved/favorite properties for user
  Future<List<Property>> fetchSavedProperties(String userId) async {
    try {
      final response = await _supabase
          .from('saved_properties')
          .select('property_id, properties(*)')
          .eq('user_id', userId);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        final propertyData = item['properties'];
        if (propertyData != null) {
          properties.add(Property.fromJson(propertyData as Map<String, dynamic>));
        }
      }

      return properties;
    } catch (e) {
      print('Error fetching saved properties: $e');
      rethrow;
    }
  }

  // Save/favorite a property
  Future<void> saveProperty(String userId, String propertyId) async {
    try {
      await _supabase.from('saved_properties').insert({
        'user_id': userId,
        'property_id': propertyId,
      });
    } catch (e) {
      print('Error saving property: $e');
      rethrow;
    }
  }

  // Unsave/unfavorite a property
  Future<void> unsaveProperty(String userId, String propertyId) async {
    try {
      await _supabase
          .from('saved_properties')
          .delete()
          .eq('user_id', userId)
          .eq('property_id', propertyId);
    } catch (e) {
      print('Error unsaving property: $e');
      rethrow;
    }
  }

  // Check if property is saved by user
  Future<bool> isPropertySaved(String userId, String propertyId) async {
    try {
      final response = await _supabase
          .from('saved_properties')
          .select('id')
          .eq('user_id', userId)
          .eq('property_id', propertyId);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];
      return data.isNotEmpty;
    } catch (e) {
      print('Error checking if property is saved: $e');
      return false;
    }
  }

  // Get featured/recent properties (for home page)
  Future<List<Property>> fetchFeaturedProperties({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false)
          .limit(limit);

      print('📊 Supabase response type: ${response.runtimeType}');
      print('📊 Supabase response: $response');

      // Check if response is an error (Map with error key)
      if (response is Map) {
        print('⚠️ Supabase returned an error: $response');
        return [];
      }

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];
      print('📊 Found ${data.length} properties');

      final List<Property> properties = [];
      for (var item in data) {
        try {
          properties.add(Property.fromJson(item as Map<String, dynamic>));
        } catch (e) {
          print('⚠️ Error parsing property: $e');
          print('⚠️ Property data: $item');
        }
      }

      return properties;
    } catch (e) {
      print('❌ Error fetching featured properties: $e');
      print('❌ Error type: ${e.runtimeType}');
      return []; // Return empty list instead of rethrowing
    }
  }

  // Get popular properties (most viewed)
  Future<List<Property>> fetchPopularProperties({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('properties')
          .select()
          .eq('status', 'active')
          .order('views_count', ascending: false)
          .limit(limit);

      // Handle response - it should be a List
      final List<dynamic> data = response is List ? response : [];

      final List<Property> properties = [];
      for (var item in data) {
        properties.add(Property.fromJson(item as Map<String, dynamic>));
      }

      return properties;
    } catch (e) {
      print('Error fetching popular properties: $e');
      rethrow;
    }
  }

  // Get property statistics
  Future<Map<String, int>> getPropertyStats() async {
    try {
      final response = await _supabase
          .from('properties')
          .select('id, property_for')
          .eq('status', 'active');

      // Handle response - it should be a List
      final List<dynamic> allProperties = response is List ? response : [];

      int totalProperties = allProperties.length;
      int forSale = allProperties.where((p) => p['property_for'] == 'sell').length;
      int forRent = allProperties.where((p) => p['property_for'] == 'rent').length;

      return {
        'total': totalProperties,
        'forSale': forSale,
        'forRent': forRent,
      };
    } catch (e) {
      print('Error fetching property stats: $e');
      return {'total': 0, 'forSale': 0, 'forRent': 0};
    }
  }
}
