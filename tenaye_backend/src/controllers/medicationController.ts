import { Request, Response } from 'express';
import { prisma } from '../config/database';

// Helper to safely parse JSON strings or return the value directly if it is already parsed
function safeParseJson(value: any): any {
  if (typeof value === 'string') {
    try {
      return JSON.parse(value);
    } catch (e) {
      return [value];
    }
  }
  return value || [];
}

export class MedicationController {
  /**
   * Add a new medication prescription (POST /api/medications)
   */
  static async addMedication(req: Request, res: Response) {
    const { userId, name, dosage, frequency, times, startDate, endDate, notes } = req.body;

    // Validate inputs
    if (!userId || !name || !dosage || !frequency || !times || !startDate || !endDate) {
      res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required fields (userId, name, dosage, frequency, times, startDate, endDate).',
      });
      return;
    }

    // Verify user exists
    const userExists = await prisma.userProfile.findUnique({
      where: { id: userId },
    });
    if (!userExists) {
      res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `UserProfile with ID ${userId} was not found.`,
      });
      return;
    }

    // Parse dates
    const parsedStartDate = new Date(startDate);
    const parsedEndDate = new Date(endDate);

    if (isNaN(parsedStartDate.getTime()) || isNaN(parsedEndDate.getTime())) {
      res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'startDate and endDate must be valid date formats.',
      });
      return;
    }

    // Parse times
    const parsedTimes = safeParseJson(times);

    // Save medication
    const medication = await prisma.medication.create({
      data: {
        userId,
        name,
        dosage,
        frequency,
        times: parsedTimes,
        startDate: parsedStartDate,
        endDate: parsedEndDate,
        notes: notes || null,
      },
    });

    res.status(201).json({
      success: true,
      message: 'Medication added successfully',
      data: medication,
    });
  }

  /**
   * Get active medications for daily checklist (GET /api/medications/active/:userId)
   */
  static async getActiveMedications(req: Request, res: Response) {
    const { userId } = req.params;

    // Verify user exists
    const userExists = await prisma.userProfile.findUnique({
      where: { id: userId },
    });
    if (!userExists) {
      res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `UserProfile with ID ${userId} was not found.`,
      });
      return;
    }

    const now = new Date();

    const activeMedications = await prisma.medication.findMany({
      where: {
        userId,
        startDate: { lte: now },
        endDate: { gte: now },
      },
      orderBy: {
        createdAt: 'desc',
      },
    });

    res.status(200).json({
      success: true,
      data: activeMedications,
    });
  }
}
