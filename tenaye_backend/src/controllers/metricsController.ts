import { Request, Response } from 'express';
import { prisma } from '../config/database';

export class MetricsController {
  /**
   * Log a new health measurement (POST /api/metrics/log)
   */
  static async logMetric(req: Request, res: Response) {
    const { userId, type, value, notes } = req.body;

    // Validate inputs
    if (!userId || !type || value === undefined || value === null || value === '') {
      res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Missing required fields (userId, type, value).',
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

    // Create measurement
    const measurement = await prisma.healthMeasurement.create({
      data: {
        userId,
        type: String(type),
        value: String(value),
        notes: notes || null,
      },
    });

    res.status(201).json({
      success: true,
      message: 'Metric logged successfully',
      data: measurement,
    });
  }

  /**
   * Get health measurement history grouped by type (GET /api/metrics/history/:userId)
   */
  static async getMetricsHistory(req: Request, res: Response) {
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

    // Fetch metrics sorted chronologically descending (latest first)
    const measurements = await prisma.healthMeasurement.findMany({
      where: { userId },
      orderBy: {
        createdAt: 'desc',
      },
    });

    // Programmatically group measurements by type
    const grouped = measurements.reduce((acc: Record<string, typeof measurements>, item) => {
      const typeKey = item.type;
      if (!acc[typeKey]) {
        acc[typeKey] = [];
      }
      acc[typeKey].push(item);
      return acc;
    }, {});

    res.status(200).json({
      success: true,
      data: grouped,
    });
  }

  /**
   * Update a health measurement (PUT /api/metrics/:id)
   */
  static async updateMetric(req: Request, res: Response) {
    const { id } = req.params;
    const { value, notes } = req.body;

    if (value === undefined || value === null || value === '') {
      res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'Value is required.',
      });
      return;
    }

    const measurement = await prisma.healthMeasurement.findUnique({
      where: { id },
    });

    if (!measurement) {
      res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `HealthMeasurement with ID ${id} was not found.`,
      });
      return;
    }

    const updated = await prisma.healthMeasurement.update({
      where: { id },
      data: {
        value: String(value),
        notes: notes !== undefined ? notes : null,
      },
    });

    res.status(200).json({
      success: true,
      message: 'Metric updated successfully',
      data: updated,
    });
  }

  /**
   * Delete a health measurement (DELETE /api/metrics/:id)
   */
  static async deleteMetric(req: Request, res: Response) {
    const { id } = req.params;

    const measurement = await prisma.healthMeasurement.findUnique({
      where: { id },
    });

    if (!measurement) {
      res.status(404).json({
        success: false,
        error: 'NotFoundError',
        message: `HealthMeasurement with ID ${id} was not found.`,
      });
      return;
    }

    await prisma.healthMeasurement.delete({
      where: { id },
    });

    res.status(200).json({
      success: true,
      message: 'Metric deleted successfully',
    });
  }
}
