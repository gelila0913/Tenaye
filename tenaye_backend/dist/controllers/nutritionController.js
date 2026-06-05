"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NutritionController = void 0;
const aiService_1 = require("../services/aiService");
const database_1 = require("../config/database");
class NutritionController {
    /**
     * Generate a nutrition plan (POST /api/nutrition/generate)
     */
    static async generateNutritionPlan(req, res) {
        const userContext = req.userContext;
        const profile = req.userProfile;
        if (!profile || !userContext) {
            return res.status(500).json({
                success: false,
                error: 'ServerError',
                message: 'User context was not synthesized correctly.',
            });
        }
        // Format available foods list
        let availableFoodsStr = '';
        if (Array.isArray(profile.availableFoods)) {
            availableFoodsStr = profile.availableFoods.join(', ');
        }
        else if (typeof profile.availableFoods === 'string') {
            try {
                const parsed = JSON.parse(profile.availableFoods);
                if (Array.isArray(parsed)) {
                    availableFoodsStr = parsed.join(', ');
                }
                else {
                    availableFoodsStr = profile.availableFoods;
                }
            }
            catch {
                availableFoodsStr = profile.availableFoods;
            }
        }
        const systemPrompt = `
You are a highly skilled clinical dietitian. Your task is to generate a personalized daily nutrition and meal plan.
Generate a strictly structured JSON object adhering to the user's profile context.

Strict rules:
1. You must design the meal plan utilizing ONLY the user's available foods. Do not introduce any ingredients that are not in the available foods list or that conflict with the user's allergies.
2. The available foods list is: [${availableFoodsStr}]. If this list is empty, fallback to basic healthy ingredients that are compatible with the user's goals and allergies.
3. Your output MUST be a valid JSON object matching this schema exactly:
{
  "dailyCalorieTarget": <integer>,
  "mealSchedule": {
    "breakfast": { "meals": ["detailed meal descriptions"], "calories": <int>, "nutrients": "primary nutrients description" },
    "lunch": { "meals": ["detailed meal descriptions"], "calories": <int>, "nutrients": "primary nutrients description" },
    "dinner": { "meals": ["detailed meal descriptions"], "calories": <int>, "nutrients": "primary nutrients description" },
    "snacks": { "meals": ["detailed meal descriptions"], "calories": <int>, "nutrients": "primary nutrients description" }
  },
  "dietaryAdvice": ["general piece of advice 1", "general piece of advice 2"]
}
4. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;
        try {
            const resultText = await aiService_1.AIService.generateText(userContext, {
                systemInstruction: systemPrompt,
                responseMimeType: 'application/json',
            });
            const jsonResult = JSON.parse(resultText);
            // Save plan to database
            const plan = await database_1.prisma.nutritionPlan.create({
                data: {
                    userId: profile.id,
                    rawIngredients: availableFoodsStr || 'None',
                    dailyCalorieTarget: jsonResult.dailyCalorieTarget || 2000,
                    mealScheduleJson: jsonResult.mealSchedule || jsonResult,
                },
            });
            return res.status(201).json({
                success: true,
                message: 'Meal plan generated successfully',
                data: {
                    ...plan,
                    dietaryAdvice: jsonResult.dietaryAdvice || [],
                },
            });
        }
        catch (error) {
            console.error('Failed to generate nutrition plan:', error);
            return res.status(500).json({
                success: false,
                error: 'GenerationError',
                message: error.message || 'Failed to generate meal plan from AI.',
            });
        }
    }
    /**
     * Get historical nutrition plans (GET /api/nutrition/:userId)
     */
    static async getNutritionPlans(req, res) {
        const { userId } = req.params;
        const plans = await database_1.prisma.nutritionPlan.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
        return res.status(200).json({
            success: true,
            data: plans,
        });
    }
}
exports.NutritionController = NutritionController;
