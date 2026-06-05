import { Router } from 'express';
import { MedicationController } from '../controllers/medicationController';
import { asyncWrapper } from '../utils/asyncWrapper';

const router = Router();

// POST /api/medications
router.post('/', asyncWrapper(MedicationController.addMedication));

// GET /api/medications/active/:userId
router.get('/active/:userId', asyncWrapper(MedicationController.getActiveMedications));

// PUT /api/medications/:id
router.put('/:id', asyncWrapper(MedicationController.updateMedication));

// DELETE /api/medications/:id
router.delete('/:id', asyncWrapper(MedicationController.deleteMedication));

export default router;
