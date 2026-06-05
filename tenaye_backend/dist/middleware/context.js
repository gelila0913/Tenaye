"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.contextSynthesizer = void 0;
const database_1 = require("../config/database");
// Helper to safely format arrays or strings representing arrays
function formatList(field) {
    if (Array.isArray(field)) {
        return field.length > 0 ? field.join(', ') : 'None';
    }
    if (typeof field === 'string') {
        try {
            const parsed = JSON.parse(field);
            if (Array.isArray(parsed)) {
                return parsed.length > 0 ? parsed.join(', ') : 'None';
            }
            return field || 'None';
        }
        catch {
            return field || 'None';
        }
    }
    return 'None';
}
const contextSynthesizer = async (req, res, next) => {
    try {
        const userId = req.body.userId || req.query.userId || req.params.userId;
        if (!userId) {
            res.status(400).json({
                success: false,
                error: 'ValidationError',
                message: 'userId is required to synthesize user context.',
            });
            return;
        }
        const profile = await database_1.prisma.userProfile.findUnique({
            where: { id: String(userId) },
        });
        if (!profile) {
            res.status(404).json({
                success: false,
                error: 'NotFoundError',
                message: `UserProfile with ID ${userId} was not found.`,
            });
            return;
        }
        // Synthesize profile fields into a distinct, clean context string
        const medicalConditions = formatList(profile.medicalConditions);
        const healthGoals = formatList(profile.healthGoals);
        const allergies = formatList(profile.allergies);
        const availableFoods = formatList(profile.availableFoods);
        const contextString = `
User Profile Context:
- Age: ${profile.age}
- Gender: ${profile.gender}
- Height: ${profile.height} cm
- Weight: ${profile.weight} kg
- Blood Type: ${profile.bloodType}
- Activity Level: ${profile.activityLevel}
- Budget Range: ${profile.budgetRange}
- Medical Conditions: ${medicalConditions}
- Health Goals: ${healthGoals}
- Allergies to avoid: ${allergies}
- Available Foods to utilize: ${availableFoods}
    `.trim();
        // Attach to request
        req.userContext = contextString;
        req.userProfile = profile;
        next();
    }
    catch (error) {
        next(error);
    }
};
exports.contextSynthesizer = contextSynthesizer;
