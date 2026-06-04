import { prisma } from '../../config/database';
import { AIService } from '../../config/aiClient';

export class NutritionService {
  static async generateNutritionPlan(userId: string, ingredients: string[]) {
    // 1. Fetch user profile from DB to get dietary profile/goals/allergies
    const profile = await prisma.userProfile.findUnique({
      where: { id: userId },
    });

    if (!profile) {
      throw new Error(`Profile not found for userId: ${userId}`);
    }

    // 2. Map profile database fields to AI service parameter interface type
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

    // 3. Call AI Service to retrieve a structure-validated layout payload
    const { dailyCalorieTarget, mealScheduleJson } = await AIService.generateNutritionPlan(
      profileData,
      ingredients
    );

    // 4. Save generated plan to database
    return prisma.nutritionPlan.create({
      data: {
        userId,
        rawIngredients: ingredients.join(', '),
        dailyCalorieTarget,
        mealScheduleJson: mealScheduleJson as any,
      },
    });
  }

  static async getNutritionPlans(userId: string) {
    return prisma.nutritionPlan.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
