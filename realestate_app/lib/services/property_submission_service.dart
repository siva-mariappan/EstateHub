import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../models/property_form_data.dart';

class PropertySubmissionService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Main method to submit property
  Future<String> submitProperty(PropertyFormData formData) async {
    try {
      // Get current user ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated. Please log in first.');
      }

      // Step 1: Upload images
      print('📸 Uploading images...');
      List<String>? imageUrls;
      String? coverImageUrl;

      if (formData.images != null && formData.images!.isNotEmpty) {
        imageUrls = await _uploadImages(formData.images!, userId);
        coverImageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;
      }

      // Step 2: Upload video (if exists)
      print('🎥 Uploading video...');
      String? videoUrl;
      if (formData.video != null) {
        videoUrl = await _uploadVideo(formData.video!, userId);
      }

      // Step 3: Upload AR content (if exists)
      print('🥽 Uploading AR content...');
      String? arContentUrl;
      if (formData.arFile != null) {
        arContentUrl = await _uploadARVRContent(formData.arFile!, userId, 'ar');
      }

      // Step 4: Upload VR content (if exists)
      print('🌐 Uploading VR content...');
      String? vrContentUrl;
      if (formData.vrFile != null) {
        vrContentUrl = await _uploadARVRContent(formData.vrFile!, userId, 'vr');
      }

      // Step 5: Insert property data into database
      print('💾 Saving property to database...');
      final propertyData = formData.toJson(
        userId: userId,
        coverImageUrl: coverImageUrl,
        imageUrls: imageUrls,
        videoUrl: videoUrl,
        arContentUrl: arContentUrl,
        vrContentUrl: vrContentUrl,
      );

      final response = await _supabase
          .from('properties')
          .insert(propertyData)
          .select('id')
          .single();

      final propertyId = response['id'] as String;

      print('✅ Property submitted successfully! ID: $propertyId');
      return propertyId;
    } catch (e) {
      print('❌ Error submitting property: $e');
      rethrow;
    }
  }

  // Upload multiple images to Supabase Storage
  Future<List<String>> _uploadImages(List<XFile> images, String userId) async {
    final List<String> uploadedUrls = [];

    for (int i = 0; i < images.length; i++) {
      try {
        final image = images[i];
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = '$userId/property-$timestamp-$i.${image.name.split('.').last}';

        // Upload to Supabase Storage
        final bytes = await image.readAsBytes();
        await _supabase.storage
            .from('property-images')
            .uploadBinary(fileName, bytes);

        // Get public URL
        final url = _supabase.storage
            .from('property-images')
            .getPublicUrl(fileName);

        uploadedUrls.add(url);
        print('✓ Uploaded image ${i + 1}/${images.length}');
      } catch (e) {
        print('✗ Error uploading image ${i + 1}: $e');
        // Continue with other images even if one fails
      }
    }

    if (uploadedUrls.isEmpty) {
      throw Exception('Failed to upload any images. Please try again.');
    }

    return uploadedUrls;
  }

  // Upload video to Supabase Storage
  Future<String?> _uploadVideo(XFile video, String userId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/property-video-$timestamp.${video.name.split('.').last}';

      final bytes = await video.readAsBytes();
      await _supabase.storage
          .from('property-videos')
          .uploadBinary(fileName, bytes);

      final url = _supabase.storage
          .from('property-videos')
          .getPublicUrl(fileName);

      print('✓ Video uploaded successfully');
      return url;
    } catch (e) {
      print('✗ Error uploading video: $e');
      return null; // Video is optional, so return null instead of throwing
    }
  }

  // Upload AR/VR content to Supabase Storage
  Future<String?> _uploadARVRContent(XFile file, String userId, String type) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/property-$type-$timestamp.${file.name.split('.').last}';

      final bytes = await file.readAsBytes();
      await _supabase.storage
          .from('property-ar-vr')
          .uploadBinary(fileName, bytes);

      final url = _supabase.storage
          .from('property-ar-vr')
          .getPublicUrl(fileName);

      print('✓ $type content uploaded successfully');
      return url;
    } catch (e) {
      print('✗ Error uploading $type content: $e');
      return null; // AR/VR is optional
    }
  }

  // Update existing property
  Future<void> updateProperty(String propertyId, PropertyFormData formData) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Upload new media if provided
      List<String>? imageUrls;
      String? coverImageUrl;
      if (formData.images != null && formData.images!.isNotEmpty) {
        imageUrls = await _uploadImages(formData.images!, userId);
        coverImageUrl = imageUrls.first;
      }

      String? videoUrl;
      if (formData.video != null) {
        videoUrl = await _uploadVideo(formData.video!, userId);
      }

      // Update property
      final propertyData = formData.toJson(
        userId: userId,
        coverImageUrl: coverImageUrl,
        imageUrls: imageUrls,
        videoUrl: videoUrl,
      );

      await _supabase
          .from('properties')
          .update(propertyData)
          .eq('id', propertyId)
          .eq('user_id', userId); // Ensure user owns this property

      print('✅ Property updated successfully!');
    } catch (e) {
      print('❌ Error updating property: $e');
      rethrow;
    }
  }

  // Delete property
  Future<void> deleteProperty(String propertyId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _supabase
          .from('properties')
          .delete()
          .eq('id', propertyId)
          .eq('user_id', userId);

      print('✅ Property deleted successfully!');
    } catch (e) {
      print('❌ Error deleting property: $e');
      rethrow;
    }
  }
}
