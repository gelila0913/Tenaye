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
        const { availableFoods } = req.body;
        let foodsInputStr = '';
        if (typeof availableFoods === 'string') {
            foodsInputStr = availableFoods.trim();
        }
        const finalFoodsStr = foodsInputStr || '';
        let systemPrompt = '';
        if (profile && userContext) {
            systemPrompt = `You are Tenaye. Use the following patient context to inform all advice. If the context is empty, give general advice.

${userContext}

You are an expert nutritionist. Create a daily meal plan using ONLY the following available foods provided by the user: [${finalFoodsStr}], plus basic pantry staples like salt, oil, and spices. If the user provides no foods, create a standard balanced meal plan.

Strict JSON Enforcement: Force Gemini to return the response strictly as a JSON object that exactly matches our frontend UI needs. The JSON schema MUST be:
{
  "dailyTargetCalories": 2200,
  "meals": [
    {
      "type": "Breakfast",
      "time": "8:00 AM",
      "calories": 600,
      "foods": ["Item 1", "Item 2"],
      "nutrients": "Protein: 30g, Carbs: 50g, Fats: 20g",
      "preparation": "Step by step instructions"
    }
  ]
}

Strict rules:
1. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;
        }
        else {
            systemPrompt = `You are an expert nutritionist. Create a daily meal plan using ONLY the following available foods provided by the user: [${finalFoodsStr}], plus basic pantry staples like salt, oil, and spices. If the user provides no foods, create a standard balanced meal plan.

Strict JSON Enforcement: Force Gemini to return the response strictly as a JSON object that exactly matches our frontend UI needs. The JSON schema MUST be:
{
  "dailyTargetCalories": 2200,
  "meals": [
    {
      "type": "Breakfast",
      "time": "8:00 AM",
      "calories": 600,
      "foods": ["Item 1", "Item 2"],
      "nutrients": "Protein: 30g, Carbs: 50g, Fats: 20g",
      "preparation": "Step by step instructions"
    }
  ]
}

Strict rules:
1. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;
        }
        try {
            const promptInput = userContext || finalFoodsStr || 'daily meal plan';
            const resultText = await aiService_1.AIService.generateText(promptInput, {
                systemInstruction: systemPrompt,
                responseMimeType: 'application/json',
            });
            const jsonResult = JSON.parse(resultText);
            const calorieTarget = Math.round(Number(jsonResult.dailyTargetCalories)) || 2200;
            if (profile) {
                // Save plan to database for registered user
                const plan = await database_1.prisma.nutritionPlan.create({
                    data: {
                        userId: profile.id,
                        rawIngredients: finalFoodsStr || 'None',
                        dailyCalorieTarget: calorieTarget,
                        mealScheduleJson: jsonResult,
                    },
                });
                return res.status(201).json({
                    success: true,
                    message: 'Meal plan generated successfully',
                    data: {
                        ...plan,
                        dailyTargetCalories: calorieTarget,
                        meals: jsonResult.meals || [],
                    },
                });
            }
            else {
                // Return dynamic plan to guest user without database write
                return res.status(200).json({
                    success: true,
                    message: 'Meal plan generated successfully',
                    data: {
                        rawIngredients: finalFoodsStr || 'None',
                        dailyTargetCalories: calorieTarget,
                        meals: jsonResult.meals || [],
                    },
                });
            }
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
