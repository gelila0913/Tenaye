"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FitnessController = void 0;
const aiService_1 = require("../services/aiService");
const database_1 = require("../config/database");
class FitnessController {
    /**
     * Generate a fitness plan (POST /api/fitness/generate)
     */
    static async generateFitnessPlan(req, res) {
        const userContext = req.userContext;
        const profile = req.userProfile;
        const { goal } = req.body;
        const selectedGoal = goal || 'Maintain Health';
        let systemPrompt = '';
        if (profile && userContext) {
            systemPrompt = `You are an expert personal trainer. Create a weekly fitness plan for this user. Their primary goal is: [${selectedGoal}]. Here is their medical and physical context: [${userContext}]. Ensure the workouts are safe for their specific conditions.

Strict JSON Enforcement: Force Gemini to return the response strictly as a JSON object matching the frontend UI requirements. The schema MUST be:
{
  "weeklyGoalSummary": "Your customized summary here",
  "days": [
    {
      "dayLabel": "Mon",
      "title": "Strength Training",
      "duration": "60min",
      "totalExercises": 4,
      "exercises": [
        {
          "name": "Squats",
          "sets": 3,
          "reps": "12-15 reps"
        }
      ]
    }
  ]
}

Strict rules:
1. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;
        }
        else {
            systemPrompt = `You are an expert personal trainer. Create a weekly fitness plan for this user. Their primary goal is: [${selectedGoal}].

Strict JSON Enforcement: Force Gemini to return the response strictly as a JSON object matching the frontend UI requirements. The schema MUST be:
{
  "weeklyGoalSummary": "Your customized summary here",
  "days": [
    {
      "dayLabel": "Mon",
      "title": "Strength Training",
      "duration": "60min",
      "totalExercises": 4,
      "exercises": [
        {
          "name": "Squats",
          "sets": 3,
          "reps": "12-15 reps"
        }
      ]
    }
  ]
}

Strict rules:
1. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;
        }
        try {
            const promptInput = userContext || `Create a weekly workout plan for goal: ${selectedGoal}`;
            const resultText = await aiService_1.AIService.generateText(promptInput, {
                systemInstruction: systemPrompt,
                responseMimeType: 'application/json',
            });
            const jsonResult = JSON.parse(resultText);
            if (profile) {
                // Save plan to database for registered user
                const plan = await database_1.prisma.fitnessPlan.create({
                    data: {
                        userId: profile.id,
                        weeklyGoal: jsonResult.weeklyGoalSummary || selectedGoal,
                        scheduleTimelineJson: jsonResult,
                    },
                });
                return res.status(201).json({
                    success: true,
                    message: 'Fitness plan generated successfully',
                    data: {
                        ...plan,
                        weeklyGoalSummary: jsonResult.weeklyGoalSummary || selectedGoal,
                        days: jsonResult.days || [],
                    },
                });
            }
            else {
                // Return dynamic plan to guest user without database write
                return res.status(200).json({
                    success: true,
                    message: 'Fitness plan generated successfully',
                    data: {
                        weeklyGoalSummary: jsonResult.weeklyGoalSummary || selectedGoal,
                        days: jsonResult.days || [],
                    },
                });
            }
        }
        catch (error) {
            console.error('Failed to generate fitness plan:', error);
            return res.status(500).json({
                success: false,
                error: 'GenerationError',
                message: error.message || 'Failed to generate fitness plan from AI.',
            });
        }
    }
    /**
     * Get historical fitness plans (GET /api/fitness/:userId)
     */
    static async getFitnessPlans(req, res) {
        const { userId } = req.params;
        const plans = await database_1.prisma.fitnessPlan.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
        return res.status(200).json({
            success: true,
            data: plans,
        });
    }
}
exports.FitnessController = FitnessController;
