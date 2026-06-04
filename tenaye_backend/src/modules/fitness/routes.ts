import { Router } from 'express';
import { FitnessController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/generate', asyncWrapper(FitnessController.generateFitnessPlan));
router.get('/:userId', asyncWrapper(FitnessController.getFitnessPlans));

export default router;
