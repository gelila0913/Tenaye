"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const nutritionController_1 = require("../controllers/nutritionController");
const context_1 = require("../middleware/context");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/nutrition/generate
router.post('/generate', context_1.contextSynthesizer, (0, asyncWrapper_1.asyncWrapper)(nutritionController_1.NutritionController.generateNutritionPlan));
// GET /api/nutrition/:userId
router.get('/:userId', (0, asyncWrapper_1.asyncWrapper)(nutritionController_1.NutritionController.getNutritionPlans));
exports.default = router;
