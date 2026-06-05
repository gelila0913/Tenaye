"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MoodController = void 0;
const database_1 = require("../config/database");
class MoodController {
    /**
     * Log a new mood check-in (POST /api/mood/log)
     */
    static async logMood(req, res) {
        const { userId, selectedMood, energyLevel, stressLevel, sleepHours, notes } = req.body;
        // Validate inputs
        if (!userId || selectedMood === undefined || energyLevel === undefined || stressLevel === undefined || sleepHours === undefined) {
            res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Missing required fields (userId, selectedMood, energyLevel, stressLevel, sleepHours).',
            });
            return;
        }
        // Verify user exists
        const userExists = await database_1.prisma.userProfile.findUnique({
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
        // Parse levels
        const parsedEnergy = parseInt(String(energyLevel), 10);
        const parsedStress = parseInt(String(stressLevel), 10);
        const parsedSleepHours = parseFloat(String(sleepHours));
        if (isNaN(parsedEnergy) || isNaN(parsedStress) || isNaN(parsedSleepHours)) {
            res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'energyLevel, stressLevel, and sleepHours must be numeric.',
            });
            return;
        }
        // Validate ranges (1-5)
        if (parsedEnergy < 1 || parsedEnergy > 5 || parsedStress < 1 || parsedStress > 5) {
            res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'energyLevel and stressLevel must be integers between 1 and 5.',
            });
            return;
        }
        // Create log
        const log = await database_1.prisma.moodLog.create({
            data: {
                userId,
                selectedMood: String(selectedMood),
                energyLevel: parsedEnergy,
                stressLevel: parsedStress,
                sleepHours: Math.floor(parsedSleepHours), // sleepHours is Int in schema
                notes: notes || null,
            },
        });
        res.status(201).json({
            success: true,
            message: 'Mood logged successfully',
            data: log,
        });
    }
    /**
     * Get mood history (GET /api/mood/history/:userId)
     */
    static async getMoodHistory(req, res) {
        const { userId } = req.params;
        // Verify user exists
        const userExists = await database_1.prisma.userProfile.findUnique({
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
        const logs = await database_1.prisma.moodLog.findMany({
            where: { userId },
            orderBy: {
                createdAt: 'desc',
            },
        });
        res.status(200).json({
            success: true,
            data: logs,
        });
    }
}
exports.MoodController = MoodController;
