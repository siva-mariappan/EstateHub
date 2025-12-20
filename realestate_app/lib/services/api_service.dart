import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/property_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8001';

  Future<List<Property>> getProperties({
    String? purpose,
    String? type,
    String? locality,
    double? minPrice,
    double? maxPrice,
    int? bedrooms,
    bool? verified,
    bool? featured,
  }) async {
    try {
      var uri = Uri.parse('$baseUrl/properties');
      
      Map<String, String> queryParams = {};
      if (purpose != null) queryParams['purpose'] = purpose;
      if (type != null) queryParams['type'] = type;
      if (locality != null) queryParams['locality'] = locality;
      if (minPrice != null) queryParams['min_price'] = minPrice.toString();
      if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();
      if (bedrooms != null) queryParams['bedrooms'] = bedrooms.toString();
      if (verified != null) queryParams['verified'] = verified.toString();
      if (featured != null) queryParams['featured'] = featured.toString();
      
      if (queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Property> properties = (data['properties'] as List)
            .map((property) => Property.fromJson(property))
            .toList();
        return properties;
      } else {
        throw Exception('Failed to load properties');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Property>> getFeaturedProperties() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties/featured'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Property> properties = (data['properties'] as List)
            .map((property) => Property.fromJson(property))
            .toList();
        return properties;
      } else {
        throw Exception('Failed to load featured properties');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Property> getProperty(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties/$id'),
      );
      
      if (response.statusCode == 200) {
        return Property.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load property');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Property>> searchProperties(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/properties/search?q=$query'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Property> properties = (data['properties'] as List)
            .map((property) => Property.fromJson(property))
            .toList();
        return properties;
      } else {
        throw Exception('Failed to search properties');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}