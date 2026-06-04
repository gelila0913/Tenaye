import { Router } from 'express';
import { MoodController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/', asyncWrapper(MoodController.logMood));
router.get('/:userId', asyncWrapper(MoodController.getMoodLogs));

export default router;
