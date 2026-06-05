import { Router } from 'express';
import { MedicationController } from '../controllers/medicationController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/medications
router.post('/', asyncWrapper(MedicationController.addMedication));

// GET /api/medications/active/:userId
router.get('/active/:userId', asyncWrapper(MedicationController.getActiveMedications));

export default router;
