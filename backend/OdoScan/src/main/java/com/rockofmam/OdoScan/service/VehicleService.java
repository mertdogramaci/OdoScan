package com.rockofmam.OdoScan.service;

import com.rockofmam.OdoScan.exception.VehicleNotFoundException;
import com.rockofmam.OdoScan.model.Vehicle;
import com.rockofmam.OdoScan.repository.VehicleRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class VehicleService {
    private final VehicleRepository vehicleRepository;

    public VehicleService(VehicleRepository vehicleRepository) {
        this.vehicleRepository = vehicleRepository;
    }

    protected Vehicle findVehicleById(Long id) {
        return vehicleRepository.findById(id).orElseThrow(
                () -> new VehicleNotFoundException("Vehicle could not found by id: " + id)
        );
    }

    public Optional<Vehicle> getVehicleById(Long vehicleId) {
        return vehicleRepository.findById(vehicleId);
    }

    public List<Vehicle> getAllVehicle() {
        return vehicleRepository.findAll();
    }

    public Vehicle createVehicle(Vehicle vehicle) {
        return vehicleRepository.save(vehicle);
    }

    public Vehicle updateVehicle(Long vehicleId, Vehicle vehicle) {
        Vehicle vehicle1 = findVehicleById(vehicleId);

        if (vehicle1.getId() != null) {
            vehicle1.setVehicleType(vehicle.getVehicleType());
            vehicle1.setBrand(vehicle.getBrand());
            vehicle1.setModel(vehicle.getModel());
            vehicle1.setPurchaseYear(vehicle.getPurchaseYear());
            vehicle1.setUser(vehicle.getUser());
            vehicle1.setOdometerLogs(vehicle.getOdometerLogs());
        }

        return vehicleRepository.save(vehicle1);
    }

    public void deleteVehicleById(Long id) {
        vehicleRepository.deleteById(id);
    }

    public List<Vehicle> getAllVehiclesOfUser(Long userId) {
        List<Vehicle> allVehicles = vehicleRepository.findAll();
        List<Vehicle> allVehiclesOfUser = new ArrayList<>();

        for (Vehicle vehicle: allVehicles) {
            if (vehicle.getUser().getId().equals(userId)) {
                allVehiclesOfUser.add(vehicle);
            }
        }

        return allVehiclesOfUser;
    }
}
