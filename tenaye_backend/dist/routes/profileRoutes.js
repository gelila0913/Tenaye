"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const profileController_1 = require("../controllers/profileController");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/profile
router.post('/', (0, asyncWrapper_1.asyncWrapper)(profileController_1.ProfileController.upsertUserProfile));
// GET /api/profile/:id
router.get('/:id', (0, asyncWrapper_1.asyncWrapper)(profileController_1.ProfileController.getUserProfile));
exports.default = router;
