"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const controllers_1 = require("./controllers");
const asyncWrapper_1 = require("../../utils/asyncWrapper");
const router = (0, express_1.Router)();
router.post('/generate', (0, asyncWrapper_1.asyncWrapper)(controllers_1.NutritionController.generateNutritionPlan));
router.get('/:userId', (0, asyncWrapper_1.asyncWrapper)(controllers_1.NutritionController.getNutritionPlans));
exports.default = router;
