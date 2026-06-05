import { Router } from 'express';
import { WeightController } from '../controllers/weightController';
import { upload } from '../middleware/upload';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/weight/log - accepts optional progress photo with field key 'photo'
router.post('/log', upload.single('photo'), asyncWrapper(WeightController.logWeight));

// GET /api/weight/history/:userId
router.get('/history/:userId', asyncWrapper(WeightController.getWeightHistory));

// PUT /api/weight/:id
router.put('/:id', asyncWrapper(WeightController.updateWeight));

// DELETE /api/weight/:id
router.delete('/:id', asyncWrapper(WeightController.deleteWeight));

export default router;
