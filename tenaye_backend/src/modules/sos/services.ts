import { prisma } from '../../config/database';

export class SosService {
  static async addEmergencyContact(data: {
    userId: string;
    name: string;
    relationship: string;
    phoneNumber: string;
  }) {
    return prisma.emergencyContact.create({
      data,
    });
  }

  static async getSosActiveSummary(userId: string) {
    const profile = await prisma.userProfile.findUnique({
      where: { id: userId },
      include: {
        emergencyContacts: true,
      },
    });

    if (!profile) {
      throw new Error(`Profile not found for userId: ${userId}`);
    }

    // Return compiled structured Emergency Medical Summary format
    return {
      userId: profile.id,
      email: profile.email,
      medicalSummary: {
        age: profile.age,
        gender: profile.gender,
        bloodType: profile.bloodType,
        allergies: profile.allergies,
        medicalConditions: profile.medicalConditions,
        mockLocationCoordinates: {
          latitude: 8.7524,
          longitude: 38.9682,
          timestamp: new Date().toISOString(),
        },
      },
      emergencyContacts: profile.emergencyContacts.map(contact => ({
        id: contact.id,
        name: contact.name,
        relationship: contact.relationship,
        phoneNumber: contact.phoneNumber,
      })),
    };
  }
}
