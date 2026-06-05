import { Router } from 'express';
import { MoodController } from '../controllers/moodController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/mood/log
router.post('/log', asyncWrapper(MoodController.logMood));

// GET /api/mood/history/:userId
router.get('/history/:userId', asyncWrapper(MoodController.getMoodHistory));

export default router;
