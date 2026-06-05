import 'package:flutter/material.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../services/api_client.dart';

class FitnessScreen extends StatefulWidget {
  const FitnessScreen({Key? key}) : super(key: key);

  @override
  State<FitnessScreen> createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  final ApiClient _apiClient = ApiClient();
  final String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';

  bool _isPlanGenerated = false;
  bool _isLoading = false;
  String _selectedGoal = 'Maintain Health';
  String _weeklyGoalSummary = '';
  List<dynamic> _days = [];

  // Tracking completion state for each workout day
  final Map<String, bool> _completedDays = {};

  // Tracking expansion state for each workout day
  final Map<String, bool> _expandedDays = {};

  Future<void> _generateWeeklyWorkouts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.post(
        '${ApiConstants.baseUrl}/fitness/generate',
        {
          'userId': _userId,
          'goal': _selectedGoal,
        },
      );

      if (response != null && response['success'] == true) {
        final data = response['data'] ?? {};
        final String summary = data['weeklyGoalSummary'] ?? _selectedGoal;
        final List<dynamic> daysList = data['days'] ?? [];

        setState(() {
          _weeklyGoalSummary = summary;
          _days = daysList;
          _isPlanGenerated = true;

          // Dynamically map expand and completion states
          _expandedDays.clear();
          _completedDays.clear();
          for (int i = 0; i < _days.length; i++) {
            final day = _days[i];
            final String dayLabel = day['dayLabel'] ?? 'Day';
            _expandedDays[dayLabel] = (i == 0); // expand first day by default
            _completedDays[dayLabel] = false;
          }
        });
      } else {
        throw Exception(response?['message'] ?? 'Could not generate workouts.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate fitness plan: $e'),
            backgroundColor: AppColors.emergencyRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unified Brand Header Bar
          const TenayeBrandHeader(
            title: 'Fitness Planner',
            subtitle: 'AI-powered personalized workouts',
          ),

          // Main Scroll Engine
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  // Trigger Action Control Panel Card
                  _buildActionCard(),
                  const SizedBox(height: 20),

                  if (_isLoading) ...[
                    const SizedBox(height: 100),
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ] else if (_isPlanGenerated) ...[
                    // Weekly Focus Strategy Summary Box
                    _buildWeeklyGoalCard(),
                    const SizedBox(height: 16),

                    // Weekly Schedule Timeline Loops
                    _buildScheduleTimeline(),
                    const SizedBox(height: 16),

                    // Supplemental Tips Block Panel
                    _buildFitnessTipsCard(),
                    const SizedBox(height: 24),
                  ] else ...[
                    // Initial State Template View Empty Placement
                    const SizedBox(height: 80),
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select a goal to construct your custom training regimen',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGoalSelector(),
          const SizedBox(height: 16),
          _buildActionButtonHub(),
        ],
      ),
    );
  }

  Widget _buildGoalSelector() {
    final List<String> goals = ['Lose Weight', 'Gain Muscle', 'Maintain Health'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Fitness Goal',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: goals.map((goal) {
            final isSelected = _selectedGoal == goal;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      goal,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.surface,
                  checkmarkColor: Colors.white,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: isSelected ? AppColors.primaryGreen : AppColors.border,
                    ),
                  ),
                  onSelected: _isLoading
                      ? null
                      : (bool selected) {
                          if (selected) {
                            setState(() {
                              _selectedGoal = goal;
                            });
                          }
                        },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtonHub() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _generateWeeklyWorkouts,
        icon: Icon(
          _isPlanGenerated ? Icons.sync_rounded : Icons.fitness_center_rounded,
          size: 18,
          color: Colors.white,
        ),
        label: Text(
          _isPlanGenerated ? 'Regenerate Plan' : 'Generate Workouts Plan',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WEEKLY GOAL',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _weeklyGoalSummary,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleTimeline() {
    return Column(
      children: _days.map<Widget>((day) {
        final String dayLabel = day['dayLabel'] ?? '';
        final String title = day['title'] ?? '';
        final String duration = day['duration'] ?? '';
        final int totalExercises = day['totalExercises'] ?? 0;
        final List<dynamic> exercises = day['exercises'] ?? [];

        final bool isRestDay = exercises.isEmpty || title.toLowerCase().contains('rest');

        if (isRestDay) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildRestDayCard(dayLabel),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildWorkoutCard(
            dayLabel,
            title,
            "$duration · $totalExercises exercise${totalExercises == 1 ? '' : 's'}",
            exercises: exercises,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWorkoutCard(
    String tag,
    String title,
    String meta, {
    List<dynamic> exercises = const [],
  }) {
    bool isCompleted = _completedDays[tag] ?? false;
    bool isExpanded = _expandedDays[tag] ?? false;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border.withOpacity(0.4)),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: isCompleted ? 0.45 : 1.0,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expandedDays[tag] = !isExpanded;
                });
              },
              leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                    fontSize: 13,
                  ),
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                meta,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _completedDays[tag] = !isCompleted;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? AppColors.primaryGreen : Colors.transparent,
                        border: Border.all(
                          color: isCompleted ? AppColors.primaryGreen : AppColors.textSecondary.withOpacity(0.6),
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                child: Column(
                  children: [
                    const Divider(height: 1, color: AppColors.border),
                    const SizedBox(height: 12),
                    ...exercises.map((ex) {
                      final String exName = ex['name'] ?? '';
                      final int sets = ex['sets'] ?? 3;
                      final String reps = ex['reps'] ?? '';
                      return _buildExerciseSubItem(exName, "$sets sets", reps);
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSubItem(String name, String sets, String instructions) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0, right: 12.0),
            child: Icon(Icons.fitness_center_rounded, size: 16, color: AppColors.primaryGreen),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  sets,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  instructions,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestDayCard(String tag) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.border.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tag,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Rest Day 🛌',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessTipsCard() {
    return Container(
      width: double.infinity,
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
            children: const [
              Text('💡', style: TextStyle(fontSize: 16)),
              SizedBox(width: 8),
              Text(
                'Fitness Tips',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipBulletItem('Aim for protein-rich foods to support muscle gain.'),
          _buildTipBulletItem('Include plenty of fruits and vegetables for overall health.'),
          _buildTipBulletItem('Prioritize sleep by creating a calming bedtime routine.'),
          _buildTipBulletItem('Stay consistent with workouts for the best results.'),
          _buildTipBulletItem('Listen to your body and adjust the intensity as needed.'),
        ],
      ),
    );
  }

  Widget _buildTipBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.3))),
        ],
      ),
    );
  }
}