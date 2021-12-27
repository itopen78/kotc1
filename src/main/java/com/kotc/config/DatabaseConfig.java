package com.kotc.config;

import javax.sql.DataSource;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import com.zaxxer.hikari.HikariDataSource;

@Configuration
public class DatabaseConfig {

	@Primary 
	@Bean(name = "kotcMySqlDs")
	@ConfigurationProperties(prefix="kotc.datasource")
	public DataSource kotcMySqlDs() throws Exception {
		return DataSourceBuilder.create().type(HikariDataSource.class).build();
	}

	@Bean(name = "innodisMySqlDs")
	@ConfigurationProperties(prefix="innodis.datasource")
	public DataSource innodisMySqlDs() throws Exception {
		return DataSourceBuilder.create().type(HikariDataSource.class).build();
	}
}
