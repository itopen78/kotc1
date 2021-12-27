package com.kotc.common;

import java.io.File;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellUtil;

public class WriteToXLS {
	private static final Logger LOGGER = LoggerFactory.getLogger(WriteToXLS.class.getName());
			
	private void autoSizeColumns(Sheet sheetData, int maxColNum) throws Exception {
		int width = 0;
		for (int col = 0; col < maxColNum; col++) {
			int cwidth = sheetData.getColumnWidth(col);
			cwidth += 1500;
			sheetData.setColumnWidth(col, cwidth);
			width += cwidth;
		}
		int nominator = 45000 * 100 / width;
		if (nominator < 100) {sheetData.setZoom(nominator, 100);}
	}
	
	public boolean isStringDouble(String s) {
	    try {
	        Integer.parseInt(s); 
	        return true;
	    } catch (NumberFormatException e) {return false;}
	}
	
	public void writeXls(HttpServletResponse response, String filePath, String[] enames, String[] knames, List<Map> list) {
		String fileName = filePath + ".xlsx";
		XSSFWorkbook workbook = new XSSFWorkbook();
		XSSFSheet sheet = workbook.createSheet("Sheet1");
		DataFormat df = workbook.createDataFormat();
		Font bold = workbook.createFont();
		bold.setBoldweight(Font.BOLDWEIGHT_BOLD);
		bold.setFontHeightInPoints((short) 10);
		CellStyle headerStyle = null;
		headerStyle = workbook.createCellStyle();
		headerStyle.setBorderBottom(CellStyle.BORDER_THIN);
		headerStyle.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		headerStyle.setFont(bold);
		headerStyle.setAlignment(HorizontalAlignment.CENTER);
		CellStyle numberStyle = workbook.createCellStyle();
		numberStyle.setDataFormat(df.getFormat("#,##0"));
		
		//액셀 헤더 row
		Row row = sheet.createRow(0);
		for (int i=0; i<enames.length; i++) {
			Cell cell = row.createCell(i);
			cell.setCellStyle(headerStyle);
			String headerName = knames[i];
			cell.setCellValue(headerName);
		}
		
		//엑셂 data row
		for (int i=0; i<list.size(); i++) {
			HashMap map = (HashMap)list.get(i);
			row = sheet.createRow(i+1);
			
			for(int j=0; j<enames.length;j++) {
				String headerName = enames[j];
				String val = (map.get(headerName)==null)? "" : map.get(headerName).toString();
				
				if(headerName.equals("USE_YN")) {
					if(map.get(headerName).equals("Y")) val = "사용";
					else val = "미사용";
				}
				
				Cell cell = row.createCell(j);
				if(j > 0) {
					if(!isStringDouble(val)) {cell.setCellValue(val);}
					else {cell.setCellValue(Double.parseDouble(String.format("%.2f",Double.parseDouble(val))));}
				}else {cell.setCellValue(val);}
				CellUtil.setCellStyleProperty(cell, CellUtil.ALIGNMENT, HorizontalAlignment.RIGHT);
			}
		}

		try {
			for(int i = 0; i < enames.length; i++) {
				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, Math.min(sheet.getColumnWidth(i)+512, 255*256));
			}
			
			response.reset();
	        response.setHeader("Content-Type", "application/vnd.ms-excel;charset=UTF-8");
	        response.setHeader("Content-Disposition", "attachment;filename=" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));
	        response.setHeader("Expires", "0");
	        workbook.write(response.getOutputStream());
	        
		} catch(Exception e) {
			if(LOGGER.isErrorEnabled()) {
				LOGGER.error("Error while flushing/closing fileWriter/xlsPrinter !!! {}", e.getMessage());  
			}
		}
	}
}
