package com.kotc.common;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class XlsUtil {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(XlsUtil.class.getName());
	
	public static void excelDownload(HttpServletResponse response, String fileName, String[] enames, String[] knames, List<Map> list) {
		excelDownload1(response, fileName, enames, knames, list);
	}
	
	// 엑셀다운로드
	public static void excelDownload1(HttpServletResponse response, String fileName, String[] enames, String[] knames, List<Map> list) {
		try {
			XSSFWorkbook workbook = new XSSFWorkbook();
			XSSFSheet sheet = workbook.createSheet();
			workbook.setSheetName(0, "sheet1");
		    
			CellStyle style= workbook.createCellStyle();
			XSSFFont font = workbook.createFont();
			font.setFontName("맑은 고딕");
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);
			style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderLeft(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.index);
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
			
			XSSFRow row = sheet.createRow(0);
			for(int j=0; j<knames.length; j++) {
				XSSFCell cell = row.createCell(j);
				cell.setCellStyle(style);
				cell.setCellValue(knames[j]);
			}
			System.out.println("22=11111");
			style= workbook.createCellStyle();
			font = workbook.createFont();
			font.setFontName("맑은 고딕");
			style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			style.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			style.setFont(font);
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBorderLeft(CellStyle.BORDER_THIN);
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setBorderTop(CellStyle.BORDER_THIN);
			
			for(int i=0; i<list.size(); i++){
				Map<String, Object> fields = list.get(i);
				row = sheet.createRow(i+1);
				
				for(int j=0; j<enames.length; j++){
					String headerName = enames[j];
					String val = (fields.get(headerName)==null)? "" : fields.get(headerName).toString();
					XSSFCell cell = row.createCell(j);
					String value = "";
					cell.setCellValue(value);
					cell.setCellStyle(style);
				}
			}
		    			
			for(int i = 0; i < enames.length; i++) {
				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, Math.min(sheet.getColumnWidth(i)+512, 255*256));
			}
		
			response.reset();
	        response.setHeader("Content-Type", "application/vnd.ms-excel;charset=UTF-8");
	        response.setHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));
	        response.setHeader("Expires", "0");
	    	System.out.println("33=11111");
	        workbook.write(response.getOutputStream());
		}
		catch(Exception e) {
			if(LOGGER.isErrorEnabled()) {
				LOGGER.error("XlsUtil excelDownload Exception !!! {}", e.getMessage());
			}
		}
	}
}
