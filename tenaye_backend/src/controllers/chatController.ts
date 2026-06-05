import { Request, Response } from 'express';
import { ContextRequest } from '../middleware/context';
import { AIService } from '../services/aiService';
import { prisma } from '../config/database';

export class ChatController {
  /**
   * Chat with Tenaye health companion (POST /api/chat)
   */
  static async chatWithCompanion(req: ContextRequest, res: Response) {
    const userContext = req.userContext;
    const profile = req.userProfile;
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'message is required.',
      });
    }

    let systemPrompt = '';
    if (profile && userContext) {
      systemPrompt = `You are Tenaye. Use the following patient context to inform all advice. If the context is empty, give general advice.

${userContext}

Tenaye Persona:
You are Tenaye, a supportive, empathetic, and highly knowledgeable health companion. 
Your goal is to guide the user on their wellness journey with personalized health, lifestyle, and medical advice.
Always be clear, empathetic, supportive, and offer practical advice. For serious medical concerns, remind the user to consult a medical professional.`;
    } else {
      systemPrompt = `You are Tenaye, a supportive, empathetic, and highly knowledgeable health companion. 
Your goal is to guide the user on their wellness journey with personalized health, lifestyle, and medical advice.
Always be clear, empathetic, supportive, and offer practical advice. For serious medical concerns, remind the user to consult a medical professional.`;
    }

    try {
      const reply = await AIService.generateText(message, {
        systemInstruction: systemPrompt,
      });

      if (profile) {
        const userId = profile.id;
        const now = new Date();
        // Save user message (slightly earlier to guarantee chronological sort order) and AI response
        await prisma.$transaction([
          prisma.chatMessage.create({
            data: {
              userId,
              role: 'user',
              content: message,
              createdAt: new Date(now.getTime() - 100),
            },
          }),
          prisma.chatMessage.create({
            data: {
              userId,
              role: 'ai',
              content: reply,
              createdAt: now,
            },
          }),
        ]);
      }

      return res.status(200).json({
        success: true,
        data: {
          reply,
        },
      });
    } catch (error: any) {
      console.error('Chat error:', error);
      return res.status(500).json({
        success: false,
        error: 'ChatError',
        message: error.message || 'Failed to generate chat response from AI.',
      });
    }
  }

  /**
   * Get historical chat messages (GET /api/chat/history/:userId)
   */
  static async getChatHistory(req: Request, res: Response) {
    const { userId } = req.params;

    if (!userId) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'userId is required.',
      });
    }

    try {
      const user = await prisma.userProfile.findUnique({
        where: { id: userId },
      });

      if (!user) {
        return res.status(404).json({
          success: false,
          error: 'NotFoundError',
          message: `UserProfile with ID ${userId} was not found.`,
        });
      }

      const messages = await prisma.chatMessage.findMany({
        where: { userId },
        orderBy: { createdAt: 'asc' },
      });

      return res.status(200).json({
        success: true,
        data: messages,
      });
    } catch (error: any) {
      console.error('Failed to retrieve chat history:', error);
      return res.status(500).json({
        success: false,
        error: 'HistoryRetrievalError',
        message: error.message || 'Failed to retrieve chat history.',
      });
    }
  }
}
