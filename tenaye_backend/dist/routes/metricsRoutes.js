"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const metricsController_1 = require("../controllers/metricsController");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/metrics/log
router.post('/log', (0, asyncWrapper_1.asyncWrapper)(metricsController_1.MetricsController.logMetric));
// GET /api/metrics/history/:userId
router.get('/history/:userId', (0, asyncWrapper_1.asyncWrapper)(metricsController_1.MetricsController.getMetricsHistory));
// PUT /api/metrics/:id
router.put('/:id', (0, asyncWrapper_1.asyncWrapper)(metricsController_1.MetricsController.updateMetric));
// DELETE /api/metrics/:id
router.delete('/:id', (0, asyncWrapper_1.asyncWrapper)(metricsController_1.MetricsController.deleteMetric));
exports.default = router;
