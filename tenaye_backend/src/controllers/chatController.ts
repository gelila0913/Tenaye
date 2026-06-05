import { Response } from 'express';
import { ContextRequest } from '../middleware/context';
import { AIService } from '../services/aiService';

export class ChatController {
  /**
   * Chat with Tenaye health companion (POST /api/chat)
   */
  static async chatWithCompanion(req: ContextRequest, res: Response) {
    const userContext = req.userContext;
    const { message } = req.body;

    if (!message) {
      return res.status(400).json({
        success: false,
        error: 'ValidationError',
        message: 'message is required.',
      });
    }

    if (!userContext) {
      return res.status(500).json({
        success: false,
        error: 'ServerError',
        message: 'User context was not synthesized correctly.',
      });
    }

    const systemPrompt = `
You are Tenaye, a supportive, empathetic, and highly knowledgeable health companion. 
Your goal is to guide the user on their wellness journey with personalized health, lifestyle, and medical advice.

Strict guidelines:
1. Silently reference the user's profile context provided below to customize your recommendations, but never explicitly state: "Based on the context you provided..." or reference the raw context fields unless directly relevant. Keep it natural and highly personalized.
2. Maintain your role as a supportive health companion ("Tenaye") at all times. Do not break character.
3. Be clear, empathetic, and supportive. Offer practical advice.
4. For serious medical concerns, always include a gentle reminder to consult with a medical professional, while still offering supportive lifestyle/first-aid tips.

Here is the User's Profile Context:
${userContext}
`;

    try {
      const reply = await AIService.generateText(message, {
        systemInstruction: systemPrompt,
      });

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
}
