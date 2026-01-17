import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_property_screen_2.dart';
import '../providers/property_form_provider.dart';

// ENUMS
enum PropertyFor { sell, rent }

enum FurnishingStatus {
  unfurnished('Unfurnished'),
  semiFurnished('Semi Furnished'),
  fullyFurnished('Fully Furnished');

  final String displayName;
  const FurnishingStatus(this.displayName);
}

enum FacingDirection {
  north('North'),
  south('South'),
  east('East'),
  west('West'),
  northEast('North-East'),
  northWest('North-West'),
  southEast('South-East'),
  southWest('South-West');

  final String displayName;
  const FacingDirection(this.displayName);
}

// PROPERTY TYPES FOR SELL
enum SellPropertyType {
  plot('Plot'),
  commercialLand('Commercial Land'),
  flat('Flat'),
  house('Individual House'),
  villa('Individual Villa'),
  complex('Complex'),
  commercialBuilding('Commercial Building');

  final String displayName;
  const SellPropertyType(this.displayName);
}

// PROPERTY TYPES FOR RENT
enum RentPropertyType {
  flat('Flat'),
  house('Individual House'),
  villa('Individual Villa'),
  pgHostel('PG / Hostel'),
  sharedRoom('Shared Room'),
  independentFloor('Independent Floor'),
  commercialBuilding('Commercial Building'),
  officeSpace('Office Space'),
  shopShowroom('Shop / Showroom'),
  warehouse('Warehouse / Godown');

  final String displayName;
  const RentPropertyType(this.displayName);
}

// FIELD CONFIG MODEL
class Step1Config {
  final bool landExtent;
  final bool builtUpArea;
  final bool bedrooms;
  final bool bathrooms;
  final bool floorNo;
  final bool totalFloors;
  final bool furnishing;

  const Step1Config({
    this.landExtent = false,
    this.builtUpArea = false,
    this.bedrooms = false,
    this.bathrooms = false,
    this.floorNo = false,
    this.totalFloors = false,
    this.furnishing = false,
  });
}

// FIELD CONFIG MAP FOR SELL
final Map<SellPropertyType, Step1Config> sellFieldConfig = {
  SellPropertyType.plot: const Step1Config(landExtent: true),
  SellPropertyType.commercialLand: const Step1Config(landExtent: true),
  SellPropertyType.flat: const Step1Config(
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    floorNo: true,
    totalFloors: true,
    furnishing: true,
  ),
  SellPropertyType.house: const Step1Config(
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    totalFloors: true,
    furnishing: true,
  ),
  SellPropertyType.villa: const Step1Config(
    landExtent: true,
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    furnishing: true,
  ),
  SellPropertyType.complex: const Step1Config(
    builtUpArea: true,
    totalFloors: true,
  ),
  SellPropertyType.commercialBuilding: const Step1Config(
    builtUpArea: true,
    totalFloors: true,
  ),
};

// FIELD CONFIG MAP FOR RENT
final Map<RentPropertyType, Step1Config> rentFieldConfig = {
  RentPropertyType.flat: const Step1Config(
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    floorNo: true,
    totalFloors: true,
    furnishing: true,
  ),
  RentPropertyType.house: const Step1Config(
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    totalFloors: true,
    furnishing: true,
  ),
  RentPropertyType.villa: const Step1Config(
    landExtent: true,
    builtUpArea: true,
    bedrooms: true,
    bathrooms: true,
    furnishing: true,
  ),
  RentPropertyType.pgHostel: const Step1Config(
    bedrooms: true,
    bathrooms: true,
    furnishing: true,
  ),
  RentPropertyType.sharedRoom: const Step1Config(
    bedrooms: true,
    furnishing: true,
  ),
  RentPropertyType.independentFloor: const Step1Config(
    builtUpArea: true,
    floorNo: true,
    totalFloors: true,
    furnishing: true,
  ),
  RentPropertyType.commercialBuilding: const Step1Config(
    builtUpArea: true,
    totalFloors: true,
  ),
  RentPropertyType.officeSpace: const Step1Config(
    builtUpArea: true,
  ),
  RentPropertyType.shopShowroom: const Step1Config(
    builtUpArea: true,
  ),
  RentPropertyType.warehouse: const Step1Config(
    builtUpArea: true,
  ),
};

