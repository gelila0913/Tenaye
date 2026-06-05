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
  res: Response,
  next: NextFunction
) => {
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

    const profile = await prisma.userProfile.findUnique({
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
    req.userProfile = profile as any;

    next();
  } catch (error) {
    next(error);
  }
};
