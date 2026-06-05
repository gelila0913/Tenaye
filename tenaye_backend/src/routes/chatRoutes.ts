import { Router } from 'express';
import { ChatController } from '../controllers/chatController';
import { contextSynthesizer } from '../middleware/context';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/chat
router.post('/', contextSynthesizer, asyncWrapper(ChatController.chatWithCompanion));

export default router;
