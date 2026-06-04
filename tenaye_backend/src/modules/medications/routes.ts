import { Router } from 'express';
import { MedicationsController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/', asyncWrapper(MedicationsController.addMedication));
router.get('/:userId', asyncWrapper(MedicationsController.getMedications));
router.delete('/:userId', asyncWrapper(MedicationsController.clearMedications));

export default router;
