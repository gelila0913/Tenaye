"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const weightController_1 = require("../controllers/weightController");
const upload_1 = require("../middleware/upload");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/weight/log - accepts optional progress photo with field key 'photo'
router.post('/log', upload_1.upload.single('photo'), (0, asyncWrapper_1.asyncWrapper)(weightController_1.WeightController.logWeight));
// GET /api/weight/history/:userId
router.get('/history/:userId', (0, asyncWrapper_1.asyncWrapper)(weightController_1.WeightController.getWeightHistory));
// PUT /api/weight/:id
router.put('/:id', (0, asyncWrapper_1.asyncWrapper)(weightController_1.WeightController.updateWeight));
// DELETE /api/weight/:id
router.delete('/:id', (0, asyncWrapper_1.asyncWrapper)(weightController_1.WeightController.deleteWeight));
exports.default = router;