// CONSTANTS
final List<String> bedroomOptions = ['RK', '1 BHK', '2 BHK', '3 BHK', '4 BHK', 'Custom'];
final List<String> bathroomOptions = ['1', '2', '3', '4', 'Custom'];
final List<String> sizeRangeOptions = [
  'Below 500 sqft',
  '500 - 1000 sqft',
  '1000 - 1500 sqft',
  '1500 - 2000 sqft',
  '2000 - 3000 sqft',
  '3000 - 5000 sqft',
  'Above 5000 sqft',
];

final List<String> furnishingItems = [
  'Beds',
  'Wardrobe',
  'Sofa',
  'Dining Table',
  'TV',
  'AC',
  'Washing Machine',
  'Refrigerator',
  'Geyser',
  'Modular Kitchen',
];

final List<String> insideAmenities = [
  'Swimming Pool',
  'Parking',
  'Garden',
  'Gym',
  'Clubhouse',
  'Lift',
  'Power Backup',
  'Security',
  'CCTV',
  'Children Play Area',
  'Jogging Track',
  'Indoor Games',
  'Intercom',
  'Maintenance Staff',
  'Water Supply',
  'Rainwater Harvesting',
  'Piped Gas',
  'Visitor Parking',
  'Fire Safety',
  'Servant Room',
];

final List<String> nearbyAmenities = [
  'School',
  'Hospital',
  'Metro Station',
  'Shopping Mall',
  'Park',
  'Restaurant',
  'Bus Stop',
  'ATM',
  'Pharmacy',
  'Gym',
  'Market',
  'Temple',
  'Church',
  'Mosque',
  'Cinema Hall',
  'Airport',
  'Railway Station',
  'Police Station',
  'Fire Station',
  'Bank',
  'Post Office',
  'Gas Station',
  'Supermarket',
  'Cafe',
  'Library',
  'Community Center',
  'Sports Complex',
  'Swimming Pool',
  'Golf Course',
  'Beach',
  'Lake',
  'Highway Access',
];

// MAIN SCREEN
class AddPropertyStep1Screen extends StatefulWidget {
  const AddPropertyStep1Screen({Key? key}) : super(key: key);

  @override
  State<AddPropertyStep1Screen> createState() => _AddPropertyStep1ScreenState();
}

class _AddPropertyStep1ScreenState extends State<AddPropertyStep1Screen> {
  // Form State
  PropertyFor _propertyFor = PropertyFor.sell;
  SellPropertyType? _selectedSellType;
  RentPropertyType? _selectedRentType;

  FacingDirection? _facing;
  FurnishingStatus? _furnishing;
  String? _selectedBedroom;
  String? _selectedBathroom;
  String? _selectedSizeRange;

  // Controllers
  final _propertyNameController = TextEditingController();
  final _landExtentController = TextEditingController();
  final _builtUpAreaController = TextEditingController();
  final _floorNoController = TextEditingController();
  final _totalFloorsController = TextEditingController();
  final _totalBlocksController = TextEditingController();
  final _customBedroomController = TextEditingController();
  final _customBathroomController = TextEditingController();

  // Selected Items
  final Map<String, TextEditingController> _furnishingControllers = {};
  final Map<String, TextEditingController> _insideAmenityControllers = {};
  final List<String> _customInsideAmenities = [];
  final Map<String, TextEditingController> _amenityControllers = {};
  final List<String> _customFurnishings = [];
  final List<String> _customAmenities = [];

  @override
  void initState() {
    super.initState();
    // Load existing form data from provider
    _loadExistingData();
  }

