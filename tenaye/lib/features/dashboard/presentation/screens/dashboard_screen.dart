import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/tab_navigation_controller.dart';
import '../../../chat/presentation/screens/chat_assistant_screen.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_action_grid.dart';
import '../../../../services/api_client.dart';
import '../../../../core/constants/api_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  // Constants matching the dev environment
  final String _userId = 'c2fdb290-8e68-458f-a984-01be63b964cd';

  String _bloodPressure = '—';
  String _glucose = '—';
  String _weight = '—';

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  /// Retrieve latest recorded vital signs and recent weight logs
  Future<void> _fetchDashboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Fetch metrics history grouped by type
      final metricsUrl = '${ApiConstants.baseUrl}/metrics/history/$_userId';
      final metricsResponse = await _apiClient.get(metricsUrl);

      // 2. Fetch weight log history (sorted by date ascending)
      final weightUrl = '${ApiConstants.baseUrl}/weight/history/$_userId';
      final weightResponse = await _apiClient.get(weightUrl);

      if (!mounted) return;
      setState(() {
        // Parse health measurements (extract Blood Pressure and Glucose)
        if (metricsResponse != null && metricsResponse['success'] == true) {
          final data = metricsResponse['data'] as Map<String, dynamic>?;
          if (data != null) {
            // Latest Blood Pressure is the first element (sorted by desc in backend)
            final bpList = data['Blood Pressure'] as List?;
            if (bpList != null && bpList.isNotEmpty) {
              _bloodPressure = bpList.first['value']?.toString() ?? '—';
            } else {
              _bloodPressure = '—';
            }

            // Latest Glucose (look for either 'Glucose' or 'Blood Glucose')
            final glucoseList = (data['Glucose'] as List?) ?? (data['Blood Glucose'] as List?);
            if (glucoseList != null && glucoseList.isNotEmpty) {
              _glucose = glucoseList.first['value']?.toString() ?? '—';
            } else {
              _glucose = '—';
            }
          }
        }

        // Parse weight logs (last element is the most recent due to asc sorting)
        if (weightResponse != null && weightResponse['success'] == true) {
          final weightList = weightResponse['data'] as List?;
          if (weightList != null && weightList.isNotEmpty) {
            _weight = weightList.last['weight']?.toString() ?? '—';
          } else {
            _weight = '—';
          }
        }
      });
    } on ApiException catch (e) {
      debugPrint('ApiException while loading dashboard data: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error while loading dashboard data: $e');
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
      body: Stack(
        children: [
          // Primary Scroll Surface Container
          RefreshIndicator(
            onRefresh: _fetchDashboardData,
            color: AppColors.primaryGreen,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingHeader(
                    bloodPressure: _bloodPressure,
                    glucose: _glucose,
                    weight: _weight,
                    isLoading: _isLoading,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood prompt callout banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.moodAccent.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: AppColors.moodAccent, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text("How are you feeling today?", style: AppTextStyles.sectionHeader),
                                    SizedBox(height: 4),
                                    Text("Log your mood", style: AppTextStyles.bodySecondary),
                                  ],
                                ),
                              ),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.resolveOrange,
                                  side: const BorderSide(color: AppColors.resolveOrange),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                ),
                                icon: const Icon(Icons.favorite_border, size: 18),
                                label: const Text("Check In", style: TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  // Switch to Mood page (index 3)
                                  TabNavigationController.changeTab(3);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        const Text("QUICK ACTIONS", style: AppTextStyles.sectionHeader),
                        const SizedBox(height: 16),
                        const QuickActionGrid(),
                        const SizedBox(height: 80), // Bottom spacing so items aren't cut off
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Floating AI Copilot position block
          Positioned(
            bottom: 20,
            right: 20, 
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryGreen,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.smart_toy_outlined, color: AppColors.textLight, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatAssistantScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
