import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/services/health_tracking_service.dart';

class LogMeasurementModal extends StatefulWidget {
  final String initialType;
  
  const LogMeasurementModal({
    super.key,
    this.initialType = 'Blood Pressure',
  });

  @override
  State<LogMeasurementModal> createState() => _LogMeasurementModalState();
}

class _LogMeasurementModalState extends State<LogMeasurementModal> {
  late String _selectedType;
  final _valueController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _notesController = TextEditingController();
  XFile? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _pickedImage = image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  final List<String> _measurementTypes = [
    'Blood Pressure',
    'Blood Glucose',
    'Weight',
    'Heart Rate',
    'Water Intake',
    'Oxygen Level',
    'Temperature'
  ];

  @override
  void initState() {
    super.initState();
    // Safety check to ensure the initialType is within _measurementTypes
    if (_measurementTypes.contains(widget.initialType)) {
      _selectedType = widget.initialType;
    } else {
      _selectedType = 'Blood Pressure';
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _diastolicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic changes depending on category selection
    final bool isBloodPressure = _selectedType == 'Blood Pressure';
    String valueLabel = 'Value';
    String valueHint = 'Enter value';

    if (isBloodPressure) {
      valueLabel = 'Systolic (mmHg)';
      valueHint = 'Upper number (e.g. 120)';
    } else if (_selectedType == 'Blood Glucose') {
      valueLabel = 'Value (mg/dL)';
      valueHint = 'e.g. 90';
    } else if (_selectedType == 'Weight') {
      valueLabel = 'Value (kg)';
      valueHint = 'e.g. 70';
    } else if (_selectedType == 'Heart Rate') {
      valueLabel = 'Value (bpm)';
      valueHint = 'e.g. 72';
    } else if (_selectedType == 'Water Intake') {
      valueLabel = 'Value (mL)';
      valueHint = 'e.g. 250';
    } else if (_selectedType == 'Oxygen Level') {
      valueLabel = 'Value (%)';
      valueHint = 'e.g. 98';
    } else if (_selectedType == 'Temperature') {
      valueLabel = 'Value (°C)';
      valueHint = 'e.g. 36.5';
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Container(
        width: MediaQuery.of(context).size.width > 500 ? 460 : double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modal Title Row with Close Trigger Dismissal Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Log Measurement',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dropdown Input Section: Type Selection Row
              const Text('Type', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: AppColors.primaryGreen, width: 1.2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                    items: _measurementTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type, style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedType = newValue;
                          if (_selectedType != 'Weight') {
                            _pickedImage = null;
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Metric Primary Input Block
              Text(valueLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              _buildInputField(controller: _valueController, hint: valueHint),
              
              // Conditional Secondary Field (Only drops into frame if Blood Pressure is active)
              if (isBloodPressure) ...[
                const SizedBox(height: 18),
                const Text('Diastolic (mmHg)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                _buildInputField(controller: _diastolicController, hint: 'Lower number (e.g. 80)'),
              ],
              const SizedBox(height: 18),

              // Notes Input Field Area (Optional)
              const Text('Notes (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              _buildInputField(controller: _notesController, hint: 'Any notes...', maxLines: 2),
              if (_selectedType == 'Weight') ...[
                const SizedBox(height: 18),
                const Text('Progress Photo (optional)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                if (_pickedImage == null)
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryGreen),
                    label: const Text('Add Progress Photo', style: TextStyle(color: AppColors.primaryGreen)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.photo_outlined, color: AppColors.primaryGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _pickedImage!.name,
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _pickedImage = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 24),

              // Primary Action Save Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (_valueController.text.trim().isNotEmpty) {
                      HealthTrackingService().addRecord(
                        _selectedType,
                        _valueController.text.trim(),
                        diastolic: _diastolicController.text.trim().isEmpty 
                            ? null 
                            : _diastolicController.text.trim(),
                        image: _pickedImage,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.textLight,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: const Text(
                    'Save Measurement',
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: maxLines == 1 ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        filled: true,
        fillColor: AppColors.background.withValues(alpha: 0.5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        ),
      ),
    );
  }
}
