import { Request, Response } from 'express';
import { FitnessService } from './services';

export class FitnessController {
  static async generateFitnessPlan(req: Request, res: Response) {
    const { userId, weeklyGoal } = req.body;

    if (!userId || !weeklyGoal) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required parameters (userId, weeklyGoal).',
      });
    }

    try {
      const plan = await FitnessService.generateFitnessPlan(userId, weeklyGoal);
      res.status(201).json({
        success: true,
        message: 'Fitness workout schedule generated successfully',
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

  static async getFitnessPlans(req: Request, res: Response) {
    const { userId } = req.params;
    const plans = await FitnessService.getFitnessPlans(userId);

    res.status(200).json({
      success: true,
      data: plans,
    });
  }
}
