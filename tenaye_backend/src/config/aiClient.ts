import dotenv from 'dotenv';
dotenv.config();

const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
const GEMINI_API_URL = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`;

export interface UserProfileData {
  age: number;
  gender: string;
  height: number;
  weight: number;
  activityLevel: string;
  healthGoals: string[];
  allergies: string[];
  medicalConditions: string[];
}

export class AIService {
  /**
   * Generates a tailored nutrition plan based on user profile and ingredients.
   */
  static async generateNutritionPlan(
    profile: UserProfileData,
    ingredients: string[]
  ): Promise<{ dailyCalorieTarget: number; mealScheduleJson: any }> {
    const prompt = `
You are an expert clinical dietitian and JSON API service.
Generate a personalized daily meal schedule based on the following:
- User Profile: Age ${profile.age}, Gender ${profile.gender}, Height ${profile.height}cm, Weight ${profile.weight}kg, Activity Level: ${profile.activityLevel}
- Health Goals: ${profile.healthGoals.join(', ')}
- Allergies to AVOID: ${profile.allergies.join(', ')}
- Medical Conditions: ${profile.medicalConditions.join(', ')}
- Available raw ingredients to utilize: ${ingredients.join(', ')}

Strict instructions:
1. Do not use ingredients that contain any of the user's allergies.
2. Return ONLY a valid JSON object. No markdown tags (no \`\`\`json block), no conversational prose, no starting/ending text.
3. The JSON structure MUST match exactly:
{
  "dailyCalorieTarget": <integer, e.g. 2000>,
  "mealSchedule": {
    "breakfast": { "meals": ["meal names using ingredients"], "calories": <int>, "nutrients": "string list" },
    "lunch": { "meals": ["meal names"], "calories": <int>, "nutrients": "string list" },
    "dinner": { "meals": ["meal names"], "calories": <int>, "nutrients": "string list" },
    "snacks": { "meals": ["snack names"], "calories": <int>, "nutrients": "string list" }
  },
  "dietaryAdvice": ["advice string 1", "advice string 2"]
}
`;

    if (GEMINI_API_KEY) {
      try {
        const jsonResult = await this.callGeminiAPI(prompt);
        return {
          dailyCalorieTarget: jsonResult.dailyCalorieTarget || 2000,
          mealScheduleJson: jsonResult.mealSchedule || jsonResult,
        };
      } catch (error) {
        console.warn('Gemini API call failed, falling back to mock planner:', error);
      }
    }

    // Fallback Mock Nutrition Planner
    return this.fallbackNutritionPlanner(profile, ingredients);
  }

  /**
   * Generates a tailored weekly fitness plan.
   */
  static async generateFitnessPlan(
    profile: UserProfileData,
    weeklyGoal: string
  ): Promise<{ weeklyGoal: string; scheduleTimelineJson: any }> {
    const prompt = `
You are an expert fitness coach and JSON API service.
Generate a structured fitness timeline based on the following:
- User Profile: Age ${profile.age}, Gender ${profile.gender}, Height ${profile.height}cm, Weight ${profile.weight}kg, Activity Level: ${profile.activityLevel}
- Health Goals: ${profile.healthGoals.join(', ')}
- Medical Conditions: ${profile.medicalConditions.join(', ')}
- Requested Weekly Focus/Goal: ${weeklyGoal}

Strict instructions:
1. Ensure the intensity matches the user's activity level and conditions.
2. Return ONLY a valid JSON object. No markdown tags (no \`\`\`json block), no conversational prose, no starting/ending text.
3. The JSON structure MUST match exactly:
{
  "weeklyGoal": "string describing weekly plan focus",
  "timeline": [
    {
      "day": "Monday",
      "workoutType": "string",
      "durationMinutes": <int>,
      "exercises": [
        { "name": "string", "sets": <int>, "reps": "string e.g. 12 or 60s", "instructions": "short tip" }
      ]
    }
  ]
}
`;

    if (GEMINI_API_KEY) {
      try {
        const jsonResult = await this.callGeminiAPI(prompt);
        return {
          weeklyGoal: jsonResult.weeklyGoal || weeklyGoal,
          scheduleTimelineJson: jsonResult.timeline || jsonResult,
        };
      } catch (error) {
        console.warn('Gemini API call failed, falling back to mock fitness planner:', error);
      }
    }

    // Fallback Mock Fitness Planner
    return this.fallbackFitnessPlanner(profile, weeklyGoal);
  }

  private static async callGeminiAPI(prompt: string): Promise<any> {
    const response = await fetch(GEMINI_API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          responseMimeType: 'application/json',
        },
      }),
    });

    if (!response.ok) {
      throw new Error(`Gemini API HTTP error! Status: ${response.status}`);
    }

    const data = await response.json();
    const rawText = data?.candidates?.[0]?.content?.parts?.[0]?.text;
    if (!rawText) {
      throw new Error('Empty response from Gemini model');
    }

    // Clean any potential markdown wrapping
    let cleanedText = rawText.trim();
    if (cleanedText.startsWith('```')) {
      cleanedText = cleanedText.replace(/^```json\s*/, '').replace(/```$/, '').trim();
    }

    return JSON.parse(cleanedText);
  }

  private static fallbackNutritionPlanner(profile: UserProfileData, ingredients: string[]) {
    // Dynamic calorie calculations based on goals
    const isWeightLoss = profile.healthGoals.some(g => g.toLowerCase().includes('loss') || g.toLowerCase().includes('lose'));
    const isMuscleGain = profile.healthGoals.some(g => g.toLowerCase().includes('gain') || g.toLowerCase().includes('muscle') || g.toLowerCase().includes('weight'));
    
    let targetCalories = 2000;
    if (isWeightLoss) targetCalories = 1600;
    if (isMuscleGain) targetCalories = 2600;

    const lowerIngredients = ingredients.map(i => i.toLowerCase());
    const usedFoods = ingredients.length > 0 ? ingredients : ['vegetables', 'eggs', 'rice', 'chicken'];

    const mealSchedule = {
      breakfast: {
        meals: [`Scrambled eggs with ${usedFoods[0]}`],
        calories: Math.floor(targetCalories * 0.25),
        nutrients: 'Protein, Healthy Fats',
      },
      lunch: {
        meals: [
          lowerIngredients.includes('rice') && lowerIngredients.includes('chicken')
            ? 'Chicken and Rice meal prep bowl'
            : `Healthy protein mix using ${usedFoods.slice(0, 2).join(' and ')}`,
        ],
        calories: Math.floor(targetCalories * 0.35),
        nutrients: 'Carbohydrates, Lean Protein',
      },
      dinner: {
        meals: [`Stir-fry with ${usedFoods.slice(-2).join(' and ')}`],
        calories: Math.floor(targetCalories * 0.3),
        nutrients: 'Fiber, Essential Vitamins',
      },
      snacks: {
        meals: [`Fruit salad or raw snacks`],
        calories: Math.floor(targetCalories * 0.1),
        nutrients: 'Antioxidants, Minerals',
      },
    };

    const dietaryAdvice = [
      'Focus on drinking 3 liters of water daily.',
      isWeightLoss
        ? 'Maintain a slight calorie deficit and limit late-night snacking.'
        : 'Ensure adequate protein intake alongside meals to aid muscle recovery.',
      profile.allergies.length > 0
        ? `Double check ingredients to strictly avoid: ${profile.allergies.join(', ')}.`
        : 'Incorporate plenty of whole foods into your schedule.',
    ];

    return {
      dailyCalorieTarget: targetCalories,
      mealScheduleJson: mealSchedule,
      dietaryAdvice,
    };
  }

  private static fallbackFitnessPlanner(profile: UserProfileData, weeklyGoal: string) {
    const isCardio = weeklyGoal.toLowerCase().includes('cardio') || weeklyGoal.toLowerCase().includes('lose') || weeklyGoal.toLowerCase().includes('weight');
    
    const timeline = [
      {
        day: 'Monday',
        workoutType: isCardio ? 'Aerobic Endurance' : 'Upper Body Strength',
        durationMinutes: 40,
        exercises: isCardio
          ? [
              { name: 'Brisk Walking / Jogging', sets: 1, reps: '30 mins', instructions: 'Maintain consistent pace' },
              { name: 'Jumping Jacks', sets: 3, reps: '45 seconds', instructions: 'Soft landing on balls of feet' },
            ]
          : [
              { name: 'Push-Ups (Modified if needed)', sets: 3, reps: '10-12', instructions: 'Keep core tight, elbows at 45 degrees' },
              { name: 'Dumbbell Rows (or bodyweight equivalent)', sets: 3, reps: '12', instructions: 'Pull shoulders back at top of contraction' },
            ],
      },
      {
        day: 'Wednesday',
        workoutType: isCardio ? 'High Intensity Interval Training' : 'Lower Body Strength',
        durationMinutes: 35,
        exercises: isCardio
          ? [
              { name: 'Mountain Climbers', sets: 4, reps: '30 seconds', instructions: 'Drive knees straight forward' },
              { name: 'Burpees', sets: 3, reps: '10', instructions: 'Ensure straight posture at jumping point' },
            ]
          : [
              { name: 'Squats (Bodyweight or Weighted)', sets: 3, reps: '15', instructions: 'Squat back as if sitting in a chair' },
              { name: 'Lunges', sets: 3, reps: '10 per leg', instructions: 'Keep trunk upright, step straight forward' },
            ],
      },
      {
        day: 'Friday',
        workoutType: 'Active Recovery & Core',
        durationMinutes: 30,
        exercises: [
          { name: 'Plank Hold', sets: 3, reps: '45-60 seconds', instructions: 'Do not let hips sag' },
          { name: 'Stretching Routine', sets: 1, reps: '15 mins', instructions: 'Focus on hamstrings, shoulders, and lower back' },
        ],
      },
    ];

    return {
      weeklyGoal,
      scheduleTimelineJson: timeline,
    };
  }
}
