"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WeightController = void 0;
const database_1 = require("../config/database");
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
class WeightController {
    /**
     * Log weight (POST /api/weight/log)
     */
    static async logWeight(req, res) {
        const { userId, weight } = req.body;
        // Validate inputs
        if (!userId) {
            if (req.file) {
                fs_1.default.unlink(req.file.path, () => { });
            }
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'userId is required.',
            });
        }
        if (weight === undefined || weight === null || weight === '') {
            if (req.file) {
                fs_1.default.unlink(req.file.path, () => { });
            }
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'weight is required.',
            });
        }
        const parsedWeight = parseFloat(String(weight));
        if (isNaN(parsedWeight)) {
            if (req.file) {
                fs_1.default.unlink(req.file.path, () => { });
            }
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'weight must be a valid number.',
            });
        }
        // Verify user profile exists
        const userExists = await database_1.prisma.userProfile.findUnique({
            where: { id: userId },
        });
        if (!userExists) {
            if (req.file) {
                fs_1.default.unlink(req.file.path, () => { });
            }
            return res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `UserProfile with ID ${userId} was not found.`,
            });
        }
        // Capture file path if provided
        let photoUrl = undefined;
        if (req.file) {
            photoUrl = `uploads/progress_photos/${req.file.filename}`;
        }
        try {
            // Save weight log
            const log = await database_1.prisma.weightLog.create({
                data: {
                    userId,
                    weight: parsedWeight,
                    photoUrl,
                },
            });
            return res.status(201).json({
                success: true,
                message: 'Weight logged successfully',
                data: log,
            });
        }
        catch (error) {
            // Clean up file if database insert fails
            if (req.file) {
                fs_1.default.unlink(req.file.path, () => { });
            }
            throw error;
        }
    }
    /**
     * Get weight history sorted by date (GET /api/weight/history/:userId)
     */
    static async getWeightHistory(req, res) {
        const { userId } = req.params;
        // Verify user exists first
        const userExists = await database_1.prisma.userProfile.findUnique({
            where: { id: userId },
        });
        if (!userExists) {
            return res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `UserProfile with ID ${userId} was not found.`,
            });
        }
        // Fetch history sorted by date ascending for charting
        const history = await database_1.prisma.weightLog.findMany({
            where: { userId },
            orderBy: {
                createdAt: 'asc',
            },
        });
        return res.status(200).json({
            success: true,
            data: history,
        });
    }
    /**
     * Update a weight log (PUT /api/weight/:id)
     */
    static async updateWeight(req, res) {
        const { id } = req.params;
        const { weight } = req.body;
        if (weight === undefined || weight === null || weight === '') {
            res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'weight is required.',
            });
            return;
        }
        const parsedWeight = parseFloat(String(weight));
        if (isNaN(parsedWeight)) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'weight must be a valid number.',
            });
        }
        const log = await database_1.prisma.weightLog.findUnique({
            where: { id },
        });
        if (!log) {
            res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `WeightLog with ID ${id} was not found.`,
            });
            return;
        }
        const updated = await database_1.prisma.weightLog.update({
            where: { id },
            data: {
                weight: parsedWeight,
            },
        });
        res.status(200).json({
            success: true,
            message: 'Weight log updated successfully',
            data: updated,
        });
    }
    /**
     * Delete a weight log (DELETE /api/weight/:id)
     */
    static async deleteWeight(req, res) {
        const { id } = req.params;
        const log = await database_1.prisma.weightLog.findUnique({
            where: { id },
        });
        if (!log) {
            res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `WeightLog with ID ${id} was not found.`,
            });
            return;
        }
        // Delete photo if exists
        if (log.photoUrl) {
            const fullPath = path_1.default.join(process.cwd(), log.photoUrl);
            fs_1.default.unlink(fullPath, () => { });
        }
        await database_1.prisma.weightLog.delete({
            where: { id },
        });
        res.status(200).json({
            success: true,
            message: 'Weight log deleted successfully',
        });
    }
}
exports.WeightController = WeightController;
