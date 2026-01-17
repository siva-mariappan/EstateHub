import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'add_property_screen_1.dart'; // Import enums
import 'add_property_screen_4.dart';
import '../providers/property_form_provider.dart';

// ========== LEASE ELIGIBILITY HELPER ==========
bool isEligibleForLease(RentPropertyType? rentType) {
  if (rentType == null) return false;

  return [
    RentPropertyType.commercialBuilding,
    RentPropertyType.officeSpace,
    RentPropertyType.shopShowroom,
    RentPropertyType.warehouse,
    RentPropertyType.independentFloor,
    RentPropertyType.house,
  ].contains(rentType);
}

// ========== STEP 3 VISIBILITY CONFIG ==========
class Step3Visibility {
  final bool expectedPrice;
  final bool priceNegotiable;
  final bool pricePerSqft;
  final bool uds;
  final bool ageOfProperty;
  final bool maintenance;
  final bool possession;

  // Rent-specific
  final bool monthlyRent;
  final bool securityDeposit;

  // Rental Income Property specific
  final bool monthlyRentalIncome;
  final bool annualYield;
  final bool leaseStatus;

  // PG/Hostel specific
  final bool foodIncluded;
  final bool maintenanceIncluded;

  // Shared Room specific
  final bool maxOccupancy;

  // Lease-specific (only for eligible types)
  final bool showLeaseToggle;

  // Shop/Showroom specific
  final bool floorLevel;
  final bool roadFacing;

  // Warehouse specific
  final bool ceilingHeight;
  final bool truckAccess;
  final bool fireSafety;

  const Step3Visibility({
    this.expectedPrice = false,
    this.priceNegotiable = false,
    this.pricePerSqft = false,
    this.uds = false,
    this.ageOfProperty = false,
    this.maintenance = false,
    this.possession = false,
    this.monthlyRent = false,
    this.securityDeposit = false,
    this.monthlyRentalIncome = false,
    this.annualYield = false,
    this.leaseStatus = false,
    this.foodIncluded = false,
    this.maintenanceIncluded = false,
    this.maxOccupancy = false,
    this.showLeaseToggle = false,
    this.floorLevel = false,
    this.roadFacing = false,
    this.ceilingHeight = false,
    this.truckAccess = false,
    this.fireSafety = false,
  });
}

// ========== MASTER LOGIC FUNCTION ==========
Step3Visibility getStep3Visibility({
  required PropertyFor propertyFor,
  SellPropertyType? sellType,
  RentPropertyType? rentType,
}) {
  // ---------- SELL ----------
  if (propertyFor == PropertyFor.sell && sellType != null) {
    switch (sellType) {
      case SellPropertyType.plot:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          pricePerSqft: true,
          possession: true,
        );

      case SellPropertyType.commercialLand:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          pricePerSqft: true,
          possession: true,
        );

      case SellPropertyType.flat:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          pricePerSqft: true,
          uds: true,
          maintenance: true,
          ageOfProperty: true,
          possession: true,
        );

      case SellPropertyType.house:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          ageOfProperty: true,
          possession: true,
        );

      case SellPropertyType.villa:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          ageOfProperty: true,
          maintenance: true,
          possession: true,
        );

      case SellPropertyType.complex:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          maintenance: true,
          ageOfProperty: true,
        );

      case SellPropertyType.commercialBuilding:
        return const Step3Visibility(
          expectedPrice: true,
          priceNegotiable: true,
          pricePerSqft: true,
          leaseStatus: true,
          monthlyRentalIncome: true,
          ageOfProperty: true,
        );
    }
  }

  // ---------- RENT ----------
  if (propertyFor == PropertyFor.rent && rentType != null) {
    switch (rentType) {
      case RentPropertyType.flat:
        return const Step3Visibility(
          monthlyRent: true,
          maintenance: true,
          securityDeposit: true,
          possession: true,
          ageOfProperty: true,
        );

      case RentPropertyType.house:
        return const Step3Visibility(
          monthlyRent: true,
          securityDeposit: true,
          ageOfProperty: true,
          possession: true,
          showLeaseToggle: true, // ✅ Eligible for lease
        );

      case RentPropertyType.villa:
        return const Step3Visibility(
          monthlyRent: true,
          maintenance: true,
          securityDeposit: true,
          ageOfProperty: true,
          possession: true,
        );

      case RentPropertyType.pgHostel:
        return const Step3Visibility(
          monthlyRent: true,
          securityDeposit: true,
          foodIncluded: true,
          maintenanceIncluded: true,
          possession: true,
        );

      case RentPropertyType.sharedRoom:
        return const Step3Visibility(
          monthlyRent: true,
          securityDeposit: true,
          maxOccupancy: true,
          possession: true,
        );

      case RentPropertyType.independentFloor:
        return const Step3Visibility(
          monthlyRent: true,
          maintenance: true,
          securityDeposit: true,
          ageOfProperty: true,
          possession: true,
          showLeaseToggle: true, // ✅ Eligible for lease
        );

      case RentPropertyType.commercialBuilding:
      case RentPropertyType.officeSpace:
        return const Step3Visibility(
          monthlyRent: true,
          pricePerSqft: true,
          maintenance: true,
          securityDeposit: true,
          possession: true,
          showLeaseToggle: true, // ✅ Eligible for lease
        );

      case RentPropertyType.shopShowroom:
        return const Step3Visibility(
          monthlyRent: true,
          securityDeposit: true,
          floorLevel: true,
          roadFacing: true,
          possession: true,
          showLeaseToggle: true, // ✅ Eligible for lease
        );

      case RentPropertyType.warehouse:
        return const Step3Visibility(
          pricePerSqft: true,
          monthlyRent: true,
          securityDeposit: true,
          ceilingHeight: true,
          truckAccess: true,
          fireSafety: true,
          showLeaseToggle: true, // ✅ Eligible for lease
        );
    }
  }

  return const Step3Visibility();
}

