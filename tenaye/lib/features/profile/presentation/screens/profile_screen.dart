import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../services/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  // Constants for dev environment
  final String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';
  final String _userEmail = 'gelilasintayehu79@gmail.com';

  // State configurations
  int _age = 22;
  String _gender = 'Female';
  int _height = 165;
  int _weight = 55;
  String _bloodType = 'AB+';
  String _activityLevel = 'Moderate';
  String _budgetRange = 'Medium';

  final List<String> _conditions = [
    'Diabetes Type 1', 'Diabetes Type 2', 'Hypertension', 'Heart Disease',
    'Kidney Disease', 'Asthma', 'Obesity', 'Thyroid', 'Arthritis', 'Depression', 'Anxiety'
  ];

  final List<String> _healthGoals = [
    'Lose weight', 'Gain muscle', 'Manage diabetes', 'Lower blood pressure',
    'Improve sleep', 'Reduce stress', 'Increase energy', 'Better nutrition'
  ];
  
  final List<String> _selectedConditions = [];
  final List<String> _selectedGoals = ['Gain muscle', 'Improve sleep', 'Reduce stress', 'Increase energy', 'Better nutrition'];
  final List<String> _allergies = ['milk'];
  final List<String> _foods = ['injera', 'egg', 'rice', 'pasta', 'vegetables'];

  // Form input controllers
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _allergyController.dispose();
    _foodController.dispose();
    super.dispose();
  }

  /// Programmatically query user profile via ApiClient.get
  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.get('${ApiConstants.profile}/$_userId');
      if (response != null && response['success'] == true) {
        final Map<String, dynamic> data = response['data'] as Map<String, dynamic>;
        ProfileController.profile.value = data; // Set global profile state
        setState(() {
          _age = data['age'] ?? _age;
          _gender = data['gender'] ?? _gender;
          _height = (data['height'] as num?)?.toInt() ?? _height;
          _weight = (data['weight'] as num?)?.toInt() ?? _weight;
          _bloodType = data['bloodType'] ?? _bloodType;
          _activityLevel = data['activityLevel'] ?? _activityLevel;
          _budgetRange = data['budgetRange'] ?? _budgetRange;

          // Parse dynamic lists
          _selectedConditions.clear();
          if (data['medicalConditions'] != null) {
            _selectedConditions.addAll(List<String>.from(data['medicalConditions']));
          }

          _selectedGoals.clear();
          if (data['healthGoals'] != null) {
            _selectedGoals.addAll(List<String>.from(data['healthGoals']));
          }

          _allergies.clear();
          if (data['allergies'] != null) {
            _allergies.addAll(List<String>.from(data['allergies']));
          }

          _foods.clear();
          if (data['availableFoods'] != null) {
            _foods.addAll(List<String>.from(data['availableFoods']));
          }
        });
      }
    } on ApiException catch (e) {
      // 404 indicates a profile does not exist yet (expected for new signups)
      if (e.statusCode != 404) {
        _showErrorSnackbar('Failed to load profile: ${e.message}');
      }
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred while loading profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Gather inputs, format to JSON, and save profile via ApiClient.post
  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    final payload = {
      'id': _userId,
      'email': _userEmail,
      'age': _age,
      'gender': _gender,
      'height': _height,
      'weight': _weight,
      'bloodType': _bloodType,
      'activityLevel': _activityLevel,
      'budgetRange': _budgetRange,
      'medicalConditions': _selectedConditions,
      'healthGoals': _selectedGoals,
      'allergies': _allergies,
      'availableFoods': _foods,
    };

    try {
      final response = await _apiClient.post(ApiConstants.profile, payload);
      if (response != null && response['success'] == true) {
        final data = response['data'];
        ProfileController.profile.value = data as Map<String, dynamic>?; // Update global state
        _showSuccessSnackbar(response['message'] ?? 'Profile saved successfully!');
      }
    } on ApiException catch (e) {
      _showErrorSnackbar('Failed to save profile: ${e.message}');
    } catch (e) {
      _showErrorSnackbar('An unexpected error occurred while saving profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Unified Brand Header Bar
              TenayeBrandHeader(
                title: 'Health Profile',
                subtitle: _userEmail,
                trailing: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: () {},
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Basic Information Card Component
                      _buildCardWrapper(
                        title: 'Basic Information',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _buildNumericField('Age', _age, (val) => setState(() => _age = val))),
                                const SizedBox(width: 16),
                                Expanded(child: _buildDropdownField('Gender', _gender, ['Female', 'Male', 'Other'], (val) => setState(() => _gender = val!))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: _buildNumericField('Height (cm)', _height, (val) => setState(() => _height = val))),
                                const SizedBox(width: 16),
                                Expanded(child: _buildNumericField('Weight (kg)', _weight, (val) => setState(() => _weight = val))),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildDropdownField('Blood Type', _bloodType, ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'], (val) => setState(() => _bloodType = val!)),
                          ],
                        ),
                      ),

                      // 2. Lifestyle Settings Card Component
                      _buildCardWrapper(
                        title: 'Lifestyle',
                        child: Column(
                          children: [
                            _buildDropdownField('Activity Level', _activityLevel, ['Sedentary', 'Light', 'Moderate', 'Active'], (val) => setState(() => _activityLevel = val!)),
                            const SizedBox(height: 16),
                            _buildDropdownField('Budget Range', _budgetRange, ['Low', 'Medium', 'High'], (val) => setState(() => _budgetRange = val!)),
                          ],
                        ),
                      ),

                      // 3. Medical Conditions Chip Wrap Selection
                      _buildCardWrapper(
                        title: 'Medical Conditions',
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _conditions.map((condition) {
                            final isSelected = _selectedConditions.contains(condition);
                            return ChoiceChip(
                              label: Text(condition),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedConditions.add(condition);
                                  } else {
                                    _selectedConditions.remove(condition);
                                  }
                                });
                              },
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              backgroundColor: AppColors.background.withOpacity(0.4),
                              selectedColor: Colors.orange.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
                            );
                          }).toList(),
                        ),
                      ),

                      // 4. Allergies Token Entry Card Component
                      _buildCardWrapper(
                        title: 'Allergies',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddInputRow('Add allergy...', _allergyController, () {
                              final text = _allergyController.text.trim();
                              if (text.isNotEmpty) {
                                setState(() {
                                  if (!_allergies.contains(text)) {
                                    _allergies.add(text);
                                  }
                                  _allergyController.clear();
                                });
                              }
                            }),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8.0,
                              children: _allergies.map((allergy) => _buildTokenChip(allergy, () {
                                setState(() {
                                  _allergies.remove(allergy);
                                });
                              })).toList(),
                            )
                          ],
                        ),
                      ),

                      // 5. Health Goals Chip Selectors Card Component
                      _buildCardWrapper(
                        title: 'Health Goals',
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _healthGoals.map((goal) {
                            final isSelected = _selectedGoals.contains(goal);
                            return ChoiceChip(
                              label: Text(goal),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedGoals.add(goal);
                                  } else {
                                    _selectedGoals.remove(goal);
                                  }
                                });
                              },
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              backgroundColor: AppColors.background.withOpacity(0.4),
                              selectedColor: Colors.orange.shade700,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
                            );
                          }).toList(),
                        ),
                      ),

                      // 6. Available Foods Component Segment
                      _buildCardWrapper(
                        title: 'Available Foods at Home',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAddInputRow('e.g., rice, eggs...', _foodController, () {
                              final text = _foodController.text.trim();
                              if (text.isNotEmpty) {
                                setState(() {
                                  if (!_foods.contains(text)) {
                                    _foods.add(text);
                                  }
                                  _foodController.clear();
                                });
                              }
                            }),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: _foods.map((food) => _buildTokenChip(food, () {
                                setState(() {
                                  _foods.remove(food);
                                });
                              })).toList(),
                            )
                          ],
                        ),
                      ),

                      // 7. Emergency Contacts Section Array Card Component
                      _buildCardWrapper(
                        title: 'Emergency Contacts',
                        trailingAction: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sintayehu Demeke', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                SizedBox(height: 4),
                                Text('father · 0911387501', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                              ],
                            ),
                            Icon(Icons.close_rounded, color: AppColors.textSecondary, size: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Form Commit CTA Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: AppColors.textLight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                          ),
                          icon: _isLoading 
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.save_rounded, size: 18),
                          label: Text(
                            _isLoading ? 'Saving...' : 'Save Profile', 
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            ),
        ],
      ),
    );
  }

  // Layout helper blocks
  Widget _buildCardWrapper({required String title, required Widget child, bool trailingAction = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              if (trailingAction) Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.add, size: 18, color: AppColors.textPrimary),
              )
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildNumericField(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: AppColors.border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$value', style: const TextStyle(fontSize: 15, color: AppColors.textPrimary)),
              Column(
                children: [
                  GestureDetector(onTap: () => onChanged(value + 1), child: const Icon(Icons.keyboard_arrow_up, size: 16, color: AppColors.textSecondary)),
                  GestureDetector(onTap: () => onChanged(value > 0 ? value - 1 : 0), child: const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary)),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildDropdownField(String label, String current, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: current,
          dropdownColor: AppColors.surface,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.primaryGreen)),
          ),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        )
      ],
    );
  }

  Widget _buildAddInputRow(String hint, TextEditingController controller, VoidCallback onAdd) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onAdd(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: const BorderSide(color: AppColors.primaryGreen)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.add, color: AppColors.textSecondary, size: 20),
          ),
        )
      ],
    );
  }

  Widget _buildTokenChip(String label, VoidCallback onDelete) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primaryGreen),
      onDeleted: onDelete,
      backgroundColor: AppColors.primaryGreen.withOpacity(0.08),
      labelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 14, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide.none),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}