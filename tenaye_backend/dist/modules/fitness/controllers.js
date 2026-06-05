"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.FitnessController = void 0;
const services_1 = require("./services");
class FitnessController {
    static async generateFitnessPlan(req, res) {
        const { userId, weeklyGoal } = req.body;
        if (!userId || !weeklyGoal) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required parameters (userId, weeklyGoal).',
            });
        }
        try {
            const plan = await services_1.FitnessService.generateFitnessPlan(userId, weeklyGoal);
            res.status(201).json({
                success: true,
                message: 'Fitness workout schedule generated successfully',
                data: plan,
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
    static async getFitnessPlans(req, res) {
        const { userId } = req.params;
        const plans = await services_1.FitnessService.getFitnessPlans(userId);
        res.status(200).json({
            success: true,
            data: plans,
        });
    }
}
exports.FitnessController = FitnessController;
