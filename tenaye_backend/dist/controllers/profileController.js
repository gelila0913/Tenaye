"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProfileController = void 0;
const database_1 = require("../config/database");
// Helper to safely parse JSON strings or return the value directly if it is already parsed
function safeParseJson(value) {
    if (typeof value === 'string') {
        try {
            return JSON.parse(value);
        }
        catch (e) {
            // Return wrapped in array or default if string parsing fails
            return [value];
        }
    }
    return value || [];
}
class ProfileController {
    /**
     * Upsert (create or update) user profile
     */
    static async upsertUserProfile(req, res) {
        const { id, email, age, gender, height, weight, bloodType, activityLevel, budgetRange, medicalConditions, healthGoals, allergies, availableFoods, } = req.body;
        if (!email) {
            return res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'Email is required to upsert a user profile.',
            });
        }
        // Safely parse numeric fields
        const parsedAge = age !== undefined ? parseInt(String(age), 10) : undefined;
        const parsedHeight = height !== undefined ? parseFloat(String(height)) : undefined;
        const parsedWeight = weight !== undefined ? parseFloat(String(weight)) : undefined;
        // Safely parse JSON/arrays
        const parsedMedicalConditions = medicalConditions !== undefined ? safeParseJson(medicalConditions) : undefined;
        const parsedHealthGoals = healthGoals !== undefined ? safeParseJson(healthGoals) : undefined;
        const parsedAllergies = allergies !== undefined ? safeParseJson(allergies) : undefined;
        const parsedAvailableFoods = availableFoods !== undefined ? safeParseJson(availableFoods) : undefined;
        // Check if user already exists by ID or email
        let profile = null;
        if (id) {
            profile = await database_1.prisma.userProfile.findUnique({ where: { id } });
        }
        if (!profile && email) {
            profile = await database_1.prisma.userProfile.findUnique({ where: { email } });
        }
        const updateData = {};
        if (email !== undefined)
            updateData.email = email;
        if (parsedAge !== undefined && !isNaN(parsedAge))
            updateData.age = parsedAge;
        if (gender !== undefined)
            updateData.gender = gender;
        if (parsedHeight !== undefined && !isNaN(parsedHeight))
            updateData.height = parsedHeight;
        if (parsedWeight !== undefined && !isNaN(parsedWeight))
            updateData.weight = parsedWeight;
        if (bloodType !== undefined)
            updateData.bloodType = bloodType;
        if (activityLevel !== undefined)
            updateData.activityLevel = activityLevel;
        if (budgetRange !== undefined)
            updateData.budgetRange = budgetRange;
        if (parsedMedicalConditions !== undefined)
            updateData.medicalConditions = parsedMedicalConditions;
        if (parsedHealthGoals !== undefined)
            updateData.healthGoals = parsedHealthGoals;
        if (parsedAllergies !== undefined)
            updateData.allergies = parsedAllergies;
        if (parsedAvailableFoods !== undefined)
            updateData.availableFoods = parsedAvailableFoods;
        if (profile) {
            // Update existing profile
            const updated = await database_1.prisma.userProfile.update({
                where: { id: profile.id },
                data: updateData,
            });
            return res.status(200).json({
                success: true,
                message: 'Profile updated successfully',
                data: updated,
            });
        }
        else {
            // Check required fields for creation
            if (parsedAge === undefined || isNaN(parsedAge) ||
                gender === undefined ||
                parsedHeight === undefined || isNaN(parsedHeight) ||
                parsedWeight === undefined || isNaN(parsedWeight) ||
                bloodType === undefined ||
                activityLevel === undefined ||
                budgetRange === undefined) {
                return res.status(400).json({
                    success: false,
                    error: 'ValidationError',
                    message: 'Missing required profile fields for creation (email, age, gender, height, weight, bloodType, activityLevel, budgetRange).',
                });
            }
            const created = await database_1.prisma.userProfile.create({
                data: {
                    id: id || undefined,
                    email,
                    age: parsedAge,
                    gender,
                    height: parsedHeight,
                    weight: parsedWeight,
                    bloodType,
                    activityLevel,
                    budgetRange,
                    medicalConditions: parsedMedicalConditions || [],
                    healthGoals: parsedHealthGoals || [],
                    allergies: parsedAllergies || [],
                    availableFoods: parsedAvailableFoods || [],
                },
            });
            return res.status(201).json({
                success: true,
                message: 'Profile created successfully',
                data: created,
            });
        }
    }
    /**
     * Get user profile by ID
     */
    static async getUserProfile(req, res) {
        const { id } = req.params;
        const profile = await database_1.prisma.userProfile.findUnique({
            where: { id },
        });
        if (!profile) {
            return res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `UserProfile with ID ${id} was not found.`,
            });
        }
        return res.status(200).json({
            success: true,
            data: profile,
        });
    }
}
exports.ProfileController = ProfileController;
