"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MoodController = void 0;
const services_1 = require("./services");
class MoodController {
    static async logMood(req, res) {
        const { userId, selectedMood, energyLevel, stressLevel, sleepHours, notes } = req.body;
        if (!userId || !selectedMood || energyLevel === undefined || stressLevel === undefined || sleepHours === undefined) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required parameters (userId, selectedMood, energyLevel, stressLevel, sleepHours).',
            });
        }
        const log = await services_1.MoodService.logMood({
            userId,
            selectedMood,
            energyLevel: Number(energyLevel),
            stressLevel: Number(stressLevel),
            sleepHours: Number(sleepHours),
            notes,
        });
        res.status(201).json({
            success: true,
            message: 'Mood logged successfully',
            data: log,
        });
    }
    static async getMoodLogs(req, res) {
        const { userId } = req.params;
        const logs = await services_1.MoodService.getMoodLogs(userId);
        res.status(200).json({
            success: true,
            data: logs,
        });
    }
}
exports.MoodController = MoodController;
