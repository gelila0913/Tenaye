import { Router } from 'express';
import { ProfileController } from '../controllers/profileController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/profile
router.post('/', asyncWrapper(ProfileController.upsertUserProfile));

// GET /api/profile/:id
router.get('/:id', asyncWrapper(ProfileController.getUserProfile));

export default router;
