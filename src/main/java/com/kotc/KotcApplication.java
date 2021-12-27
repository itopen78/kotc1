package com.kotc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages="com.kotc, kr.co.kotc.api")
public class KotcApplication {

	public static void main(String[] args) {
		SpringApplication.run(KotcApplication.class, args);
	}

}
