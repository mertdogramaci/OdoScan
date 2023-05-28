package com.rockofmam.OdoScan.security;

import com.rockofmam.OdoScan.enums.VehicleType;
import com.rockofmam.OdoScan.exception.UserNotFoundException;
import com.rockofmam.OdoScan.model.User;
import com.rockofmam.OdoScan.model.Vehicle;
import com.rockofmam.OdoScan.service.OdometerLogService;
import com.rockofmam.OdoScan.service.UserService;
import com.rockofmam.OdoScan.service.VehicleService;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.Year;

@Component
public class DatabasePopulator {

    private final UserService userService;

    private final VehicleService vehicleService;

    private final OdometerLogService odometerLogService;

    public DatabasePopulator(UserService userService, VehicleService vehicleService, OdometerLogService odometerLogService) {
        this.userService = userService;
        this.vehicleService = vehicleService;
        this.odometerLogService = odometerLogService;
    }

    @Transactional
    public void populateDatabase() {
        userService.createUser(new User("Mert", "Doğramacı", "05425252477",
                "mertdogramaci@gmail.com", "Eskişehir, Turkey"));
        userService.createUser(new User("Melih", "Aksoy", "05306084020",
                "melihaksoy@gmail.com", "Ankara, Turkey"));
        userService.createUser(new User("Ali Aykut", "Arık", "05437251435",
                "aliaykutarik@gmail.com", "Etimesgut, Ankara, Turkey"));


        User user1 = userService.getUserById(1L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 1L)
        );
        User user2 = userService.getUserById(2L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 2L)
        );
        User user3 = userService.getUserById(3L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 3L)
        );

        vehicleService.createVehicle(new Vehicle(VehicleType.CAR, "Audi", "A5", Year.now(), user1));
        vehicleService.createVehicle(new Vehicle(VehicleType.MOTORCYCLE, "Ducati", "SuperSport 950 S",
                Year.of(2018), user2));
        vehicleService.createVehicle(new Vehicle(VehicleType.CAR, "Opel", "Astra", Year.of(2020),
                user3));
    }
}
