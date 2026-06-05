"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MedicationsService = void 0;
const database_1 = require("../../config/database");
class MedicationsService {
    static async addMedication(data) {
        return database_1.prisma.medication.create({
            data,
        });
    }
    static async getMedications(userId) {
        return database_1.prisma.medication.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
    static async clearMedications(userId) {
        return database_1.prisma.medication.deleteMany({
            where: { userId },
        });
    }
}
exports.MedicationsService = MedicationsService;
