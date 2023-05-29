package com.rockofmam.OdoScan.security;

import com.rockofmam.OdoScan.enums.Unit;
import com.rockofmam.OdoScan.enums.VehicleType;
import com.rockofmam.OdoScan.exception.UserNotFoundException;
import com.rockofmam.OdoScan.exception.VehicleNotFoundException;
import com.rockofmam.OdoScan.model.OdometerLog;
import com.rockofmam.OdoScan.model.User;
import com.rockofmam.OdoScan.model.Vehicle;
import com.rockofmam.OdoScan.service.OdometerLogService;
import com.rockofmam.OdoScan.service.UserService;
import com.rockofmam.OdoScan.service.VehicleService;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.Year;
import java.util.Date;

@Component
public class DatabasePopulator {

    private final UserService userService;

    private final VehicleService vehicleService;

    private final OdometerLogService odometerLogService;

    public DatabasePopulator(UserService userService, VehicleService vehicleService,
                             OdometerLogService odometerLogService) {
        this.userService = userService;
        this.vehicleService = vehicleService;
        this.odometerLogService = odometerLogService;
    }

    @Transactional
    public void populateDatabase() {
        userService.createUser(new User("Mert", "Doğramacı", "05425252477",
                "mertdogramaci@gmail.com", "Eskişehir, Turkey", "7e5a1e29b7c0dc72"));
        userService.createUser(new User("Melih", "Aksoy", "05306084020",
                "melihaksoy@gmail.com", "Ankara, Turkey", "2c82e09a9b7c7f85"));
        userService.createUser(new User("Ali Aykut", "Arık", "05437251435",
                "aliaykutarik@gmail.com", "Etimesgut, Ankara, Turkey", "0cf4afd417055843"));


        User user1 = userService.getUserById(1L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 1L)
        );
        User user2 = userService.getUserById(2L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 2L)
        );
        User user3 = userService.getUserById(3L).orElseThrow(
                () -> new UserNotFoundException("User could not found by id: " + 3L)
        );

        vehicleService.createVehicle(new Vehicle(VehicleType.Motorcycle, "Ducati", "SuperSport 950 S",
                Year.of(2018), user2));
        vehicleService.createVehicle(new Vehicle(VehicleType.Car, "Fiat", "Egea Sedan",
                Year.of(2019), user1));
        vehicleService.createVehicle(new Vehicle(VehicleType.Car, "Opel", "Astra", Year.of(2020),
                user3));
        vehicleService.createVehicle(new Vehicle(VehicleType.Car, "Audi", "A5", Year.now(), user1));


        Vehicle vehicle1 = vehicleService.getVehicleById(1L).orElseThrow(
                () -> new VehicleNotFoundException("Vehicle could not found by id: " + 1L)
        );
        Vehicle vehicle2 = vehicleService.getVehicleById(2L).orElseThrow(
                () -> new VehicleNotFoundException("Vehicle could not found by id: " + 2L)
        );
        Vehicle vehicle3 = vehicleService.getVehicleById(3L).orElseThrow(
                () -> new VehicleNotFoundException("Vehicle could not found by id: " + 3L)
        );
        Vehicle vehicle4 = vehicleService.getVehicleById(4L).orElseThrow(
                () -> new VehicleNotFoundException("Vehicle could not found by id: " + 4L)
        );

        odometerLogService.createOdometerLog(new OdometerLog(10000L, Unit.km,
                LocalDate.of(2019, 2, 20).atStartOfDay(), vehicle1));
        odometerLogService.createOdometerLog(new OdometerLog(1000L, Unit.km,
                LocalDate.of(2019, 11, 20).atStartOfDay(), vehicle2));
        odometerLogService.createOdometerLog(new OdometerLog(11234L, Unit.km,
                LocalDate.of(2020, 1, 1).atStartOfDay(), vehicle3));
        odometerLogService.createOdometerLog(new OdometerLog(15890L, Unit.km,
                LocalDate.of(2020, 8, 4).atStartOfDay(), vehicle1));
        odometerLogService.createOdometerLog(new OdometerLog(29899L, Unit.km,
                LocalDate.of(2021, 3, 15).atStartOfDay(), vehicle1));
        odometerLogService.createOdometerLog(new OdometerLog(100546L, Unit.km,
                LocalDate.of(2021, 8, 26).atStartOfDay(), vehicle2));
        odometerLogService.createOdometerLog(new OdometerLog(12000L, Unit.km,
                LocalDate.of(2023, 2, 20).atStartOfDay(), vehicle4));
        odometerLogService.createOdometerLog(new OdometerLog(150789L, Unit.km,
                LocalDate.of(2023, 1, 2).atStartOfDay(), vehicle2));
        odometerLogService.createOdometerLog(new OdometerLog(45678L, Unit.km,
                LocalDate.of(2023, 5, 28).atStartOfDay(), vehicle3));
    }
}
