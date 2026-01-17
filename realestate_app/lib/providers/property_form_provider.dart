import 'package:flutter/material.dart';
import '../models/property_form_data.dart';

class PropertyFormProvider with ChangeNotifier {
  PropertyFormData _formData = PropertyFormData();

  PropertyFormData get formData => _formData;

  // Reset form data (for new property)
  void resetForm() {
    _formData = PropertyFormData();
    notifyListeners();
  }

  // Update form data
  void updateFormData(PropertyFormData data) {
    _formData = data;
    notifyListeners();
  }

  // Get form data
  PropertyFormData getFormData() {
    return _formData;
  }
}
