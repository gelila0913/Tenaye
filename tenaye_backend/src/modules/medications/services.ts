import { prisma } from '../../config/database';

export class MedicationsService {
  static async addMedication(data: {
    userId: string;
    name: string;
    dosage: string;
    frequency: string;
    times: string[];
    startDate: Date;
    endDate: Date;
    notes?: string;
  }) {
    return prisma.medication.create({
      data,
    });
  }

  static async getMedications(userId: string) {
    return prisma.medication.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  static async clearMedications(userId: string) {
    return prisma.medication.deleteMany({
      where: { userId },
    });
  }
}
