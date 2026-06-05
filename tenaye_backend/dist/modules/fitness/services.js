"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FitnessService = void 0;
const database_1 = require("../../config/database");
const aiClient_1 = require("../../config/aiClient");
class FitnessService {
    static async generateFitnessPlan(userId, weeklyGoal) {
        // 1. Fetch user profile from DB to get physical stats and medical constraints
        const profile = await database_1.prisma.userProfile.findUnique({
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
        const { weeklyGoal: generatedGoal, scheduleTimelineJson } = await aiClient_1.AIService.generateFitnessPlan(profileData, weeklyGoal);
        // 4. Store generated fitness schedule into database
        return database_1.prisma.fitnessPlan.create({
            data: {
                userId,
                weeklyGoal: generatedGoal,
                scheduleTimelineJson: scheduleTimelineJson,
            },
        });
    }
    static async getFitnessPlans(userId) {
        return database_1.prisma.fitnessPlan.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
}
exports.FitnessService = FitnessService;
