import { Router } from 'express';
import { ProfileController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/', asyncWrapper(ProfileController.createProfile));
router.get('/:userId', asyncWrapper(ProfileController.getProfile));
router.put('/:userId', asyncWrapper(ProfileController.updateProfile));

export default router;