  void _loadExistingData() {
    final provider = Provider.of<PropertyFormProvider>(context, listen: false);
    final formData = provider.formData;

    // Load basic details
    if (formData.propertyName != null) {
      _propertyNameController.text = formData.propertyName!;
    }
    if (formData.propertyFor != null) {
      _propertyFor = formData.propertyFor!;
    }
    if (formData.sellPropertyType != null) {
      _selectedSellType = formData.sellPropertyType;
    }
    if (formData.rentPropertyType != null) {
      _selectedRentType = formData.rentPropertyType;
    }
    if (formData.landExtent != null) {
      _landExtentController.text = formData.landExtent!;
    }
    if (formData.builtUpArea != null) {
      _builtUpAreaController.text = formData.builtUpArea!;
    }
    if (formData.sizeRange != null) {
      _selectedSizeRange = formData.sizeRange;
    }
    if (formData.bedrooms != null) {
      _selectedBedroom = formData.bedrooms;
    }
    if (formData.bathrooms != null) {
      _selectedBathroom = formData.bathrooms;
    }
    if (formData.floorNo != null) {
      _floorNoController.text = formData.floorNo!;
    }
    if (formData.totalFloors != null) {
      _totalFloorsController.text = formData.totalFloors!;
    }
    if (formData.facingDirection != null) {
      _facing = formData.facingDirection;
    }
    if (formData.furnishingStatus != null) {
      _furnishing = formData.furnishingStatus;
    }
    if (formData.furnishingItems != null) {
      for (var item in formData.furnishingItems!) {
        _furnishingControllers[item] = TextEditingController();
      }
    }
    if (formData.nearbyAmenities != null) {
      for (var item in formData.nearbyAmenities!) {
        _amenityControllers[item] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _propertyNameController.dispose();
    _landExtentController.dispose();
    _builtUpAreaController.dispose();
    _floorNoController.dispose();
    _totalFloorsController.dispose();
    _totalBlocksController.dispose();
    _customBedroomController.dispose();
    _customBathroomController.dispose();

    // Dispose dynamic controllers
    for (var controller in _furnishingControllers.values) {
      controller.dispose();
    }
    for (var controller in _insideAmenityControllers.values) {
      controller.dispose();
    }
    for (var controller in _amenityControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  Step1Config _getConfig() {
    if (_propertyFor == PropertyFor.sell && _selectedSellType != null) {
      return sellFieldConfig[_selectedSellType]!;
    } else if (_propertyFor == PropertyFor.rent && _selectedRentType != null) {
      return rentFieldConfig[_selectedRentType]!;
    }
    return const Step1Config();
  }

  String _getPropertyNameLabel() {
    if (_propertyFor == PropertyFor.sell && _selectedSellType != null) {
      switch (_selectedSellType!) {
        case SellPropertyType.plot:
          return 'Plot Name';
        case SellPropertyType.commercialLand:
          return 'Commercial Land Name';
        case SellPropertyType.flat:
          return 'Flat Name';
        case SellPropertyType.house:
          return 'House Name';
        case SellPropertyType.villa:
          return 'Villa Name';
        case SellPropertyType.complex:
          return 'Complex Name';
        case SellPropertyType.commercialBuilding:
          return 'Commercial Building Name';
      }
    } else if (_propertyFor == PropertyFor.rent && _selectedRentType != null) {
      switch (_selectedRentType!) {
        case RentPropertyType.flat:
          return 'Flat Name';
        case RentPropertyType.house:
          return 'House Name';
        case RentPropertyType.villa:
          return 'Villa Name';
        case RentPropertyType.pgHostel:
          return 'PG/Hostel Name';
        case RentPropertyType.sharedRoom:
          return 'Shared Room Name';
        case RentPropertyType.independentFloor:
          return 'Independent Floor Name';
        case RentPropertyType.commercialBuilding:
          return 'Commercial Building Name';
        case RentPropertyType.officeSpace:
          return 'Office Space Name';
        case RentPropertyType.shopShowroom:
          return 'Shop/Showroom Name';
        case RentPropertyType.warehouse:
          return 'Warehouse Name';
      }
    }
    return 'Property Name';
  }

  bool _shouldShowFacingDirection() {
    if (_propertyFor == PropertyFor.sell && _selectedSellType != null) {
      return _selectedSellType != SellPropertyType.plot &&
          _selectedSellType != SellPropertyType.commercialLand;
    }
    return true;
  }

  bool _shouldShowInsideAmenities() {
    if (_propertyFor == PropertyFor.sell && _selectedSellType != null) {
      return _selectedSellType != SellPropertyType.plot &&
          _selectedSellType != SellPropertyType.commercialLand;
    }
    return true;
  }

  bool _shouldShowTotalBlocks() {
    return _propertyFor == PropertyFor.sell &&
        _selectedSellType == SellPropertyType.complex;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleNextStep() {
    final config = _getConfig();

    // Validate required fields
    if (_propertyNameController.text.trim().isEmpty) {
      _showError('Please enter a property name');
      return;
    }

    if (_propertyFor == PropertyFor.sell && _selectedSellType == null) {
      _showError('Please select a property type');
      return;
    }

    if (_propertyFor == PropertyFor.rent && _selectedRentType == null) {
      _showError('Please select a property type');
      return;
    }

    // Validate land extent and built-up area
    if (config.landExtent && _landExtentController.text.trim().isEmpty) {
      _showError('Please enter land extent');
      return;
    }
    if (config.builtUpArea && _builtUpAreaController.text.trim().isEmpty) {
      _showError('Please enter built-up area');
      return;
    }

    // Validate size range is mandatory
    if (_selectedSizeRange == null) {
      _showError('Please select a size range');
      return;
    }

    // Validate facing direction (mandatory except for plot)
    if (_shouldShowFacingDirection() && _facing == null) {
      _showError('Please select facing direction');
      return;
    }

    // Validate bedrooms
    if (config.bedrooms && _selectedBedroom == null) {
      _showError('Please select number of bedrooms');
      return;
    }
    if (_selectedBedroom == 'Custom' && _customBedroomController.text.trim().isEmpty) {
      _showError('Please enter custom bedroom count');
      return;
    }

    // Validate bathrooms
    if (config.bathrooms && _selectedBathroom == null) {
      _showError('Please select number of bathrooms');
      return;
    }
    if (_selectedBathroom == 'Custom' && _customBathroomController.text.trim().isEmpty) {
      _showError('Please enter custom bathroom count');
      return;
    }

    // Validate floor info
    if (config.floorNo && _floorNoController.text.trim().isEmpty) {
      _showError('Please enter floor number');
      return;
    }
    if (config.totalFloors && _totalFloorsController.text.trim().isEmpty) {
      _showError('Please enter total floors');
      return;
    }

    // Validate total blocks for complex
    if (_shouldShowTotalBlocks() && _totalBlocksController.text.trim().isEmpty) {
      _showError('Please enter total number of blocks');
      return;
    }

    // Validate furnishing status
    if (config.furnishing && _furnishing == null) {
      _showError('Please select furnishing status');
      return;
    }

    // Validate inside amenities details are mandatory when selected
    for (var entry in _insideAmenityControllers.entries) {
      if (entry.value.text.trim().isEmpty) {
        _showError('Please enter details for ${entry.key}');
        return;
      }
    }

    // Validate nearby amenities names are mandatory when selected
    for (var entry in _amenityControllers.entries) {
      if (entry.value.text.trim().isEmpty) {
        _showError('Please enter name for ${entry.key}');
        return;
      }
    }

    // Save all Step 1 data to provider
    final provider = Provider.of<PropertyFormProvider>(context, listen: false);
    final formData = provider.formData;

    // Update form data with Step 1 values
    formData.propertyName = _propertyNameController.text.trim();
    formData.propertyFor = _propertyFor;
    formData.sellPropertyType = _selectedSellType;
    formData.rentPropertyType = _selectedRentType;
    formData.landExtent = _landExtentController.text;
    formData.builtUpArea = _builtUpAreaController.text;
    formData.sizeRange = _selectedSizeRange;
    formData.bedrooms = _selectedBedroom;
    formData.bathrooms = _selectedBathroom;
    formData.floorNo = _floorNoController.text;
    formData.totalFloors = _totalFloorsController.text;
    formData.facingDirection = _facing;
    formData.furnishingStatus = _furnishing;

    // Collect selected furnishing items
    final selectedFurnishings = <String>[];
    for (var item in furnishingItems) {
      if (_furnishingControllers.containsKey(item)) {
        selectedFurnishings.add(item);
      }
    }
    selectedFurnishings.addAll(_customFurnishings);
    formData.furnishingItems = selectedFurnishings.isNotEmpty ? selectedFurnishings : null;

    // Collect selected inside amenities
    final selectedInsideAmenities = <String>[];
    for (var item in insideAmenities) {
      if (_insideAmenityControllers.containsKey(item)) {
        selectedInsideAmenities.add(item);
      }
    }
    selectedInsideAmenities.addAll(_customInsideAmenities);
    // TODO: Add formData.insideAmenities field when PropertyFormData model is updated

    // Collect selected nearby amenities
    final selectedAmenities = <String>[];
    for (var item in nearbyAmenities) {
      if (_amenityControllers.containsKey(item)) {
        selectedAmenities.add(item);
      }
    }
    selectedAmenities.addAll(_customAmenities);
    formData.nearbyAmenities = selectedAmenities.isNotEmpty ? selectedAmenities : null;

    provider.updateFormData(formData);

    // Navigate to Step 2 with selected property type
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPropertyStep2Screen(
          propertyFor: _propertyFor,
          sellType: _selectedSellType,
          rentType: _selectedRentType,
        ),
      ),
    );
  }

  void _handlePropertyForChange(PropertyFor newValue) {
    setState(() {
      _propertyFor = newValue;
      // Reset property type and clear all selections
      if (newValue == PropertyFor.sell) {
        _selectedSellType = null;
        _selectedRentType = null;
      } else {
        _selectedRentType = null;
        _selectedSellType = null;
      }
      _resetForm();
    });
  }

  void _resetForm() {
    _selectedBedroom = null;
    _selectedBathroom = null;
    _selectedSizeRange = null;
    _facing = null;
    _furnishing = null;

    // Clear and dispose dynamic controllers
    for (var controller in _furnishingControllers.values) {
      controller.dispose();
    }
    _furnishingControllers.clear();

    for (var controller in _insideAmenityControllers.values) {
      controller.dispose();
    }
    _insideAmenityControllers.clear();

    for (var controller in _amenityControllers.values) {
      controller.dispose();
    }
    _amenityControllers.clear();

    _customFurnishings.clear();
    _customInsideAmenities.clear();
    _customAmenities.clear();

    _propertyNameController.clear();
    _landExtentController.clear();
    _builtUpAreaController.clear();
    _floorNoController.clear();
    _totalFloorsController.clear();
    _totalBlocksController.clear();
    _customBedroomController.clear();
    _customBathroomController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF111827),
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Property',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Basic Details',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Scrollable Form
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Basic Property Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Step 1 – Provide basic information about your property',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Property For Section
                    _buildPropertyForSection(),
                    const SizedBox(height: 24),

                    // Property Type Dropdown
                    _buildPropertyTypeDropdown(),
                    const SizedBox(height: 24),

                    // Property Name Field (after property type)
                    if (_selectedSellType != null || _selectedRentType != null) ...[
                      _buildPropertyNameField(),
                      const SizedBox(height: 24),
                    ],

                    // Total Blocks for Complex
                    if (_shouldShowTotalBlocks()) ...[
                      _buildTextField(
                        label: 'Total Number of Blocks',
                        controller: _totalBlocksController,
                        hint: 'e.g., 5',
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Area Row
                    if (config.landExtent || config.builtUpArea) ...[
                      Row(
                        children: [
                          if (config.landExtent)
                            Expanded(
                              child: _buildTextField(
                                label: 'Land Extent (sqft)',
                                controller: _landExtentController,
                                hint: 'e.g., 2400',
                              ),
                            ),
                          if (config.landExtent && config.builtUpArea)
                            const SizedBox(width: 12),
                          if (config.builtUpArea)
                            Expanded(
                              child: _buildTextField(
                                label: 'Built-up Area (sqft)',
                                controller: _builtUpAreaController,
                                hint: 'e.g., 1200',
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Size Range Dropdown
                    _buildSizeRangeDropdown(),
                    const SizedBox(height: 20),

                    // Bedrooms
                    if (config.bedrooms) ...[
                      _buildSelectionSection(
                        title: 'Bedrooms',
                        options: bedroomOptions,
                        selectedValue: _selectedBedroom,
                        onSelect: (value) => setState(() => _selectedBedroom = value),
                        customController: _customBedroomController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Bathrooms
                    if (config.bathrooms) ...[
                      _buildSelectionSection(
                        title: 'Bathrooms',
                        options: bathroomOptions,
                        selectedValue: _selectedBathroom,
                        onSelect: (value) => setState(() => _selectedBathroom = value),
                        customController: _customBathroomController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Floor Info
                    if (config.floorNo && config.totalFloors) ...[
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'Floor No',
                              controller: _floorNoController,
                              hint: 'e.g., 2',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'Total Floors',
                              controller: _totalFloorsController,
                              hint: 'e.g., 10',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ] else if (config.totalFloors) ...[
                      _buildTextField(
                        label: 'Total Floors',
                        controller: _totalFloorsController,
                        hint: 'e.g., 10',
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Furnishing Status
                    if (config.furnishing) ...[
                      _buildFurnishingSection(),
                      const SizedBox(height: 20),
                    ],

                    // Furnishing Items (if semi or fully furnished)
                    if (_furnishing == FurnishingStatus.semiFurnished ||
                        _furnishing == FurnishingStatus.fullyFurnished) ...[
                      _buildFurnishingsSection(),
                      const SizedBox(height: 20),
                    ],

                    // Facing Direction (hide for plot and commercial land)
                    if (_shouldShowFacingDirection()) ...[
                      _buildFacingDirection(),
                      const SizedBox(height: 24),
                    ],

                    // Inside Amenities (hide for plot and commercial land)
                    if (_shouldShowInsideAmenities()) ...[
                      _buildInsideAmenitiesSection(),
                      const SizedBox(height: 24),
                    ],

                    // Nearby Amenities
                    _buildNearbyAmenitiesSection(),
                  ],
                ),
              ),
                ),
              ),
            ),
          ),

          // Next Step Button
          _buildNextStepButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step 1 of 5',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Basic Details',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.home_outlined,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _getPropertyNameLabel(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _propertyNameController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'e.g., Luxury ${_getPropertyNameLabel().replaceAll(' Name', '')} in Anna Nagar',
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyForSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property For',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildPropertyForButton(
                label: 'Sell',
                value: PropertyFor.sell,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPropertyForButton(
                label: 'Rent',
                value: PropertyFor.rent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertyForButton({
    required String label,
    required PropertyFor value,
  }) {
    final isSelected = _propertyFor == value;
    return GestureDetector(
      onTap: () => _handlePropertyForChange(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Property Type',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _propertyFor == PropertyFor.sell
              ? DropdownButton<SellPropertyType>(
                  value: _selectedSellType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: SellPropertyType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedSellType = value;
                        _resetForm();
                      });
                    }
                  },
                )
              : DropdownButton<RentPropertyType>(
                  value: _selectedRentType,
                  isExpanded: true,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  items: RentPropertyType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRentType = value;
                        _resetForm();
                      });
                    }
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSizeRangeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Size Range (sqft)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: _selectedSizeRange,
            hint: const Text(
              'Select size range',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 15,
              ),
            ),
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            items: sizeRangeOptions.map((range) {
              return DropdownMenuItem(
                value: range,
                child: Text(range),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSizeRange = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              if (isRequired) return '$label is required';
              return null;
            }
            if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
              return 'Enter numbers only';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelect,
    TextEditingController? customController,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF10B981) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        // Show custom input field if Custom is selected
        if (selectedValue == 'Custom' && customController != null) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: customController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter custom $title';
              }
              if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                return 'Enter numbers only';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Enter custom $title',
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFurnishingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Furnishing Status',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: FurnishingStatus.values.map((status) {
            final isSelected = _furnishing == status;
            return GestureDetector(
              onTap: () => setState(() => _furnishing = status),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF10B981) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  status.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFacingDirection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Facing Direction',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: FacingDirection.values.map((direction) {
            final isSelected = _facing == direction;
            return GestureDetector(
              onTap: () => setState(() => _facing = direction),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  direction.displayName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFurnishingsSection() {
    final allFurnishings = [...furnishingItems, ..._customFurnishings];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Furnishings',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...allFurnishings.map((item) {
              final isSelected = _furnishingControllers.containsKey(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _furnishingControllers[item]?.dispose();
                      _furnishingControllers.remove(item);
                    } else {
                      _furnishingControllers[item] = TextEditingController();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Plus button to add custom furnishing
            GestureDetector(
              onTap: () => _showAddCustomItemDialog(isForFurnishing: true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981),
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 18,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Custom',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Show text fields for selected furnishings
        ...(_furnishingControllers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextField(
              controller: entry.value,
              decoration: InputDecoration(
                labelText: '${entry.key} - Enter details',
                hintText: 'e.g., 2 King Size Beds',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildInsideAmenitiesSection() {
    final allInsideAmenities = [...insideAmenities, ..._customInsideAmenities];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.apartment_outlined,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Inside Amenities',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Select amenities available inside the property',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...allInsideAmenities.map((item) {
              final isSelected = _insideAmenityControllers.containsKey(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _insideAmenityControllers[item]?.dispose();
                      _insideAmenityControllers.remove(item);
                    } else {
                      _insideAmenityControllers[item] = TextEditingController();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Plus button to add custom inside amenity
            GestureDetector(
              onTap: () => _showAddCustomItemDialog(isForFurnishing: false, isForInsideAmenities: true),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981),
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Custom',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Show text fields for selected inside amenities (MANDATORY)
        ...(_insideAmenityControllers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextFormField(
              controller: entry.value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${entry.key} details are required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: '${entry.key} - Enter details *',
                hintText: 'e.g., 2 Parking Spots, 24/7 Security',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF4444)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildNearbyAmenitiesSection() {
    final allAmenities = [...nearbyAmenities, ..._customAmenities];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Nearby Amenities',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Select amenities available near the property',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...allAmenities.map((item) {
              final isSelected = _amenityControllers.containsKey(item);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _amenityControllers[item]?.dispose();
                      _amenityControllers.remove(item);
                    } else {
                      _amenityControllers[item] = TextEditingController();
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? const Color(0xFF10B981) : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
            // Plus button to add custom nearby amenity
            GestureDetector(
              onTap: () => _showAddCustomItemDialog(isForFurnishing: false, isForInsideAmenities: false),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF10B981),
                    width: 2,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add Custom',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Show text fields for selected amenities (MANDATORY)
        ...(_amenityControllers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: TextFormField(
              controller: entry.value,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '${entry.key} name is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                labelText: '${entry.key} - Enter name *',
                hintText: 'e.g., XYZ School',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF4444)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          );
        }).toList()),
      ],
    );
  }

  void _showAddCustomItemDialog({required bool isForFurnishing, bool isForInsideAmenities = false}) {
    final controller = TextEditingController();

    // Determine the dialog title and hint based on the type
    String title;
    String hint;
    if (isForFurnishing) {
      title = 'Add Custom Furnishing';
      hint = 'e.g., Smart TV';
    } else if (isForInsideAmenities) {
      title = 'Add Custom Inside Amenity';
      hint = 'e.g., Home Theater';
    } else {
      title = 'Add Custom Nearby Amenity';
      hint = 'e.g., Shopping Mall';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF10B981), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  if (isForFurnishing) {
                    _customFurnishings.add(controller.text.trim());
                    _furnishingControllers[controller.text.trim()] = TextEditingController();
                  } else if (isForInsideAmenities) {
                    _customInsideAmenities.add(controller.text.trim());
                    _insideAmenityControllers[controller.text.trim()] = TextEditingController();
                  } else {
                    _customAmenities.add(controller.text.trim());
                    _amenityControllers[controller.text.trim()] = TextEditingController();
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: const Text(
              'Add',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
            onPressed: _handleNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next Step',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
            ),
          ),
        ),
      ),
    );
  }
}
