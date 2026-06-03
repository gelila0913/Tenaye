import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/medication_model.dart';
import '../../data/services/medication_service.dart';

class AddMedicationModal extends StatefulWidget {
  const AddMedicationModal({Key? key}) : super(key: key);

  @override
  State<AddMedicationModal> createState() => _AddMedicationModalState();
}

class _AddMedicationModalState extends State<AddMedicationModal> {
  String _selectedFrequency = 'Once daily';
  final List<String> _frequencies = ['Once daily', 'Twice daily', 'Three times daily', 'As needed', 'Every other day'];

  // Input Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Date Picker presentation function
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Media Query helps prevent keyboard overlap during typing states
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom Sheet indicator drag pill
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.border.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              const Text(
                'Add Medication',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Medication Name Input (image_93f370.png)
              _buildInputFieldLabel('Medication Name'),
              _buildTextFormInputField(
                controller: _nameController,
                hintText: 'e.g., Metformin',
              ),
              const SizedBox(height: 16),

              // 2. Dosage Input (image_93f370.png)
              _buildInputFieldLabel('Dosage'),
              _buildTextFormInputField(
                controller: _dosageController,
                hintText: 'e.g., 500mg',
              ),
              const SizedBox(height: 16),

              // 3. Frequency Selection Dropdown (image_93f370.png)
              _buildInputFieldLabel('Frequency'),
              DropdownButtonFormField<String>(
                value: _selectedFrequency,
                dropdownColor: AppColors.surface,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: AppColors.primaryGreen),
                  ),
                ),
                items: _frequencies.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (newVal) {
                  setState(() {
                    _selectedFrequency = newVal!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // 4. Times Comma-Separated Input (image_93f370.png)
              _buildInputFieldLabel('Times (comma separated)'),
              _buildTextFormInputField(
                controller: _timesController,
                hintText: 'e.g., 08:00, 20:00',
              ),
              const SizedBox(height: 16),

              // 5. Dual Start & End Date Pickers Row (image_93f370.png)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputFieldLabel('Start Date'),
                        _buildDatePickerTrigger(
                          text: _startDate == null
                              ? 'mm / dd / yyyy'
                              : '${_startDate!.month}/${_startDate!.day}/${_startDate!.year}',
                          onTap: () => _selectDate(context, true),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputFieldLabel('End Date'),
                        _buildDatePickerTrigger(
                          text: _endDate == null
                              ? 'mm / dd / yyyy'
                              : '${_endDate!.month}/${_endDate!.day}/${_endDate!.year}',
                          onTap: () => _selectDate(context, false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 6. Optional Notes Field (image_93f370.png)
              _buildInputFieldLabel('Notes (optional)'),
              _buildTextFormInputField(
                controller: _notesController,
                hintText: 'Take with food...',
              ),
              const SizedBox(height: 28),

              // Save Actions Anchor
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_nameController.text.trim().isNotEmpty) {
                      final timeList = _timesController.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();

                      final newMed = Medication(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text.trim(),
                        dosage: _dosageController.text.trim(),
                        frequency: _selectedFrequency,
                        times: timeList.isEmpty ? ['08:00'] : timeList,
                        startDate: _startDate,
                        endDate: _endDate,
                        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                      );

                      MedicationService().addMedication(newMed);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Add Medication',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Visual layout element builders
  Widget _buildInputFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextFormInputField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
      ),
    );
  }

  Widget _buildDatePickerTrigger({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: text.contains('/') ? AppColors.textPrimary : AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}