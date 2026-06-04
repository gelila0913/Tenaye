import { prisma } from '../../config/database';

export class MoodService {
  static async logMood(data: {
    userId: string;
    selectedMood: string;
    energyLevel: number;
    stressLevel: number;
    sleepHours: number;
    notes?: string;
  }) {
    return prisma.moodLog.create({
      data,
    });
  }

  static async getMoodLogs(userId: string) {
    return prisma.moodLog.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }
}
