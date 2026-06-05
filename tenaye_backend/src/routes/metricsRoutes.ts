import { Router } from 'express';
import { MetricsController } from '../controllers/metricsController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/metrics/log
router.post('/log', asyncWrapper(MetricsController.logMetric));

// GET /api/metrics/history/:userId
router.get('/history/:userId', asyncWrapper(MetricsController.getMetricsHistory));

// PUT /api/metrics/:id
router.put('/:id', asyncWrapper(MetricsController.updateMetric));

// DELETE /api/metrics/:id
router.delete('/:id', asyncWrapper(MetricsController.deleteMetric));

export default router;
