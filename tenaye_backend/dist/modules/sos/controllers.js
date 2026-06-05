"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SosController = void 0;
const services_1 = require("./services");
class SosController {
    static async addEmergencyContact(req, res) {
        const { userId, name, relationship, phoneNumber } = req.body;
        if (!userId || !name || !relationship || !phoneNumber) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required parameters (userId, name, relationship, phoneNumber).',
            });
        }
        const contact = await services_1.SosService.addEmergencyContact({
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
    static async getSosActiveSummary(req, res) {
        const { userId } = req.params;
        try {
            const summary = await services_1.SosService.getSosActiveSummary(userId);
            res.status(200).json({
                success: true,
                data: summary,
            });
        }
        catch (err) {
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
exports.SosController = SosController;
