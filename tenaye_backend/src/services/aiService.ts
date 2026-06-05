import { GoogleGenAI } from '@google/genai';
import dotenv from 'dotenv';
dotenv.config();

// Read API key from AI_API_KEY environment variable (fallback to GEMINI_API_KEY)
const apiKey = process.env.AI_API_KEY || process.env.GEMINI_API_KEY || '';

if (!apiKey) {
  console.warn('Warning: AI_API_KEY is not defined in environment variables.');
}

// Configure AI controller instance
export const ai = new GoogleGenAI({ apiKey });

export class AIService {
  /**
   * Generates text content using the Google Gen AI SDK.
   * Implements request timeouts and strict error boundaries.
   */
  static async generateText(
    prompt: string,
    options?: {
      systemInstruction?: string;
      responseMimeType?: string;
      timeoutMs?: number;
    }
  ): Promise<string> {
    const timeoutMs = options?.timeoutMs || 25000; // 25s baseline timeout
    const model = 'gemini-2.5-flash';

    try {
      const response = await ai.models.generateContent({
        model,
        contents: prompt,
        config: {
          systemInstruction: options?.systemInstruction,
          responseMimeType: options?.responseMimeType,
          abortSignal: AbortSignal.timeout(timeoutMs),
        },
      });

      const text = response.text;
      if (!text) {
        throw new Error('Received empty text response from AI model');
      }

      return text;
    } catch (error: any) {
      console.error(`[AIService Error] model=${model} message=${error.message}`);

      // Handle timeouts specifically
      if (
        error.name === 'TimeoutError' ||
        error.name === 'AbortError' ||
        error.message?.toLowerCase().includes('timeout') ||
        error.message?.toLowerCase().includes('aborted')
      ) {
        throw new Error('AI service request timed out. Please try again.');
      }

      throw new Error(`AI service error: ${error.message || 'Unknown error occurred'}`);
    }
  }
}
