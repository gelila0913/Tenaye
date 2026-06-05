"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.SosService = void 0;
const database_1 = require("../../config/database");
class SosService {
    static async addEmergencyContact(data) {
        return database_1.prisma.emergencyContact.create({
            data,
        });
    }
    static async getSosActiveSummary(userId) {
        const profile = await database_1.prisma.userProfile.findUnique({
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
exports.SosService = SosService;
