"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const moodController_1 = require("../controllers/moodController");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/mood/log
router.post('/log', (0, asyncWrapper_1.asyncWrapper)(moodController_1.MoodController.logMood));
// GET /api/mood/history/:userId
router.get('/history/:userId', (0, asyncWrapper_1.asyncWrapper)(moodController_1.MoodController.getMoodHistory));
exports.default = router;
