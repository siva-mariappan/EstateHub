import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'add_property_screen_1.dart';
import '../providers/property_form_provider.dart';
import '../services/property_submission_service.dart';

enum ListedBy { owner, agent, builder }

class AddPropertyStep5Screen extends StatefulWidget {
  final PropertyFor propertyFor;
  final SellPropertyType? sellType;
  final RentPropertyType? rentType;

  const AddPropertyStep5Screen({
    Key? key,
    required this.propertyFor,
    this.sellType,
    this.rentType,
  }) : super(key: key);

  @override
  State<AddPropertyStep5Screen> createState() => _AddPropertyStep5ScreenState();
}

class _AddPropertyStep5ScreenState extends State<AddPropertyStep5Screen> {
  final _formKey = GlobalKey<FormState>();

  // Contact Details
  ListedBy? _listedBy;
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _whatsappSame = false;

  // Agent Details
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _reraNumberController = TextEditingController();
  String? _experience;
  final TextEditingController _officeAddressController = TextEditingController();

  // Builder Details
  final TextEditingController _companyNameController = TextEditingController();
  String? _projectsCompleted;
  final TextEditingController _companyAddressController = TextEditingController();

  final List<String> _experienceOptions = [
    '1–3 years',
    '3–5 years',
    '5–10 years',
    '10+ years',
  ];

