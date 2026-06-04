import { prisma } from '../../config/database';
import { AIService } from '../../config/aiClient';

export class FitnessService {
  static async generateFitnessPlan(userId: string, weeklyGoal: string) {
    // 1. Fetch user profile from DB to get physical stats and medical constraints
    const profile = await prisma.userProfile.findUnique({
      where: { id: userId },
    });

    if (!profile) {
      throw new Error(`Profile not found for userId: ${userId}`);
    }

    // 2. Map profile database fields to AI service interface format
    const profileData = {
      age: profile.age,
      gender: profile.gender,
      height: profile.height,
      weight: profile.weight,
      activityLevel: profile.activityLevel,
      healthGoals: profile.healthGoals,
      allergies: profile.allergies,
      medicalConditions: profile.medicalConditions,
    };

    // 3. Request structural JSON fitness schedule plan from AI client wrapper
    const { weeklyGoal: generatedGoal, scheduleTimelineJson } = await AIService.generateFitnessPlan(
      profileData,
      weeklyGoal
    );

    // 4. Store generated fitness schedule into database
    return prisma.fitnessPlan.create({
      data: {
        userId,
        weeklyGoal: generatedGoal,
        scheduleTimelineJson: scheduleTimelineJson as any,
      },
    });
  }

  static async getFitnessPlans(userId: string) {
    return prisma.fitnessPlan.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
