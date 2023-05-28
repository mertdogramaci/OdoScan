package com.rockofmam.OdoScan.service;

import com.rockofmam.OdoScan.exception.OdometerLogNotFoundException;
import com.rockofmam.OdoScan.model.OdometerLog;
import com.rockofmam.OdoScan.repository.OdometerLogRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OdometerLogService {
    private final OdometerLogRepository odometerLogRepository;

    public OdometerLogService(OdometerLogRepository odometerLogRepository) {
        this.odometerLogRepository = odometerLogRepository;
    }

    protected OdometerLog findOdometerLogById(Long id) {
        return odometerLogRepository.findById(id).orElseThrow(
                () -> new OdometerLogNotFoundException("Vehicle could not found by id: " + id)
        );
    }

    public Optional<OdometerLog> getOdometerLogById(Long odometerLogId) {
        return odometerLogRepository.findById(odometerLogId);
    }

    public List<OdometerLog> getAllOdometerLog() {
        return odometerLogRepository.findAll();
    }

    public OdometerLog createOdometerLog(OdometerLog odometerLog) {
        return odometerLogRepository.save(odometerLog);
    }

    public OdometerLog updateOdometerLog(Long odometerLogId, OdometerLog odometerLog) {
        OdometerLog odometerLog1 = findOdometerLogById(odometerLogId);

        if (odometerLog1.getId() != null) {
            odometerLog1.setOdometerReading(odometerLog.getOdometerReading());
            odometerLog1.setUnit(odometerLog.getUnit());
            odometerLog1.setVehicle(odometerLog.getVehicle());
        }

        return odometerLogRepository.save(odometerLog1);
    }

    public void deleteOdometerLogById(Long id) {
        odometerLogRepository.deleteById(id);
    }
}
