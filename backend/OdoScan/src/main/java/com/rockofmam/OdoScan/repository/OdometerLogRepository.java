package com.rockofmam.OdoScan.repository;

import com.rockofmam.OdoScan.model.OdometerLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OdometerLogRepository extends JpaRepository<OdometerLog, Long> {
}
