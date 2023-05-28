package com.rockofmam.OdoScan;

import com.rockofmam.OdoScan.security.DatabasePopulator;
import jakarta.annotation.PostConstruct;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class })
public class OdoScanApplication {

	private final DatabasePopulator databasePopulator;

	public OdoScanApplication(DatabasePopulator databasePopulator) {
		this.databasePopulator = databasePopulator;
	}

	public static void main(String[] args) {
		SpringApplication.run(OdoScanApplication.class, args);
	}

	@PostConstruct
	public void populateDatabase() {
		databasePopulator.populateDatabase();
	}
}
