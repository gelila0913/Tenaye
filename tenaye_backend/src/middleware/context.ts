import { Request, Response, NextFunction } from 'express';
import { prisma } from '../config/database';

export interface ContextRequest extends Request {
  userContext?: string;
  userProfile?: {
    id: string;
    email: string;
    age: number;
    gender: string;
    height: number;
    weight: number;
    bloodType: string;
    activityLevel: string;
    budgetRange: string;
    medicalConditions: any;
    healthGoals: any;
    allergies: any;
    availableFoods: any;
  };
}

// Helper to safely format arrays or strings representing arrays
function formatList(field: any): string {
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
    } catch {
      return field || 'None';
    }
  }
  return 'None';
}

export const contextSynthesizer = async (
  req: ContextRequest,
  _res: Response,
  next: NextFunction
) => {
  try {
    const userId = req.body.userId || req.query.userId || req.params.userId;

    if (!userId) {
      req.userContext = undefined;
      req.userProfile = undefined;
      next();
      return;
    }

    const profile = await prisma.userProfile.findUnique({
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
      prisma.medication.findMany({
        where: {
          userId: profile.id,
          startDate: { lte: now },
          endDate: { gte: now },
        },
        orderBy: { createdAt: 'desc' },
      }),
      prisma.moodLog.findMany({
        where: { userId: profile.id },
        orderBy: { createdAt: 'desc' },
        take: 5,
      }),
      prisma.healthMeasurement.findMany({
        where: { userId: profile.id },
        orderBy: { createdAt: 'desc' },
        take: 10,
      }),
      prisma.weightLog.findFirst({
        where: { userId: profile.id },
        orderBy: { createdAt: 'desc' },
      }),
    ]);

    // Stringify Medications
    let medicationsSummary = 'Active Medications:\n';
    if (activeMedications.length === 0) {
      medicationsSummary += '- The user has not provided active medication information yet.\n';
    } else {
      activeMedications.forEach((med) => {
        medicationsSummary += `- ${med.name}: Dosage ${med.dosage}, Frequency: ${med.frequency}${med.notes ? ` (Notes: ${med.notes})` : ''}\n`;
      });
    }

    // Stringify Mood Logs
    let moodSummary = 'Recent Mood Logs:\n';
    if (recentMoodLogs.length === 0) {
      moodSummary += '- The user has not provided mood log information yet.\n';
    } else {
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
    req.userProfile = profile as any;

    next();
  } catch (error) {
    next(error);
  }
};
