import { Router } from 'express';
import { ChatController } from '../controllers/chatController';
import { contextSynthesizer } from '../middleware/context';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/chat
router.post('/', contextSynthesizer, asyncWrapper(ChatController.chatWithCompanion));

// GET /api/chat/history/:userId
router.get('/history/:userId', asyncWrapper(ChatController.getChatHistory));

export default router;
