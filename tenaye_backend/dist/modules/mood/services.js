"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.MoodService = void 0;
const database_1 = require("../../config/database");
class MoodService {
    static async logMood(data) {
        return database_1.prisma.moodLog.create({
            data,
        });
    }
    static async getMoodLogs(userId) {
        return database_1.prisma.moodLog.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
}
exports.MoodService = MoodService;
