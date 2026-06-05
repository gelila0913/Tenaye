"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const chatController_1 = require("../controllers/chatController");
const context_1 = require("../middleware/context");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/chat
router.post('/', context_1.contextSynthesizer, (0, asyncWrapper_1.asyncWrapper)(chatController_1.ChatController.chatWithCompanion));
// GET /api/chat/history/:userId
router.get('/history/:userId', (0, asyncWrapper_1.asyncWrapper)(chatController_1.ChatController.getChatHistory));
exports.default = router;
