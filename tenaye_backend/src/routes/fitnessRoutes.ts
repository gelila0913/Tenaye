import { Router } from 'express';
import { FitnessController } from '../controllers/fitnessController';
import { contextSynthesizer } from '../middleware/context';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/fitness/generate
router.post('/generate', contextSynthesizer, asyncWrapper(FitnessController.generateFitnessPlan));

// GET /api/fitness/:userId
router.get('/:userId', asyncWrapper(FitnessController.getFitnessPlans));

export default router;
