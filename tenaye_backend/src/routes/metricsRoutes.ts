import { Router } from 'express';
import { MetricsController } from '../controllers/metricsController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/metrics/log
router.post('/log', asyncWrapper(MetricsController.logMetric));

// GET /api/metrics/history/:userId
router.get('/history/:userId', asyncWrapper(MetricsController.getMetricsHistory));

export default router;