  final List<String> _projectsOptions = [
    '1–5',
    '5–10',
    '10–20',
    '20+',
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

    // Load contact details
    if (formData.contactName != null) {
      _contactNameController.text = formData.contactName!;
    }
    if (formData.contactMobile != null) {
      _mobileController.text = formData.contactMobile!;
    }
    if (formData.contactEmail != null) {
      _emailController.text = formData.contactEmail!;
    }
    if (formData.whatsappAvailable != null) {
      _whatsappSame = formData.whatsappAvailable!;
    }
    if (formData.listedBy != null) {
      switch (formData.listedBy) {
        case 'owner':
          _listedBy = ListedBy.owner;
          break;
        case 'agent':
          _listedBy = ListedBy.agent;
          break;
        case 'builder':
          _listedBy = ListedBy.builder;
          break;
      }
    }

    // Load agent details
    if (formData.agencyName != null) {
      _agencyNameController.text = formData.agencyName!;
    }
    if (formData.reraNumber != null) {
      _reraNumberController.text = formData.reraNumber!;
    }
    if (formData.officeAddress != null) {
      _officeAddressController.text = formData.officeAddress!;
    }

    // Load builder details
    if (formData.companyName != null) {
      _companyNameController.text = formData.companyName!;
    }
    if (formData.companyAddress != null) {
      _companyAddressController.text = formData.companyAddress!;
    }
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _agencyNameController.dispose();
    _reraNumberController.dispose();
    _officeAddressController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    super.dispose();
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 10) {
      return 'Please enter a valid 10-digit mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    return null;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Save Step 5 contact data to provider
      final provider = Provider.of<PropertyFormProvider>(context, listen: false);
      final formData = provider.formData;

      formData.contactName = _contactNameController.text;
      formData.contactMobile = _mobileController.text;
      formData.contactEmail = _emailController.text;
      formData.whatsappAvailable = _whatsappSame;
      formData.listedBy = _listedBy?.name;

      // Agent specific fields
      if (_listedBy == ListedBy.agent) {
        formData.agencyName = _agencyNameController.text;
        formData.reraNumber = _reraNumberController.text;
        formData.officeAddress = _officeAddressController.text;
      }

      // Builder specific fields
      if (_listedBy == ListedBy.builder) {
        formData.companyName = _companyNameController.text;
        formData.companyAddress = _companyAddressController.text;
      }

      provider.updateFormData(formData);

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF10B981)),
                  SizedBox(height: 16),
                  Text('Submitting property...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        // Submit property to database
        final submissionService = PropertySubmissionService();
        final propertyId = await submissionService.submitProperty(formData);

        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✓ Property submitted successfully!'),
              backgroundColor: Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );

          // Reset form data
          provider.resetForm();

          // Navigate back to home
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          });
        }
      } catch (e) {
        // Close loading dialog
        if (mounted) Navigator.pop(context);

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
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
              'Contact & Agent',
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
                constraints: const BoxConstraints(maxWidth: 900),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                    // Listed By Section
                    _buildListedBySection(),
                    const SizedBox(height: 16),

                    // Contact Details Section
                    _buildContactDetailsSection(),
                    const SizedBox(height: 16),

                    // Agent Details (conditional)
                    if (_listedBy == ListedBy.agent) ...[
                      _buildAgentDetailsSection(),
                      const SizedBox(height: 16),
                    ],

                    // Builder Details (conditional)
                    if (_listedBy == ListedBy.builder) ...[
                      _buildBuilderDetailsSection(),
                      const SizedBox(height: 16),
                    ],

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),

          // Submit Button
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step 5 of 5',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Contact & Agent',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF10B981),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListedBySection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Listed By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: ListedBy.values.map((option) {
              final isSelected = _listedBy == option;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _listedBy = option),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF0FDF4)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE5E7EB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFD1D5DB),
                              width: 2,
                            ),
                            color: isSelected
                                ? const Color(0xFF10B981)
                                : Colors.white,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option == ListedBy.owner
                              ? 'Owner'
                              : option == ListedBy.agent
                              ? 'Agent'
                              : 'Builder',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF111827)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          // Contact Name
          _buildTextFormField(
            controller: _contactNameController,
            label: 'Contact Name',
            hint: 'Enter your name',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Contact name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mobile Number
          _buildTextFormField(
            controller: _mobileController,
            label: 'Mobile Number',
            hint: 'Enter 10-digit mobile number',
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: _validateMobile,
          ),
          const SizedBox(height: 16),

          // Email
          _buildTextFormField(
            controller: _emailController,
            label: 'Email (Optional)',
            hint: 'your.email@example.com',
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),

          // WhatsApp Same
          GestureDetector(
            onTap: () => setState(() => _whatsappSame = !_whatsappSame),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _whatsappSame
                          ? const Color(0xFF10B981)
                          : Colors.white,
                      border: Border.all(
                        color: _whatsappSame
                            ? const Color(0xFF10B981)
                            : const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: _whatsappSame
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Same number available on WhatsApp',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agent Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _agencyNameController,
            label: 'Agency Name',
            hint: 'Enter agency name',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Agency name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _reraNumberController,
            label: 'RERA Registration Number',
            hint: 'Enter RERA number',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'RERA registration number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildDropdownField(
            label: 'Years of Experience',
            value: _experience,
            items: _experienceOptions,
            onChanged: (value) => setState(() => _experience = value),
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _officeAddressController,
            label: 'Office Address (Optional)',
            hint: 'Enter office address',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          _buildVerificationBadges(),
        ],
      ),
    );
  }

  Widget _buildBuilderDetailsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Builder Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _companyNameController,
            label: 'Company Name',
            hint: 'Enter company name',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Company name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _reraNumberController,
            label: 'RERA Registration Number',
            hint: 'Enter RERA number',
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'RERA registration number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          _buildDropdownField(
            label: 'Projects Completed',
            value: _projectsCompleted,
            items: _projectsOptions,
            onChanged: (value) => setState(() => _projectsCompleted = value),
          ),
          const SizedBox(height: 16),

          _buildTextFormField(
            controller: _companyAddressController,
            label: 'Company Address (Optional)',
            hint: 'Enter company address',
            maxLines: 3,
          ),
          const SizedBox(height: 16),

          _buildVerificationBadges(),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isRequired = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              'Select $label',
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6B7280),
            ),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationBadges() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield,
            size: 20,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 8),
          const Text(
            'RERA Verified',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.phone,
            size: 20,
            color: Color(0xFF10B981),
          ),
          const SizedBox(width: 8),
          const Text(
            'Mobile Verified',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
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
            onPressed: _handleSubmit,
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
                Icon(Icons.check_circle, size: 24),
                SizedBox(width: 8),
                Text(
                  'Submit Property',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
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
