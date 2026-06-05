"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NutritionService = void 0;
const database_1 = require("../../config/database");
const aiClient_1 = require("../../config/aiClient");
class NutritionService {
    static async generateNutritionPlan(userId, ingredients) {
        // 1. Fetch user profile from DB to get dietary profile/goals/allergies
        const profile = await database_1.prisma.userProfile.findUnique({
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
        const { dailyCalorieTarget, mealScheduleJson } = await aiClient_1.AIService.generateNutritionPlan(profileData, ingredients);
        // 4. Save generated plan to database
        return database_1.prisma.nutritionPlan.create({
            data: {
                userId,
                rawIngredients: ingredients.join(', '),
                dailyCalorieTarget,
                mealScheduleJson: mealScheduleJson,
            },
        });
    }
    static async getNutritionPlans(userId) {
        return database_1.prisma.nutritionPlan.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
}
exports.NutritionService = NutritionService;
