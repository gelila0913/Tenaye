"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const fitnessController_1 = require("../controllers/fitnessController");
const context_1 = require("../middleware/context");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/fitness/generate
router.post('/generate', context_1.contextSynthesizer, (0, asyncWrapper_1.asyncWrapper)(fitnessController_1.FitnessController.generateFitnessPlan));
// GET /api/fitness/:userId
router.get('/:userId', (0, asyncWrapper_1.asyncWrapper)(fitnessController_1.FitnessController.getFitnessPlans));
exports.default = router;
