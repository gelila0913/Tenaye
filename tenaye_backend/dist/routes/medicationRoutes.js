"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const medicationController_1 = require("../controllers/medicationController");
const asyncWrapper_1 = require("../utils/asyncWrapper");
const router = (0, express_1.Router)();
// POST /api/medications
router.post('/', (0, asyncWrapper_1.asyncWrapper)(medicationController_1.MedicationController.addMedication));
// GET /api/medications/active/:userId
router.get('/active/:userId', (0, asyncWrapper_1.asyncWrapper)(medicationController_1.MedicationController.getActiveMedications));
// PUT /api/medications/:id
router.put('/:id', (0, asyncWrapper_1.asyncWrapper)(medicationController_1.MedicationController.updateMedication));
// DELETE /api/medications/:id
router.delete('/:id', (0, asyncWrapper_1.asyncWrapper)(medicationController_1.MedicationController.deleteMedication));
exports.default = router;
