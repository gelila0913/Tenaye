"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProfileService = void 0;
const database_1 = require("../../config/database");
class ProfileService {
    static async createProfile(data) {
        return database_1.prisma.userProfile.create({
            data: {
                ...data,
                medicalConditions: data.medicalConditions || [],
                healthGoals: data.healthGoals || [],
                allergies: data.allergies || [],
                availableFoods: data.availableFoods || [],
            },
        });
    }
    static async getProfile(id) {
        return database_1.prisma.userProfile.findUnique({
            where: { id },
        });
    }
    static async updateProfile(id, data) {
        return database_1.prisma.userProfile.update({
            where: { id },
            data,
        });
    }
}
exports.ProfileService = ProfileService;
