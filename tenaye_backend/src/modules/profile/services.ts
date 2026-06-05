import { prisma } from '../../config/database';

export class ProfileService {
  static async createProfile(data: {
    email: string;
    name?: string;
    age: number;
    gender: string;
    height: number;
    weight: number;
    bloodType: string;
    activityLevel: string;
    budgetRange: string;
    medicalConditions?: string[];
    healthGoals?: string[];
    allergies?: string[];
    availableFoods?: string[];
  }) {
    return prisma.userProfile.create({
      data: {
        ...data,
        medicalConditions: data.medicalConditions || [],
        healthGoals: data.healthGoals || [],
        allergies: data.allergies || [],
        availableFoods: data.availableFoods || [],
      },
    });
  }

  static async getProfile(id: string) {
    return prisma.userProfile.findUnique({
      where: { id },
    });
  }

  static async updateProfile(
    id: string,
    data: {
      email?: string;
      name?: string;
      age?: number;
      gender?: string;
      height?: number;
      weight?: number;
      bloodType?: string;
      activityLevel?: string;
      budgetRange?: string;
      medicalConditions?: string[];
      healthGoals?: string[];
      allergies?: string[];
      availableFoods?: string[];
    }
  ) {
    return prisma.userProfile.update({
      where: { id },
      data,
    });
  }
}
