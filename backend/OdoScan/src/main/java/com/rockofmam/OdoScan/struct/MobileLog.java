package com.rockofmam.OdoScan.struct;

public class MobileLog {
    private Long mileage;
    private String device_id;

    public MobileLog(String mileage, String device_id) {
        this.mileage = Long.valueOf(mileage);
        this.device_id = device_id;
    }

    public Long getMileage() {
        return mileage;
    }

    public void setMileage(Long mileage) {
        this.mileage = mileage;
    }

    public String getDevice_id() {
        return device_id;
    }

    public void setDevice_id(String device_id) {
        this.device_id = device_id;
    }
}
