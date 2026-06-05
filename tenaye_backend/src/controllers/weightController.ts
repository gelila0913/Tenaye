import { Request, Response } from 'express';
import { prisma } from '../config/database';
import fs from 'fs';

export class WeightController {
  /**
   * Log weight (POST /api/weight/log)
   */
  static async logWeight(req: Request, res: Response) {
    const { userId, weight } = req.body;

    // Validate inputs
    if (!userId) {
      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'userId is required.',
      });
    }

    if (weight === undefined || weight === null || weight === '') {
      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'weight is required.',
      });
    }

    const parsedWeight = parseFloat(String(weight));
    if (isNaN(parsedWeight)) {
      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'weight must be a valid number.',
      });
    }

    // Verify user profile exists
    const userExists = await prisma.userProfile.findUnique({
      where: { id: userId },
    });
    if (!userExists) {
      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      return res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `UserProfile with ID ${userId} was not found.`,
      });
    }

    // Capture file path if provided
    let photoUrl: string | undefined = undefined;
    if (req.file) {
      photoUrl = `uploads/progress_photos/${req.file.filename}`;
    }

    try {
      // Save weight log
      const log = await prisma.weightLog.create({
        data: {
          userId,
          weight: parsedWeight,
          photoUrl,
        },
      });

      return res.status(201).json({
        success: true,
        message: 'Weight logged successfully',
        data: log,
      });
    } catch (error) {
      // Clean up file if database insert fails
      if (req.file) {
        fs.unlink(req.file.path, () => {});
      }
      throw error;
    }
  }

  /**
   * Get weight history sorted by date (GET /api/weight/history/:userId)
   */
  static async getWeightHistory(req: Request, res: Response) {
    const { userId } = req.params;

    // Verify user exists first
    const userExists = await prisma.userProfile.findUnique({
      where: { id: userId },
    });
    if (!userExists) {
      return res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `UserProfile with ID ${userId} was not found.`,
      });
    }

    // Fetch history sorted by date ascending for charting
    const history = await prisma.weightLog.findMany({
      where: { userId },
      orderBy: {
        createdAt: 'asc',
      },
    });

    return res.status(200).json({
      success: true,
      data: history,
    });
  }
}
