import { Router } from 'express';
import { NutritionController } from '../controllers/nutritionController';
import { contextSynthesizer } from '../middleware/context';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/nutrition/generate
router.post('/generate', contextSynthesizer, asyncWrapper(NutritionController.generateNutritionPlan));

// GET /api/nutrition/:userId
router.get('/:userId', asyncWrapper(NutritionController.getNutritionPlans));

export default router;
