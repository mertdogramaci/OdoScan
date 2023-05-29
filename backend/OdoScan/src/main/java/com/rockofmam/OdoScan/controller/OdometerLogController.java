package com.rockofmam.OdoScan.controller;

import com.rockofmam.OdoScan.enums.Unit;
import com.rockofmam.OdoScan.model.OdometerLog;
import com.rockofmam.OdoScan.model.User;
import com.rockofmam.OdoScan.model.Vehicle;
import com.rockofmam.OdoScan.service.OdometerLogService;
import com.rockofmam.OdoScan.service.UserService;
import com.rockofmam.OdoScan.service.VehicleService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/odometerLog")
public class OdometerLogController {
    private final OdometerLogService odometerLogService;
    private final UserService userService;
    private final VehicleService vehicleService;

    public OdometerLogController(OdometerLogService odometerLogService, UserService userService,
                                 VehicleService vehicleService) {
        this.odometerLogService = odometerLogService;
        this.userService = userService;
        this.vehicleService = vehicleService;
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

    @PostMapping("/mobile")
    public ResponseEntity<OdometerLog> createOdometerLog(@RequestBody String deviceId, @RequestBody String mileage) {
        User user = userService.getUserByDeviceId(deviceId);
        Vehicle vehicle = user.getVehicles().get(user.getVehicles().size() - 1);
        OdometerLog odometerLog = new OdometerLog(Long.valueOf(mileage), Unit.km, LocalDateTime.now(), vehicle);
        return ResponseEntity.ok(odometerLogService.createOdometerLog(odometerLog));
    }

    @GetMapping("/mobile/{deviceId}")
    public ResponseEntity<List<OdometerLog>> getOdometerLogsOfUser(@PathVariable String deviceId) {
        User user = userService.getUserByDeviceId(deviceId);
        List<Vehicle> vehicles = vehicleService.getAllVehiclesOfUser(user.getId());
        List<OdometerLog> odometerLogs = new ArrayList<>();

        for (Vehicle vehicle: vehicles) {
            odometerLogs.addAll(odometerLogService.getAllOdometerLogsOfVehicle(vehicle.getId()));
        }

        return ResponseEntity.ok(odometerLogs);
    }
}
