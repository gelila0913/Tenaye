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
const contextSynthesizer = async (req, _res, next) => {
    try {
        const userId = req.body.userId || req.query.userId || req.params.userId;
        if (!userId) {
            req.userContext = undefined;
            req.userProfile = undefined;
            next();
            return;
        }
        const profile = await database_1.prisma.userProfile.findUnique({
            where: { id: String(userId) },
        });
        if (!profile) {
            req.userContext = undefined;
            req.userProfile = undefined;
            next();
            return;
        }
        // Synthesize profile fields
        const medicalConditions = formatList(profile.medicalConditions);
        const healthGoals = formatList(profile.healthGoals);
        const allergies = formatList(profile.allergies);
        const availableFoods = formatList(profile.availableFoods);
        const now = new Date();
        // Fetch dynamic user health data concurrently
        const [activeMedications, recentMoodLogs, latestMetrics, latestWeightLog] = await Promise.all([
            database_1.prisma.medication.findMany({
                where: {
                    userId: profile.id,
                    startDate: { lte: now },
                    endDate: { gte: now },
                },
                orderBy: { createdAt: 'desc' },
            }),
            database_1.prisma.moodLog.findMany({
                where: { userId: profile.id },
                orderBy: { createdAt: 'desc' },
                take: 5,
            }),
            database_1.prisma.healthMeasurement.findMany({
                where: { userId: profile.id },
                orderBy: { createdAt: 'desc' },
                take: 10,
            }),
            database_1.prisma.weightLog.findFirst({
                where: { userId: profile.id },
                orderBy: { createdAt: 'desc' },
            }),
        ]);
        // Stringify Medications
        let medicationsSummary = 'Active Medications:\n';
        if (activeMedications.length === 0) {
            medicationsSummary += '- The user has not provided active medication information yet.\n';
        }
        else {
            activeMedications.forEach((med) => {
                medicationsSummary += `- ${med.name}: Dosage ${med.dosage}, Frequency: ${med.frequency}${med.notes ? ` (Notes: ${med.notes})` : ''}\n`;
            });
        }
        // Stringify Mood Logs
        let moodSummary = 'Recent Mood Logs:\n';
        if (recentMoodLogs.length === 0) {
            moodSummary += '- The user has not provided mood log information yet.\n';
        }
        else {
            recentMoodLogs.forEach((log) => {
                const formattedDate = new Date(log.createdAt).toLocaleDateString();
                moodSummary += `- Date: ${formattedDate}, Mood: ${log.selectedMood}, Energy: ${log.energyLevel}/10, Stress: ${log.stressLevel}/10, Sleep: ${log.sleepHours} hrs${log.notes ? ` (Notes: ${log.notes})` : ''}\n`;
            });
        }
        // Stringify Health Metrics
        let metricsSummary = 'Latest Health Metrics & Measurements:\n';
        let hasMetrics = false;
        if (latestWeightLog) {
            metricsSummary += `- Weight: ${latestWeightLog.weight} kg (Logged: ${new Date(latestWeightLog.createdAt).toLocaleDateString()})\n`;
            hasMetrics = true;
        }
        if (latestMetrics.length > 0) {
            latestMetrics.forEach((m) => {
                metricsSummary += `- Type: ${m.type}, Value: ${m.value}${m.notes ? ` (Notes: ${m.notes})` : ''} (Logged: ${new Date(m.createdAt).toLocaleDateString()})\n`;
            });
            hasMetrics = true;
        }
        if (!hasMetrics) {
            metricsSummary += '- The user has not recorded any vital health metrics or weight logs yet.\n';
        }
        const patientContext = `
Patient Context:
- Profile: Age ${profile.age}, Gender ${profile.gender}, Height ${profile.height} cm, Weight ${profile.weight} kg, Activity Level ${profile.activityLevel}, Medical Conditions: ${medicalConditions}, Health Goals: ${healthGoals}, Allergies: ${allergies}
- Available Foods: ${availableFoods}
- Medications: ${medicationsSummary.trim()}
- Moods: ${moodSummary.trim()}
- Metrics: ${metricsSummary.trim()}
    `.trim();
        // Attach to request
        req.userContext = patientContext;
        req.userProfile = profile;
        next();
    }
    catch (error) {
        next(error);
    }
};
exports.contextSynthesizer = contextSynthesizer;
