import { Router } from 'express';
import { NutritionController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/generate', asyncWrapper(NutritionController.generateNutritionPlan));
router.get('/:userId', asyncWrapper(NutritionController.getNutritionPlans));

export default router;
