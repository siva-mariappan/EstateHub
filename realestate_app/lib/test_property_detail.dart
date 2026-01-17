import 'package:flutter/material.dart';
import 'package:realestate_app/screens/property_detail_screen.dart';
import 'package:realestate_app/models/property_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sampleProperty = Property(
      id: '1',
      title: 'Luxury 3BHK Apartment in Downtown',
      location: 'Downtown, City Center',
      locality: 'Downtown',
      price: '85.00 L',
      bedrooms: 3,
      bathrooms: 3,
      area: '1850 sqft',
      imageUrl: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800',
      purpose: 'buy',
      type: 'apartment',
      amenities: ['Swimming Pool', 'Gym', 'Parking', 'Security', 'Garden'],
      isFeatured: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PropertyDetailScreen(property: sampleProperty),
    );
  }
}
