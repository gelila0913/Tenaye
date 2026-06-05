"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MedicationsController = void 0;
const services_1 = require("./services");
class MedicationsController {
    static async addMedication(req, res) {
        const { userId, name, dosage, frequency, times, startDate, endDate, notes } = req.body;
        if (!userId || !name || !dosage || !frequency || !times || !startDate || !endDate) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required parameters (userId, name, dosage, frequency, times, startDate, endDate).',
            });
        }
        const med = await services_1.MedicationsService.addMedication({
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
    static async getMedications(req, res) {
        const { userId } = req.params;
        const medications = await services_1.MedicationsService.getMedications(userId);
        res.status(200).json({
            success: true,
            data: medications,
        });
    }
    static async clearMedications(req, res) {
        const { userId } = req.params;
        const result = await services_1.MedicationsService.clearMedications(userId);
        res.status(200).json({
            success: true,
            message: `Cleared all active medications for user ${userId}`,
            count: result.count,
        });
    }
}
exports.MedicationsController = MedicationsController;
