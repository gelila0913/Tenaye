import { Request, Response } from 'express';
import { MoodService } from './services';

export class MoodController {
  static async logMood(req: Request, res: Response) {
    const { userId, selectedMood, energyLevel, stressLevel, sleepHours, notes } = req.body;

    if (!userId || !selectedMood || energyLevel === undefined || stressLevel === undefined || sleepHours === undefined) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required parameters (userId, selectedMood, energyLevel, stressLevel, sleepHours).',
      });
    }

    const log = await MoodService.logMood({
      userId,
      selectedMood,
      energyLevel: Number(energyLevel),
      stressLevel: Number(stressLevel),
      sleepHours: Number(sleepHours),
      notes,
    });

    res.status(201).json({
      success: true,
      message: 'Mood logged successfully',
      data: log,
    });
  }

  static async getMoodLogs(req: Request, res: Response) {
    const { userId } = req.params;
    const logs = await MoodService.getMoodLogs(userId);

    res.status(200).json({
      success: true,
      data: logs,
    });
  }
}
