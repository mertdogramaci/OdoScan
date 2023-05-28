package com.rockofmam.OdoScan.controller;

import com.rockofmam.OdoScan.model.OdometerLog;
import com.rockofmam.OdoScan.model.Vehicle;
import com.rockofmam.OdoScan.service.OdometerLogService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/odometerLog")
public class OdometerLogController {
    private final OdometerLogService odometerLogService;

    public OdometerLogController(OdometerLogService odometerLogService) {
        this.odometerLogService = odometerLogService;
    }

    @GetMapping("/{odometerLogId}")
    public ResponseEntity<Optional<OdometerLog>> getOdometerLogById(@PathVariable Long odometerLogId) {
        return ResponseEntity.ok(odometerLogService.getOdometerLogById(odometerLogId));
    }

    @GetMapping
    public ResponseEntity<List<OdometerLog>> getAllOdometerLogs() {
        return ResponseEntity.ok(odometerLogService.getAllOdometerLog());
    }

    @PostMapping
    public ResponseEntity<OdometerLog> createOdometerLog(@RequestBody OdometerLog odometerLog) {
        return ResponseEntity.ok(odometerLogService.createOdometerLog(odometerLog));
    }

    @PutMapping("/{id}")
    public ResponseEntity<OdometerLog> updateOdometerLog(@PathVariable Long id, @RequestBody OdometerLog odometerLog) {
        return ResponseEntity.ok(odometerLogService.updateOdometerLog(id, odometerLog));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteOdometerLog(@PathVariable Long id) {
        odometerLogService.deleteOdometerLogById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/vehicleId/{vehicleId}")
    public ResponseEntity<List<OdometerLog>> getAllOdometerLogsOfVehicle(@PathVariable Long vehicleId) {
        return ResponseEntity.ok(odometerLogService.getAllOdometerLogsOfVehicle(vehicleId));
    }
}
