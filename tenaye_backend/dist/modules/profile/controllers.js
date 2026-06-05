"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProfileController = void 0;
const services_1 = require("./services");
class ProfileController {
    static async createProfile(req, res) {
        const profile = await services_1.ProfileService.createProfile(req.body);
        res.status(201).json({
            success: true,
            message: 'Profile created successfully',
            data: profile,
        });
    }
    static async getProfile(req, res) {
        const { userId } = req.params;
        const profile = await services_1.ProfileService.getProfile(userId);
        if (!profile) {
            return res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `UserProfile with ID ${userId} was not found.`,
            });
        }
        res.status(200).json({
            success: true,
            data: profile,
        });
    }
    static async updateProfile(req, res) {
        const { userId } = req.params;
        const profile = await services_1.ProfileService.updateProfile(userId, req.body);
        res.status(200).json({
            success: true,
            message: 'Profile updated successfully',
            data: profile,
        });
    }
}
exports.ProfileController = ProfileController;
