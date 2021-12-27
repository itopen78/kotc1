package com.kotc.common;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class DataUtils {
	/**
	 * HTTP Request 호출
	 * @param url - 호출 URL
	 * @param headers - 헤더
	 * @param is_post - POST 여부
	 * @param data - 전송 데이터
	 * @return
	 * @throws Exception
	 */
	public static JSONObject getHttpData(String url, Map<String, String> headers, boolean ispost, String data) {
		URL src;
		HttpURLConnection con = null;
		OutputStreamWriter wr = null;
		InputStream is = null;
		try {
			src = new URL(url);
			con = (HttpURLConnection) src.openConnection();
			
			if(headers != null && headers.size() > 0) {
				Iterator<String> keys = headers.keySet().iterator();
				while(keys.hasNext()) {
					String key = keys.next();
					con.setRequestProperty(key, headers.get(key));
				}
			}

			//System.out.println("url = " + url);
			if(data != null) {
				//System.out.println("data = " + data);
			}
			
			if(ispost) {
				con.setRequestMethod("POST");
				con.setDoInput(true);
				con.setDoOutput(true);
				con.setUseCaches(false);
				con.setDefaultUseCaches(false);
				wr = new OutputStreamWriter(con.getOutputStream());
				wr.write(data); 
				wr.flush();
			}else {
				con.setRequestMethod("GET");
				con.setDoOutput(false); 
			}
			
			if(con.getResponseCode() == con.HTTP_OK) {
				InputStreamReader reader = new InputStreamReader(con.getInputStream(),"utf-8");
				JSONParser parser = new JSONParser();
				JSONObject result = (JSONObject)parser.parse(reader);
				
				reader.close();
				return result;
			}else {
				is = con.getInputStream();
				StringBuffer sb = new StringBuffer();
			     byte[] b = new byte[4096];
			     for (int n; (n = is.read(b)) != -1;) {
			         sb.append(new String(b, 0, n));
			     }
			  sb.toString();
			}
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			if(wr != null) {
				try {
					wr.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(is != null) {
				try {
					is.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			
			if(con != null) {
				con.disconnect();
			}
		}
		
		return null;
	}
	
	/**
	 * HTTP GET 호출해서 결과 JSON 받기
	 * @param url - 호출 URL
	 * @return
	 * @throws Exception
	 */
	public static JSONObject getHttpJson(String url) {
		try {
			Map<String, String> headers = new HashMap<String, String>();
			headers.put("Content-Type", "application/json");
			JSONObject result = getHttpData(url, headers, false, null);
			return result;
		}catch(Exception ex) {
			
		}
		return null;
	}
	
	/**
	 * HTTP POST 호출해서 JSON을 MAP으로 받기
	 * @param url - 호출 URL
	 * @param param - JSON형태의 MAP
	 * @return
	 * @throws Exception
	 */
	public static Map<String, Object> getHttpJsonPost(String url, Map<String, Object> param) {
		try {
			JSONObject json = new JSONObject(param);
			String data = json.toJSONString();
			Map<String, String> headers = new HashMap<String, String>();
			headers.put("Content-Type", "application/json");
			JSONObject result = getHttpData(url, headers, true, data);
			Map<String, Object> resultmap = new ObjectMapper().readValue(result.toJSONString(), Map.class);
			return resultmap;
		}catch(Exception ex) {
			
		}
		return null;
	}
	
	/**
	 * HTTP GET 호출해서 정상여부만 확인
	 * @param url - 호출 URL
	 * @return
	 */
	public static boolean getHttpResult(String url) {
		JSONObject result = getHttpData(url, null, false, null);
		return result != null;
	}	
}
