import { Response } from 'express';
import { ContextRequest } from '../middleware/context';
import { AIService } from '../services/aiService';
import { prisma } from '../config/database';

export class FitnessController {
  /**
   * Generate a fitness plan (POST /api/fitness/generate)
   */
  static async generateFitnessPlan(req: ContextRequest, res: Response) {
    const userContext = req.userContext;
    const profile = req.userProfile;
    const { weeklyFocus } = req.body;

    if (!profile || !userContext) {
      return res.status(500).json({
        success: false,
        error: 'ServerError',
        message: 'User context was not synthesized correctly.',
      });
    }

    const systemPrompt = `
You are a highly skilled professional fitness coach and personal trainer. Your task is to generate a personalized weekly exercise calendar.
Generate a strictly structured JSON object adhering to the user's profile context.

Strict rules:
1. Match the exercise intensity, types of movements, and workout duration to the user's activity tier and health goals.
2. Carefully avoid any movements that would aggravate or conflict with the user's medical conditions.
3. Incorporate the user's optional weekly focus if provided: "${weeklyFocus || 'None'}".
4. Your output MUST be a valid JSON object matching this schema exactly:
{
  "weeklyGoal": "Overall summary of the focus of the weekly exercises",
  "timeline": [
    {
      "day": "Monday",
      "workoutType": "Aerobic / Strength / Flexibility / etc",
      "durationMinutes": <integer>,
      "exercises": [
        { "name": "Exercise name", "sets": <integer>, "reps": "number of reps or time duration, e.g., 12 reps or 45 seconds", "instructions": "Short tip or safety instruction" }
      ]
    }
  ]
}
5. Do not include any markdown tags (like \`\`\`json), comments, or extra conversational text.
`;

    try {
      const resultText = await AIService.generateText(userContext, {
        systemInstruction: systemPrompt,
        responseMimeType: 'application/json',
      });

      const jsonResult = JSON.parse(resultText);

      // Save plan to database
      const plan = await prisma.fitnessPlan.create({
        data: {
          userId: profile.id,
          weeklyGoal: jsonResult.weeklyGoal || weeklyFocus || 'Weekly Routine',
          scheduleTimelineJson: jsonResult.timeline || jsonResult,
        },
      });

      return res.status(201).json({
        success: true,
        message: 'Fitness plan generated successfully',
        data: plan,
      });
    } catch (error: any) {
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
  static async getFitnessPlans(req: ContextRequest, res: Response) {
    const { userId } = req.params;

    const plans = await prisma.fitnessPlan.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      success: true,
      data: plans,
    });
  }
}
