package com.kotc.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.ui.Model;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.kotc.vo.LoginToken;

import net.sf.json.JSONObject;

public class StringUtil {
	
	/**
	 * 16진수 문자열에 더하기 1을 한다. 단, 1f(31)이면 1로 세팅한다. 
	 * @param in
	 * @return
	 */
	public static String seqPlus1(String in) {
		String seq = in;
		
		if(seq == null || seq.equals("0")) return "00";
		
		int iSeq = Integer.parseInt(seq, 16);
		
		if(iSeq < 31) iSeq++;
		else iSeq = 0;
		
		seq = Integer.toHexString(iSeq);
		if(seq.length()==1) seq = "0"+seq;
		
		return seq;
	}
	
	public static String bytesToHex(byte[] data) {

        StringBuilder sb = new StringBuilder();
        for (byte b : data) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();

    }
	
	public static String hexToAscii(String hexStr) {
		StringBuilder output = new StringBuilder("");
	     
	    for (int i = 0; i < hexStr.length(); i += 2) {
	        String str = hexStr.substring(i, i + 2);
	        output.append((char) Integer.parseInt(str, 16));
	    }
	    
	    return output.toString();
	}
	
	public static String hexToDec(String hex) {
		long v = Long.parseLong(hex, 16);
		return String.valueOf(v);
	}
	
	public static String decToHex(String dec) {

		Long intDec = Long.parseLong(dec);
		return Long.toHexString(intDec).toUpperCase();
	}
	
	public static String strToBit(String s) {
		int n = Integer.parseInt(s);
		
        int[] array = new int[8];
        int iattr = (int) ((byte) n & 0xFF);
        int bitWise = 1;
        for (int i = 0; i < 8; i++) {
               if ((bitWise & iattr) > 0) array[i] = 1;
               else  array[i] = 0;
         bitWise = (bitWise << 1) & 0xfe;
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < array.length; ++i) sb.append(array[7 - i]);
        return sb.toString();
   }
	
	public static byte[] hexStringToByteArray(String s) {
	    int len = s.length();
	    byte[] data = new byte[len / 2];
	    for (int i = 0; i < len; i += 2) {
	        data[i / 2] = (byte) ((Character.digit(s.charAt(i), 16) << 4)
	                             + Character.digit(s.charAt(i+1), 16));
	    }
	    return data;
	}
	
	public static byte[] decToBCDArray(long in) {
		long num = in;
		int digits = 0;

		long temp = num;
		while (temp != 0) {
			digits++;
			temp /= 10;
		}

		int byteLen = digits % 2 == 0 ? digits / 2 : (digits + 1) / 2;
		boolean isOdd = digits % 2 != 0;

		byte bcd[] = new byte[byteLen];

		for (int i = 0; i < digits; i++) {
			byte tmp = (byte) (num % 10);

			if (i == digits - 1 && isOdd)
				bcd[i / 2] = tmp;
			else if (i % 2 == 0)
				bcd[i / 2] = tmp;
			else {
				byte foo = (byte) (tmp << 4);
				bcd[i / 2] |= foo;
			}

			num /= 10;
		}

		for (int i = 0; i < byteLen / 2; i++) {
			byte tmp = bcd[i];
			bcd[i] = bcd[byteLen - i - 1];
			bcd[byteLen - i - 1] = tmp;
		}

		return bcd;
	}

	public static String bCDtoString(byte bcd) {
		StringBuffer sb = new StringBuffer();

		byte high = (byte) (bcd & 0xf0);
		high >>>= (byte) 4;
		high = (byte) (high & 0x0f);
		byte low = (byte) (bcd & 0x0f);

		sb.append(high);
		sb.append(low);

		return sb.toString();
	}
	
	public static String bCDtoString(byte[] bcd) {

		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < bcd.length; i++) {
			sb.append(bCDtoString(bcd[i]));
		}

		return sb.toString();
	}
	
	public static String htmlFilter(String in) {
		String value = in;

		if (value == null) {
			return null;
		}

		StringBuffer strBuff = new StringBuffer();

		for (int i = 0; i < value.length(); i++) {
			char c = value.charAt(i);
			switch (c) {
				case '<':
					strBuff.append("&lt;");
					break;
				case '>':
					strBuff.append("&gt;");
					break;
				case '&':
					strBuff.append("&amp;");
					break;
				case '"':
					strBuff.append("&quot;");
					break;
				case '\'':
					strBuff.append("&apos;");
					break;
				default:
					strBuff.append(c);
					break;
			}
		}

		value = strBuff.toString();
		value = value.replaceAll("\r\n", "\n");

		return value;
	}
	
	public static String removeHtmlFilter(String in) {
		
		String scriptRegex = "<(/)?[ ]*script[^>]*>";
	    Pattern pattern2 = Pattern.compile(scriptRegex);

	    String value = in;
	    
	    if(value != null) {
	            Matcher matcher2 = pattern2.matcher(value);
	            StringBuffer str = new StringBuffer(value.length());
	            while(matcher2.find()) {
	              matcher2.appendReplacement(str, Matcher.quoteReplacement(" "));
	            }
	            matcher2.appendTail(str);
	            value = str.toString();
	    }
	      
    	value = value.replaceAll("&lt;", "<");
    	value = value.replaceAll("&gt;", ">");
    	value = value.replaceAll("&amp;", "&");
    	value = value.replaceAll("&quot;", "\"");
    	value = value.replaceAll("&apos;", "\'");
		value = value.replaceAll("\r\n", "\n");
		
		return value;
	}
	
	public Model setUserinfo(Model model) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
		
		HashMap info = new HashMap();
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		JSONObject json = new JSONObject();
		
		if("anonymousUser".equals(auth.getPrincipal().toString())) {
			model.addAttribute("userid", "none");
			model.addAttribute("role", "anonymous");
		} else {

			LoginToken loginToken = (LoginToken)auth.getPrincipal();
			
			model.addAttribute("userid", loginToken.getUsername());
			//model.addAttribute("role", loginToken.getRole());
		}
		
		return model;
	}
	
	/**
	 * SHA256 암호화
	 */
	public static String encryptSHA256(String str){

		String sha = null;

		try{

			MessageDigest sh = MessageDigest.getInstance("SHA-256");
			sh.update(str.getBytes());
			byte byteData[] = sh.digest();
			StringBuffer sb = new StringBuffer();
			for(int i = 0 ; i < byteData.length ; i++){
				sb.append(Integer.toString((byteData[i]&0xff) + 0x100, 16).substring(1));
			}

			sha = sb.toString();

		}catch(NoSuchAlgorithmException e){
		}

		return sha;

	}
}