// ========== MAIN SCREEN ==========
class AddPropertyStep3Screen extends StatefulWidget {
  final PropertyFor propertyFor;
  final SellPropertyType? sellType;
  final RentPropertyType? rentType;

  const AddPropertyStep3Screen({
    Key? key,
    required this.propertyFor,
    this.sellType,
    this.rentType,
  }) : super(key: key);

  @override
  State<AddPropertyStep3Screen> createState() => _AddPropertyStep3ScreenState();
}

class _AddPropertyStep3ScreenState extends State<AddPropertyStep3Screen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _pricePerSqftController = TextEditingController();
  final TextEditingController _udsController = TextEditingController();
  final TextEditingController _maintenanceController = TextEditingController();
  final TextEditingController _monthlyRentController = TextEditingController();
  final TextEditingController _securityDepositController = TextEditingController();
  final TextEditingController _monthlyRentalIncomeController = TextEditingController();
  final TextEditingController _annualYieldController = TextEditingController();
  final TextEditingController _maxOccupancyController = TextEditingController();
  final TextEditingController _ceilingHeightController = TextEditingController();

  // Lease-specific controllers
  final TextEditingController _overallLeaseAmountController = TextEditingController();
  final TextEditingController _rentEscalationController = TextEditingController();

  // State
  bool _isNegotiable = false;
  bool _foodIncluded = false;
  bool _maintenanceIncluded = false;
  bool _roadFacing = false;
  bool _truckAccess = false;
  bool _fireSafety = false;

  // Lease state
  bool? _isLeaseProperty; // null = not selected, true = lease, false = monthly rent
  bool _registrationRequired = false;

  String? _selectedAge;
  String? _selectedPossession;
  String? _selectedLeaseStatus;
  String? _selectedFloorLevel;

  // Lease-specific selections
  String? _selectedLeaseDuration;
  String? _selectedLockInPeriod;
  String? _selectedNoticePeriod;
  String? _selectedLeaseType;
  String? _selectedOccupancyStatus;
  DateTime? _leaseStartDate;

  final List<String> _propertyAges = [
    '< 5 years',
    '5–10',
    '10–15',
    '15–20',
    '20+',
  ];

  final List<String> _possessionOptions = [
    'Immediate',
    'Within 1 Month',
    'Within 3 Months',
    'Within 6 Months',
    'After 1 Year',
  ];

  final List<String> _leaseStatusOptions = [
    'Vacant',
    'Occupied',
    'Leased',
  ];

  final List<String> _leaseDurationOptions = [
    '1 Year',
    '2 Years',
    '3 Years',
    '5 Years',
    'Custom',
  ];

  final List<String> _lockInPeriodOptions = [
    '6 Months',
    '12 Months',
    '24 Months',
  ];

  final List<String> _noticePeriodOptions = [
    '1 Month',
    '2 Months',
    '3 Months',
    '6 Months',
  ];

  final List<String> _leaseTypeOptions = [
    'Gross Lease',
    'Net Lease',
    'Semi-Gross Lease',
  ];

  final List<String> _occupancyStatusOptions = [
    'Vacant',
    'Pre-Leased',
  ];

  final List<String> _floorLevelOptions = [
    'Basement',
    'Ground Floor',
    '1st Floor',
    '2nd Floor',
    '3rd Floor',
    '4th Floor & Above',
  ];

  @override
  void initState() {
    super.initState();
    // Load existing form data from provider
    _loadExistingData();
  }

  void _loadExistingData() {
    final provider = Provider.of<PropertyFormProvider>(context, listen: false);
    final formData = provider.formData;

    // Load pricing details
    if (formData.price != null) {
      _priceController.text = formData.price!;
    }
    if (formData.pricePerSqft != null) {
      _pricePerSqftController.text = formData.pricePerSqft!;
    }
    if (formData.udsSqft != null) {
      _udsController.text = formData.udsSqft!;
    }
    if (formData.maintenance != null) {
      _maintenanceController.text = formData.maintenance!;
    }
    if (formData.monthlyRent != null) {
      _monthlyRentController.text = formData.monthlyRent!;
    }
    if (formData.securityDeposit != null) {
      _securityDepositController.text = formData.securityDeposit!;
    }
    if (formData.monthlyRentalIncome != null) {
      _monthlyRentalIncomeController.text = formData.monthlyRentalIncome!;
    }
    if (formData.annualYield != null) {
      _annualYieldController.text = formData.annualYield!;
    }
    if (formData.maxOccupancy != null) {
      _maxOccupancyController.text = formData.maxOccupancy!;
    }
    if (formData.ceilingHeight != null) {
      _ceilingHeightController.text = formData.ceilingHeight!;
    }
    if (formData.ageOfProperty != null) {
      _selectedAge = formData.ageOfProperty;
    }
    if (formData.possessionStatus != null) {
      _selectedPossession = formData.possessionStatus;
    }

    // Load lease details
    if (formData.isLeaseProperty != null) {
      _isLeaseProperty = formData.isLeaseProperty;
    }
    if (formData.leaseDuration != null) {
      _selectedLeaseDuration = formData.leaseDuration;
    }
    if (formData.lockInPeriod != null) {
      _selectedLockInPeriod = formData.lockInPeriod;
    }
    if (formData.noticePeriod != null) {
      _selectedNoticePeriod = formData.noticePeriod;
    }
    if (formData.overallLeaseAmount != null) {
      _overallLeaseAmountController.text = formData.overallLeaseAmount!;
    }
    if (formData.rentEscalationPercent != null) {
      _rentEscalationController.text = formData.rentEscalationPercent!;
    }
    if (formData.leaseType != null) {
      _selectedLeaseType = formData.leaseType;
    }
    if (formData.registrationRequired != null) {
      _registrationRequired = formData.registrationRequired!;
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _pricePerSqftController.dispose();
    _udsController.dispose();
    _maintenanceController.dispose();
    _monthlyRentController.dispose();
    _securityDepositController.dispose();
    _monthlyRentalIncomeController.dispose();
    _annualYieldController.dispose();
    _maxOccupancyController.dispose();
    _ceilingHeightController.dispose();

    // Dispose lease controllers
    _overallLeaseAmountController.dispose();
    _rentEscalationController.dispose();

    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = int.tryParse(value.replaceAll(',', '')) ?? 0;
    final format = NumberFormat('#,##,###', 'en_IN');
    return format.format(number);
  }

  void _handleNextStep() {
    if (_formKey.currentState!.validate()) {
      // Save Step 3 data to provider
      final provider = Provider.of<PropertyFormProvider>(context, listen: false);
      final formData = provider.formData;

      // Pricing fields
      formData.price = _priceController.text;
      formData.pricePerSqft = _pricePerSqftController.text;
      formData.udsSqft = _udsController.text;
      formData.maintenance = _maintenanceController.text;
      formData.monthlyRent = _monthlyRentController.text;
      formData.securityDeposit = _securityDepositController.text;
      formData.monthlyRentalIncome = _monthlyRentalIncomeController.text;
      formData.annualYield = _annualYieldController.text;
      formData.maxOccupancy = _maxOccupancyController.text;
      formData.ceilingHeight = _ceilingHeightController.text;

      // Property details
      formData.ageOfProperty = _selectedAge;
      formData.possessionStatus = _selectedPossession;

      // Lease information
      formData.isLeaseProperty = _isLeaseProperty;
      formData.leaseDuration = _selectedLeaseDuration;
      formData.lockInPeriod = _selectedLockInPeriod;
      formData.noticePeriod = _selectedNoticePeriod;
      formData.overallLeaseAmount = _overallLeaseAmountController.text;
      formData.rentEscalationPercent = _rentEscalationController.text;
      formData.leaseType = _selectedLeaseType;
      formData.registrationRequired = _registrationRequired;

      provider.updateFormData(formData);

      // Navigate to Step 4
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPropertyStep4Screen(
            propertyFor: widget.propertyFor,
            sellType: widget.sellType,
            rentType: widget.rentType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibility = getStep3Visibility(
      propertyFor: widget.propertyFor,
      sellType: widget.sellType,
      rentType: widget.rentType,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827), size: 28),
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
              'Pricing & Details',
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
                  child: Form(
                    key: _formKey,
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
                        "Pricing & Property Details",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Set the right price and share property details",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ========== LEASE TOGGLE (Only for eligible rent properties) ==========
                      if (visibility.showLeaseToggle) ...[
                        _buildLeaseToggleSection(),
                        const SizedBox(height: 24),

                        // Helper text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFF3B82F6),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Lease rentals are ideal for commercial or long-term tenants',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(0xFF1E40AF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // EXPECTED PRICE (Sell)
                      if (visibility.expectedPrice) ...[
                        _buildPriceField(
                          controller: _priceController,
                          label: 'Expected Price',
                          hint: '₹ Enter amount',
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ========== MONTHLY RENT OR LEASE FIELDS (Rent) ==========
                      if (visibility.monthlyRent) ...[
                        // If lease toggle is shown and user selected lease = YES
                        if (visibility.showLeaseToggle && _isLeaseProperty == true) ...[
                          _buildLeaseFields(),
                        ]
                        // Otherwise show regular monthly rent (or if lease = NO)
                        else if (!visibility.showLeaseToggle || _isLeaseProperty == false) ...[
                          _buildPriceField(
                            controller: _monthlyRentController,
                            label: widget.rentType == RentPropertyType.pgHostel
                                ? 'Rent per Bed/Room'
                                : widget.rentType == RentPropertyType.sharedRoom
                                ? 'Monthly Rent (Per Person)'
                                : 'Expected Monthly Rent',
                            hint: '₹ Enter monthly rent',
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],

                      // PRICE NEGOTIABLE (Sell only)
                      if (visibility.priceNegotiable) ...[
                        _buildToggle(
                          title: 'Price Negotiable',
                          subtitle: 'Allow buyers to make offers',
                          value: _isNegotiable,
                          onChanged: (val) => setState(() => _isNegotiable = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // PRICE PER SQFT
                      if (visibility.pricePerSqft) ...[
                        _buildTextField(
                          controller: _pricePerSqftController,
                          label: 'Price per Sqft',
                          hint: '₹ per sqft',
                          icon: Icons.straighten,
                          isRequired: widget.rentType == RentPropertyType.warehouse,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // SECURITY DEPOSIT (Rent only - but not for lease since lease has its own)
                      if (visibility.securityDeposit && (!visibility.showLeaseToggle || _isLeaseProperty == false)) ...[
                        _buildPriceField(
                          controller: _securityDepositController,
                          label: 'Security Deposit',
                          hint: '₹ Enter deposit amount',
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),

                        // RENT ESCALATION for regular rental properties
                        _buildTextField(
                          controller: _rentEscalationController,
                          label: 'Rent Escalation (% per year)',
                          hint: 'e.g., 5',
                          icon: Icons.trending_up,
                          isRequired: false,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // UNDIVIDED SHARE (UDS) - Only for Sell + Flat
                      if (visibility.uds) ...[
                        _buildUDSField(),
                        const SizedBox(height: 24),
                      ],

                      // MAINTENANCE CHARGES
                      if (visibility.maintenance) ...[
                        _buildTextField(
                          controller: _maintenanceController,
                          label: 'Maintenance Charges (per month)',
                          hint: '₹ Enter amount',
                          icon: Icons.build,
                          isRequired: false,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // MONTHLY RENTAL INCOME
                      if (visibility.monthlyRentalIncome) ...[
                        _buildPriceField(
                          controller: _monthlyRentalIncomeController,
                          label: 'Monthly Rental (if leased)',
                          hint: '₹ Enter monthly rental income',
                          isRequired: false,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ANNUAL YIELD
                      if (visibility.annualYield) ...[
                        _buildTextField(
                          controller: _annualYieldController,
                          label: 'Annual Yield (%)',
                          hint: 'e.g., 5.5',
                          icon: Icons.percent,
                          isRequired: false,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // LEASE STATUS
                      if (visibility.leaseStatus) ...[
                        _buildSelectionSection(
                          title: 'Occupancy Status',
                          options: _leaseStatusOptions,
                          selectedValue: _selectedLeaseStatus,
                          onSelect: (val) => setState(() => _selectedLeaseStatus = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // FOOD INCLUDED (PG/Hostel)
                      if (visibility.foodIncluded) ...[
                        _buildToggle(
                          title: 'Food Included',
                          subtitle: 'Meals provided with the rent',
                          value: _foodIncluded,
                          onChanged: (val) => setState(() => _foodIncluded = val),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // MAINTENANCE INCLUDED (PG/Hostel)
                      if (visibility.maintenanceIncluded) ...[
                        _buildToggle(
                          title: 'Maintenance Included',
                          subtitle: 'All utilities included in rent',
                          value: _maintenanceIncluded,
                          onChanged: (val) => setState(() => _maintenanceIncluded = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // MAX OCCUPANCY (Shared Room)
                      if (visibility.maxOccupancy) ...[
                        _buildTextField(
                          controller: _maxOccupancyController,
                          label: 'Maximum Occupancy',
                          hint: 'e.g., 2 or 3 persons',
                          icon: Icons.people,
                          isRequired: true,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // FLOOR LEVEL (Shop/Showroom)
                      if (visibility.floorLevel) ...[
                        _buildSelectionSection(
                          title: 'Floor Level',
                          options: _floorLevelOptions,
                          selectedValue: _selectedFloorLevel,
                          onSelect: (val) => setState(() => _selectedFloorLevel = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ROAD FACING (Shop/Showroom)
                      if (visibility.roadFacing) ...[
                        _buildToggle(
                          title: 'Road Facing',
                          subtitle: 'Direct access from main road',
                          value: _roadFacing,
                          onChanged: (val) => setState(() => _roadFacing = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // CEILING HEIGHT (Warehouse)
                      if (visibility.ceilingHeight) ...[
                        _buildTextField(
                          controller: _ceilingHeightController,
                          label: 'Ceiling Height (feet)',
                          hint: 'e.g., 20',
                          icon: Icons.height,
                          isRequired: false,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // TRUCK ACCESS (Warehouse)
                      if (visibility.truckAccess) ...[
                        _buildToggle(
                          title: 'Truck Access',
                          subtitle: 'Heavy vehicle loading/unloading facility',
                          value: _truckAccess,
                          onChanged: (val) => setState(() => _truckAccess = val),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // FIRE SAFETY (Warehouse)
                      if (visibility.fireSafety) ...[
                        _buildToggle(
                          title: 'Fire Safety Compliance',
                          subtitle: 'Fire safety systems installed',
                          value: _fireSafety,
                          onChanged: (val) => setState(() => _fireSafety = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // AGE OF PROPERTY
                      if (visibility.ageOfProperty) ...[
                        _buildSelectionSection(
                          title: 'Age of Property',
                          options: _propertyAges,
                          selectedValue: _selectedAge,
                          onSelect: (val) => setState(() => _selectedAge = val),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // POSSESSION STATUS
                      if (visibility.possession) ...[
                        _buildSelectionSection(
                          title: widget.propertyFor == PropertyFor.rent
                              ? 'Availability'
                              : 'Possession Status',
                          options: _possessionOptions,
                          selectedValue: _selectedPossession,
                          onSelect: (val) => setState(() => _selectedPossession = val),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

          // Navigation Buttons
          _buildNavigationButtons(),
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
                'Step 3 of 5',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              Text(
                'Pricing & Details',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.currency_rupee,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (isRequired)
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
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onChanged: (value) {
            final number = value.replaceAll(',', '');
            if (number.isNotEmpty) {
              final formatted = _formatCurrency(number);
              controller.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            }
          },
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  final number = int.tryParse(value.replaceAll(',', ''));
                  if (number == null || number <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Text(
                '₹',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF10B981), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (isRequired)
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444),
                ),
              )
            else
              Text(
                '(Optional)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                }
              : null,
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

  Widget _buildUDSField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.square_foot,
              color: Color(0xFF10B981),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Undivided Share (UDS) - Sqft',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Land share allocated to your flat',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _udsController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Enter UDS value',
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

  Widget _buildToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: value ? const Color(0xFF10B981) : const Color(0xFFD1D5DB),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF10B981) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
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
      ],
    );
  }

  // ========== LEASE TOGGLE SECTION ==========
  Widget _buildLeaseToggleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Is this property available on Lease?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isLeaseProperty = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isLeaseProperty == true
                        ? const Color(0xFFF0FDF4)
                        : Colors.white,
                    border: Border.all(
                      color: _isLeaseProperty == true
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isLeaseProperty == true
                                ? const Color(0xFF10B981)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                          color: _isLeaseProperty == true
                              ? const Color(0xFF10B981)
                              : Colors.white,
                        ),
                        child: _isLeaseProperty == true
                            ? const Icon(
                                Icons.circle,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _isLeaseProperty == true
                              ? const Color(0xFF111827)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isLeaseProperty = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isLeaseProperty == false
                        ? const Color(0xFFF0FDF4)
                        : Colors.white,
                    border: Border.all(
                      color: _isLeaseProperty == false
                          ? const Color(0xFF10B981)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isLeaseProperty == false
                                ? const Color(0xFF10B981)
                                : const Color(0xFFD1D5DB),
                            width: 2,
                          ),
                          color: _isLeaseProperty == false
                              ? const Color(0xFF10B981)
                              : Colors.white,
                        ),
                        child: _isLeaseProperty == false
                            ? const Icon(
                                Icons.circle,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'No',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _isLeaseProperty == false
                              ? const Color(0xFF111827)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ========== LEASE FIELDS (When lease = YES) ==========
  Widget _buildLeaseFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Lease Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // === A. LEASE TENURE & TERMS ===
        const Text(
          'Lease Tenure & Terms',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),

        // Lease Duration
        _buildSelectionSection(
          title: 'Lease Duration *',
          options: _leaseDurationOptions,
          selectedValue: _selectedLeaseDuration,
          onSelect: (val) => setState(() => _selectedLeaseDuration = val),
        ),
        const SizedBox(height: 16),

        // Lock-in Period (Optional)
        _buildSelectionSection(
          title: 'Lock-in Period (Optional)',
          options: _lockInPeriodOptions,
          selectedValue: _selectedLockInPeriod,
          onSelect: (val) => setState(() => _selectedLockInPeriod = val),
        ),
        const SizedBox(height: 16),

        // Notice Period
        _buildSelectionSection(
          title: 'Notice Period *',
          options: _noticePeriodOptions,
          selectedValue: _selectedNoticePeriod,
          onSelect: (val) => setState(() => _selectedNoticePeriod = val),
        ),
        const SizedBox(height: 24),

        // === B. FINANCIAL LEASE TERMS ===
        const Text(
          'Financial Terms',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),

        // Overall Lease Amount
        _buildPriceField(
          controller: _overallLeaseAmountController,
          label: 'Overall Lease Amount',
          hint: '₹ Enter total lease amount',
        ),
        const SizedBox(height: 24),

        // === C. LEASE TYPE (Optional - Advanced) ===
        const Text(
          'Lease Type (Optional)',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),

        _buildSelectionSection(
          title: 'Type of Lease',
          options: _leaseTypeOptions,
          selectedValue: _selectedLeaseType,
          onSelect: (val) => setState(() => _selectedLeaseType = val),
        ),
        const SizedBox(height: 16),

        // Registration Required
        _buildToggle(
          title: 'Registration Required',
          subtitle: 'Legal registration needed for this lease',
          value: _registrationRequired,
          onChanged: (val) => setState(() => _registrationRequired = val),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNavigationButtons() {
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
            child: Row(
              children: [
                // Back Button
                OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF10B981),
                side: const BorderSide(
                  color: Color(0xFF10B981),
                  width: 2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Next Button
            Expanded(
              child: SizedBox(
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
                    shadowColor: const Color(0xFF10B981).withOpacity(0.3),
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
          ],
        ),
      ),
    ),
    ),
    );
  }
}
