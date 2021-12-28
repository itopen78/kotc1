package com.kotc.service;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.kotc.mapper.LicenseMapper;

@Service
public class LicenseService {

	private static final Logger logger = LoggerFactory.getLogger(LicenseService.class);
	
	@Autowired
	@Qualifier("innodisSessionTemplate")
	private SqlSession innodisSqlSession;
	
	@Autowired LicenseMapper licenseMapper;
}
