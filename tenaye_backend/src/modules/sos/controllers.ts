import { Request, Response } from 'express';
import { SosService } from './services';

export class SosController {
  static async addEmergencyContact(req: Request, res: Response) {
    const { userId, name, relationship, phoneNumber } = req.body;

    if (!userId || !name || !relationship || !phoneNumber) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required parameters (userId, name, relationship, phoneNumber).',
      });
    }

    const contact = await SosService.addEmergencyContact({
      userId,
      name,
      relationship,
      phoneNumber,
    });

    res.status(201).json({
      success: true,
      message: 'Emergency contact registered successfully',
      data: contact,
    });
  }

  static async getSosActiveSummary(req: Request, res: Response) {
    const { userId } = req.params;

    try {
      const summary = await SosService.getSosActiveSummary(userId);
      res.status(200).json({
        success: true,
        data: summary,
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
}
