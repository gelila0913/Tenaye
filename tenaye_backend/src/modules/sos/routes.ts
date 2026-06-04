import { Router } from 'express';
import { SosController } from './controllers';
import { asyncWrapper } from '../../utils/asyncWrapper';

const router = Router();

router.post('/contacts', asyncWrapper(SosController.addEmergencyContact));
router.get('/active/:userId', asyncWrapper(SosController.getSosActiveSummary));

export default router;
