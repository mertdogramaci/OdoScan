package com.rockofmam.OdoScan.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class OdometerLogNotFoundException extends RuntimeException {
    public OdometerLogNotFoundException(String message) {
        super(message);
    }
}
