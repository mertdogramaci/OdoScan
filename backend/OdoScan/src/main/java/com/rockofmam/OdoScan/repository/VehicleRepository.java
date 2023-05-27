package com.rockofmam.OdoScan.repository;

import com.rockofmam.OdoScan.model.Vehicle;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VehicleRepository extends JpaRepository<Vehicle, Long> {
}
