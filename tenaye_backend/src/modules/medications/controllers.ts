import { Request, Response } from 'express';
import { MedicationsService } from './services';

export class MedicationsController {
  static async addMedication(req: Request, res: Response) {
    const { userId, name, dosage, frequency, times, startDate, endDate, notes } = req.body;

    if (!userId || !name || !dosage || !frequency || !times || !startDate || !endDate) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required parameters (userId, name, dosage, frequency, times, startDate, endDate).',
      });
    }

    const med = await MedicationsService.addMedication({
      userId,
      name,
      dosage,
      frequency,
      times,
      startDate: new Date(startDate),
      endDate: new Date(endDate),
      notes,
    });

    res.status(201).json({
      success: true,
      message: 'Medication added successfully',
      data: med,
    });
  }

  static async getMedications(req: Request, res: Response) {
    const { userId } = req.params;
    const medications = await MedicationsService.getMedications(userId);

    res.status(200).json({
      success: true,
      data: medications,
    });
  }

  static async clearMedications(req: Request, res: Response) {
    const { userId } = req.params;
    const result = await MedicationsService.clearMedications(userId);

    res.status(200).json({
      success: true,
      message: `Cleared all active medications for user ${userId}`,
      count: result.count,
    });
  }
}
