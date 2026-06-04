import { Request, Response } from 'express';
import { ProfileService } from './services';

export class ProfileController {
  static async createProfile(req: Request, res: Response) {
    const profile = await ProfileService.createProfile(req.body);
    res.status(201).json({
      success: true,
      message: 'Profile created successfully',
      data: profile,
    });
  }

  static async getProfile(req: Request, res: Response) {
    const { userId } = req.params;
    const profile = await ProfileService.getProfile(userId);
    
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

  static async updateProfile(req: Request, res: Response) {
    const { userId } = req.params;
    const profile = await ProfileService.updateProfile(userId, req.body);
    
    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: profile,
    });
  }
}
