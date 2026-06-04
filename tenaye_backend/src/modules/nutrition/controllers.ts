import { Request, Response } from 'express';
import { NutritionService } from './services';

export class NutritionController {
  static async generateNutritionPlan(req: Request, res: Response) {
    const { userId, ingredients } = req.body;

    if (!userId || !ingredients || !Array.isArray(ingredients)) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required parameters (userId, ingredients as String Array).',
      });
    }

    try {
      const plan = await NutritionService.generateNutritionPlan(userId, ingredients);
      res.status(201).json({
        success: true,
        message: 'Meal plan generated successfully',
        data: plan,
      });
    } catch (err: any) {
      if (err.message.includes('Profile not found')) {
        return res.status(404).json({
          success: false,
          error: 'NotFoundError',
          message: err.message,
        });
      }
      throw err; // Propagate down to global error handler
    }
  }

  static async getNutritionPlans(req: Request, res: Response) {
    const { userId } = req.params;
    const plans = await NutritionService.getNutritionPlans(userId);

    res.status(200).json({
      success: true,
      data: plans,
    });
  }
}
