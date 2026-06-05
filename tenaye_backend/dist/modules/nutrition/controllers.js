"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.NutritionController = void 0;
const services_1 = require("./services");
class NutritionController {
    static async generateNutritionPlan(req, res) {
        const { userId, ingredients } = req.body;
        if (!userId || !ingredients || !Array.isArray(ingredients)) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required parameters (userId, ingredients as String Array).',
            });
        }
        try {
            const plan = await services_1.NutritionService.generateNutritionPlan(userId, ingredients);
            res.status(201).json({
                success: true,
                message: 'Meal plan generated successfully',
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
    static async getNutritionPlans(req, res) {
        const { userId } = req.params;
        const plans = await services_1.NutritionService.getNutritionPlans(userId);
        res.status(200).json({
            success: true,
            data: plans,
        });
    }
}
exports.NutritionController = NutritionController;
