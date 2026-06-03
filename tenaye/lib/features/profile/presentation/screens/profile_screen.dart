import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock configurations mirroring the visual states
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
  
  final List<String> _selectedGoals = ['Gain muscle', 'Improve sleep', 'Reduce stress', 'Increase energy', 'Better nutrition'];
  final List<String> _allergies = ['milk'];
  final List<String> _foods = ['injera', 'egg', 'rice', 'pasta', 'vegitables '];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified Brand Header Bar
          TenayeBrandHeader(
            title: 'Health Profile',
            subtitle: 'gelilasintayehu79@gmail.com',
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
                  // 1. Basic Information Card Component (image_d9bfb4.png)
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

                  // 2. Lifestyle Settings Card Component (image_d9bf75.png)
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

                  // 3. Medical Conditions Chip Wrap Selection (image_d9bf75.png)
                  _buildCardWrapper(
                    title: 'Medical Conditions',
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _conditions.map((condition) {
                        return ChoiceChip(
                          label: Text(condition),
                          selected: false,
                          onSelected: (_) {},
                          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          backgroundColor: AppColors.background.withOpacity(0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
                        );
                      }).toList(),
                    ),
                  ),

                  // 4. Allergies Token Entry Card Component (image_d9bf3b.png)
                  _buildCardWrapper(
                    title: 'Allergies',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddInputRow('Add allergy...'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8.0,
                          children: _allergies.map((allergy) => _buildTokenChip(allergy)).toList(),
                        )
                      ],
                    ),
                  ),

                  // 5. Health Goals Chip Selectors Card Component (image_d9bf3b.png)
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
                          onSelected: (_) {},
                          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          backgroundColor: AppColors.background.withOpacity(0.4),
                          selectedColor: Colors.orange.shade700,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0), side: BorderSide.none),
                        );
                      }).toList(),
                    ),
                  ),

                  // 6. Available Foods Component Segment (image_d96d3e.png)
                  _buildCardWrapper(
                    title: 'Available Foods at Home',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAddInputRow('e.g., rice, eggs...'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _foods.map((food) => _buildTokenChip(food)).toList(),
                        )
                      ],
                    ),
                  ),

                  // 7. Emergency Contacts Section Array Card Component (image_d96d3e.png)
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

                  // Form Commit CTA Action Button (image_d96d3e.png)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.textLight,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      ),
                      icon: const Icon(Icons.save_rounded, size: 18),
                      label: const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildAddInputRow(String hint) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
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
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: AppColors.border)),
          child: const Icon(Icons.add, color: AppColors.textSecondary, size: 20),
        )
      ],
    );
  }

  Widget _buildTokenChip(String label) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primaryGreen),
      onDeleted: () {},
      backgroundColor: AppColors.primaryGreen.withOpacity(0.08),
      labelStyle: const TextStyle(color: AppColors.primaryGreen, fontSize: 14, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide.none),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}