package com.kotc.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
 * <b>기능</b> :
 * <p>
 * 날짜 및 시간을 시스템으로부터 연산하는 클래스입니다.
 *
 * @author Administrator
 * @since 1.0
 * @see java.util.Date
 */
public class DateUtils {

	public static final int YEAR = 1;
	public static final int MONTH = 2;
	public static final int DATE = 3;
	public static final int MONTHFIRST = 4;
	public static final int MONTHEND = 5;

	
	public static String getDate() {
		long timeMils = getCurrentTimeMils();
		
		SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
		Date date = new Date(timeMils);
		String ctime = formatter.format (date);
		
		return ctime;
	}
	
	/**
	 * Unix 타임을 정해진 포맷으로 리턴
	 * @param unixtime
	 * @return
	 */
	public static String getDate(long timeMils) {
		SimpleDateFormat formatter = new SimpleDateFormat ( "yyyy-MM-dd HH:mm:ss", Locale.KOREA );
		Date date = new Date(timeMils);
		String ctime = formatter.format (date);
		
		return ctime;
	}

	public static long getCurrentTimeMils() {
		return Calendar.getInstance(Locale.KOREA).getTimeInMillis();
	}
	
	/**
	 * 특정 날짜에 대하여 요일을 구함(일 ~ 토)
	 * @param date
	 * @param dateType
	 * @return
	 * @throws Exception
	 */
	public static String getDateDay(String date, String dateType) throws Exception {
	    String day = "" ;
	     
	    SimpleDateFormat dateFormat = new SimpleDateFormat(dateType) ;
	    Date nDate = dateFormat.parse(date) ;
	     
	    Calendar cal = Calendar.getInstance() ;
	    cal.setTime(nDate);
	     
	    int dayNum = cal.get(Calendar.DAY_OF_WEEK) ;

	    switch(dayNum){
	        case 1: day = "일";
	        		break ;
	        case 2: day = "월";
    				break ;
	        case 3: day = "화";
    				break ;
	        case 4: day = "수";
					break ;
	        case 5: day = "목";
					break ;
	        case 6: day = "금";
					break ;
	        case 7: day = "토";
					break ;
	    }
	     
	    return day ;
	}
	
	/**
	 * <p>
	 * 현재 날짜와 시각을 yyyyMMdd 형태로 변환 후 return.
	 *
	 * @param null
	 * @return yyyyMMdd
	 * 
	 *         <pre>
	 *  - 사용 예
	 * String date = DateUtil.getYyyymmdd()
	 * </pre>
	 */
	public static String getYyyymmdd(Calendar cal) {
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "yyyy-MM-dd";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern, currentLocale);
		return formatter.format(cal.getTime());
	}

	/**
	 * <p>
	 * GregorianCalendar 객체를 반환함.
	 * 
	 * @param yyyymmdd
	 *            날짜 인수
	 * @return GregorianCalendar
	 * @see java.util.Calendar
	 * @see java.util.GregorianCalendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * Calendar cal = DateUtil.getGregorianCalendar(DateUtil.getCurrentYyyymmdd())
	 * </pre>
	 */
	public static GregorianCalendar getGregorianCalendar(String yyyymmdd) {

		int yyyy = Integer.parseInt(yyyymmdd.substring(0, 4));
		int mm = Integer.parseInt(yyyymmdd.substring(4, 6));
		int dd = Integer.parseInt(yyyymmdd.substring(6));

		GregorianCalendar calendar = new GregorianCalendar(yyyy, mm - 1, dd, 0,
				0, 0);

		return calendar;

	}

	/**
	 * <p>
	 * 현재 날짜와 시각을 yyyyMMddhhmmss 형태로 변환 후 return.
	 * 
	 * @param null
	 * @return yyyyMMddhhmmss
	 * @see java.util.Date
	 * @see java.util.Locale <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * String date = DateUtil.getCurrentDateTime()
	 * </pre>
	 */
	public static String getCurrentDateTime() {
		Date today = new Date();
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "yyyy-MM-dd HH:mm:ss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				currentLocale);
		return formatter.format(today);
	}

	/**
	 * <p>
	 * 현재 시각을 hhmmss 형태로 변환 후 return.
	 * 
	 * @param null
	 * @return hhmmss
	 * @see java.util.Date
	 * @see java.util.Locale <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 *   String date = DateUtil.getCurrentDateTime()
	 * </pre>
	 */
	public static String getCurrentTime() {
		Date today = new Date();
		Locale currentLocale = new Locale("KOREAN", "KOREA");
		String pattern = "HHmmss";
		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				currentLocale);
		return formatter.format(today);

	}

	/**
	 * <p>
	 * 현재 날짜를 yyyyMMdd 형태로 변환 후 return.
	 * 
	 * @param null
	 * @return yyyyMMdd *
	 *         <p>
	 * 
	 *         <pre>
	 *  - 사용 예
	 * String date = DateUtil.getCurrentYyyymmdd()
	 * </pre>
	 */
	public static String getCurrentYyyymmdd() {
		return getCurrentDateTime().substring(0, 8);
	}

	/**
	 * <p>
	 * 주로 일자를 구하는 메소드.
	 *
	 * @param yyyymm
	 *            년월
	 * @param week
	 *            몇번째 주
	 * @param pattern
	 *            리턴되는 날짜패턴 (ex:yyyyMMdd)
	 * @return 연산된 날짜
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * String date = DateUtil.getWeekToDay("200801" , 1, "yyyyMMdd")
	 * </pre>
	 */
	public static String getWeekToDay(String yyyymm, int pweek, String pattern) {
		int week = pweek;
		Calendar cal = Calendar.getInstance(Locale.FRANCE);

		int newyy = Integer.parseInt(yyyymm.substring(0, 4));
		int newmm = Integer.parseInt(yyyymm.substring(4, 6));
		int newdd = 1;

		cal.set(newyy, newmm - 1, newdd);

		// 임시 코드
		if (cal.get(cal.DAY_OF_WEEK) == cal.SUNDAY) {
			week = week - 1;
		}

		cal.add(Calendar.DATE,
				(week - 1)
						* 7
						+ (cal.getFirstDayOfWeek() - cal
								.get(Calendar.DAY_OF_WEEK)));

		SimpleDateFormat formatter = new SimpleDateFormat(pattern,
				Locale.FRANCE);

		return formatter.format(cal.getTime());

	}

	/**
	 * <p>
	 * 지정된 플래그에 따라 연도 , 월 , 일자를 연산한다.
	 *
	 * @param field
	 *            연산 필드
	 * @param amount
	 *            더할 수
	 * @param date
	 *            연산 대상 날짜
	 * @return 연산된 날짜
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * String date = DateUtil.getOpDate(java.util.Calendar.DATE , 1, "20080101")
	 * </pre>
	 */
	public static String getOpDate(int field, int amount, String pdate) {

		String date = pdate.replace("-", "");
		
		GregorianCalendar calDate = getGregorianCalendar(date);

		if (field == Calendar.YEAR) {
			calDate.add(GregorianCalendar.YEAR, amount);
		} else if (field == Calendar.MONTH) {
			calDate.add(GregorianCalendar.MONTH, amount);
		} else {
			calDate.add(GregorianCalendar.DATE, amount);
		}

		return getYyyymmdd(calDate);

	}

	/**
	 * <p>
	 * 입력된 일자를 더한 주를 구하여 return한다
	 * 
	 * @param yyyymmdd
	 *            년도별
	 * @param addDay
	 *            추가일
	 * @return 연산된 주
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * int date = DateUtil.getWeek(DateUtil.getCurrentYyyymmdd() , 0)
	 * </pre>
	 */
	public static int getWeek(String yyyymmdd, int addDay) {
		Calendar cal = Calendar.getInstance(Locale.FRANCE);
		int newyy = Integer.parseInt(yyyymmdd.substring(0, 4));
		int newmm = Integer.parseInt(yyyymmdd.substring(4, 6));
		int newdd = Integer.parseInt(yyyymmdd.substring(6, 8));

		cal.set(newyy, newmm - 1, newdd);
		cal.add(Calendar.DATE, addDay);

		int week = cal.get(Calendar.DAY_OF_WEEK);
		return week;
	}

	/**
	 * <p>
	 * 입력된 년월의 마지막 일수를 return 한다.
	 * 
	 * @param year
	 * @param month
	 * @return 마지막 일수
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * int date = DateUtil.getLastDayOfMon(2008 , 1)
	 * </pre>
	 */
	public static int getLastDayOfMon(int year, int month) {

		Calendar cal = Calendar.getInstance();
		cal.set(year, month, 1);
		return cal.getActualMaximum(Calendar.DAY_OF_MONTH);

	}// :

	/**
	 * <p>
	 * 입력된 년월의 마지막 일수를 return한다
	 * 
	 * @param year
	 * @param month
	 * @return 마지막 일수
	 *         <p>
	 * 
	 *         <pre>
	 *  - 사용 예
	 * int date = DateUtil.getLastDayOfMon("2008")
	 * </pre>
	 */
	public static int getLastDayOfMon(String yyyymm) {

		Calendar cal = Calendar.getInstance();
		int yyyy = Integer.parseInt(yyyymm.substring(0, 4));
		int mm = Integer.parseInt(yyyymm.substring(4)) - 1;

		cal.set(yyyy, mm, 1);
		return cal.getActualMaximum(Calendar.DAY_OF_MONTH);
	}

	/**
	 * 날짜 데이터 검증
	 * @param source
	 * @return
	 */
	public static boolean isValidDate(String psource) {
		String source = psource;
		boolean isValid = false;
		
		source = source.replaceAll("[^0-9]","");
		if(source.length() != 14) return false;
		
		String yy = source.substring(0, 4);
		String mm = source.substring(4, 6);
		String dd = source.substring(6, 8);
		String hh = source.substring(8, 10);
		String mi = source.substring(10, 12);
		String ss = source.substring(12, 14);
		
		if(!isCorrect(source.substring(0, 8))) return false;
		if(Integer.parseInt(hh) < 0 || Integer.parseInt(hh) > 24) return false;
		if(Integer.parseInt(mi) < 0 || Integer.parseInt(mi) > 59) return false;
		if(Integer.parseInt(ss) < 0 || Integer.parseInt(ss) > 59) return false;
		
		try{
			SimpleDateFormat  dateFormat = new  SimpleDateFormat("yyyyMMddHHmmss");
			dateFormat.parse(source);
			isValid = true;
			
		} catch(ParseException  e) {
			isValid = false;
		}
		
		return isValid;
	}
	
	/**
	 * <p>
	 * 입력된 날자가 올바른지 확인합니다.
	 * 
	 * @param yyyymmdd
	 * @return boolean
	 *         <p>
	 * 
	 *         <pre>
	 *  - 사용 예
	 * boolean b = DateUtil.isCorrect("20080101")
	 * </pre>
	 */
	public static boolean isCorrect(String yyyymmdd) {
		boolean flag = false;
		if (yyyymmdd.length() < 8)
			return false;
		try {
			int yyyy = Integer.parseInt(yyyymmdd.substring(0, 4));
			int mm = Integer.parseInt(yyyymmdd.substring(4, 6));
			int dd = Integer.parseInt(yyyymmdd.substring(6));
			flag = DateUtils.isCorrect(yyyy, mm, dd);
		} catch (Exception ex) {
			return false;
		}
		return flag;
	}// :

	/**
	 * <p>
	 * 입력된 날자가 올바른 날자인지 확인합니다.
	 * 
	 * @param yyyy
	 * @param mm
	 * @param dd
	 * @return boolean
	 *         <p>
	 * 
	 *         <pre>
	 *  - 사용 예
	 * boolean b = DateUtil.isCorrect(2008,1,1)
	 * </pre>
	 */
	public static boolean isCorrect(int yyyy, int mm, int dd) {
		if (yyyy < 0 || mm < 0 || dd < 0)
			return false;
		if (mm > 12 || dd > 31)
			return false;

		String year = "" + yyyy;
		String month = "00" + mm;
		String yearstr = year + month.substring(month.length() - 2);
		int endday = DateUtils.getLastDayOfMon(yearstr);

		if (dd > endday)
			return false;

		return true;

	}// :

	/**
	 * <p>
	 * 현재 일자를 입력된 type의 날짜로 반환합니다.
	 * 
	 * @param type
	 * @return String
	 * @see java.text.DateFormat <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * String date = DateUtil.getThisDay("yyyymmddhhmmss")
	 * </pre>
	 */
	public static String getThisDay(String type) {
		Date date = new Date();
		SimpleDateFormat sdf = null;

		try {
			if (type.toLowerCase().equals("yyyymmdd")) {
				sdf = new SimpleDateFormat("yyyyMMdd");
				return sdf.format(date);
			}
			if (type.toLowerCase().equals("yyyymmddhh")) {
				sdf = new SimpleDateFormat("yyyyMMddHH");
				return sdf.format(date);
			}
			if (type.toLowerCase().equals("yyyymmddhhmm")) {
				sdf = new SimpleDateFormat("yyyyMMddHHmm");
				return sdf.format(date);
			}
			if (type.toLowerCase().equals("yyyymmddhhmmss")) {
				sdf = new SimpleDateFormat("yyyyMMddHHmmss");
				return sdf.format(date);
			}
			if (type.toLowerCase().equals("yyyymmddhhmmssms")) {
				sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
				return sdf.format(date);
			} else {
				sdf = new SimpleDateFormat(type);
				return sdf.format(date);
			}
		} catch (Exception e) {
			return "[ ERROR ]: parameter must be 'YYYYMMDD', 'YYYYMMDDHH', 'YYYYMMDDHHSS'or 'YYYYMMDDHHSSMS'";
		}
	}

	/**
	 * <p>
	 * 입력된 일자를 '9999년 99월 99일' 형태로 변환하여 반환한다.
	 * 
	 * @param yyyymmdd
	 * @return String
	 *         <p>
	 * 
	 *         <pre>
	 *  - 사용 예
	 * String date = DateUtil.changeDateFormat("20080101")
	 * </pre>
	 */
	public static String changeDateFormat(String yyyymmdd) {
		String rtnDate = null;

		String yyyy = yyyymmdd.substring(0, 4);
		String mm = yyyymmdd.substring(4, 6);
		String dd = yyyymmdd.substring(6, 8);
		rtnDate = yyyy + " 년 " + mm + " 월 " + dd + " 일";

		return rtnDate;

	}

	/**
	 * <p>
	 * 두 날짜간의 날짜수를 반환(윤년을 감안함)
	 * 
	 * @param startDate
	 *            시작 날짜
	 * @param endDate
	 *            끝 날짜
	 * @return 날수
	 * @see java.util.GregorianCalendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * long date = DateUtil.getDifferDays("20080101","20080202")
	 * </pre>
	 */
	public static long getDifferDays(String pstartDate, String pendDate) {
		
		String startDate = pstartDate.replace("-", "");
		String endDate = pendDate.replace("-", "");

		GregorianCalendar calStartDate = getGregorianCalendar(startDate);
		GregorianCalendar calEndDate = getGregorianCalendar(endDate);
		long difer = (calEndDate.getTime().getTime() - calStartDate.getTime().getTime()) / 86400000;
		return difer;

	}
	
	public static long getDifferMinuites(String strDate) {
		long min = 0;
		
		try {
			Calendar cal = Calendar.getInstance(Locale.KOREA);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA );
			Date date = formatter.parse(strDate);
			cal.setTime(date);

			long logTime = cal.getTimeInMillis();
			long curTime = System.currentTimeMillis();
			long elapsedTime = curTime - logTime;
			
			min = elapsedTime/60000;
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return min;
	}

	public static long getDifferSeconds(String strDate) {
		long sec = 0;
		
		try {
			Calendar cal = Calendar.getInstance(Locale.KOREA);
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA );
			Date date = formatter.parse(strDate);
			cal.setTime(date);

			long logTime = cal.getTimeInMillis();
			long curTime = System.currentTimeMillis();
			long elapsedTime = curTime - logTime;
			
			sec = elapsedTime/1000;
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return sec;
	}
	
	public static long getDifferSeconds(String strDate1, String strDate2) {
		long sec = 0;
		
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.KOREA );

			Calendar cal1 = Calendar.getInstance(Locale.KOREA);
			Date date1 = formatter.parse(strDate1);
			cal1.setTime(date1);

			Calendar cal2 = Calendar.getInstance(Locale.KOREA);
			Date date2 = formatter.parse(strDate2);
			cal2.setTime(date2);

			long time1 = cal1.getTimeInMillis();
			long time2 = cal2.getTimeInMillis();
			long elapsedTime = time2 - time1;
			
			sec = elapsedTime/1000;
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return sec;
	}
	
	/**
	 * <p>
	 * 현재의 요일을 구한다.
	 * 
	 * @param
	 * @return 요일
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * int day = DateUtil.getDayOfWeek()
	 *  SUNDAY    = 1
	 *  MONDAY    = 2
	 *  TUESDAY   = 3
	 *  WEDNESDAY = 4
	 *  THURSDAY  = 5
	 *  FRIDAY    = 6
	 * </pre>
	 */
	public static int getDayOfWeek() {
		Calendar rightNow = Calendar.getInstance();
		int dayofweek = rightNow.get(Calendar.DAY_OF_WEEK);
		return dayofweek;
	}

	/**
	 * <p>
	 * 현재주가 올해 전체의 몇째주에 해당되는지 계산한다.
	 * 
	 * @param
	 * @return 요일
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * int day = DateUtil.getWeekOfYear()
	 * </pre>
	 */
	public static int getWeekOfYear() {
		Locale country = Locale.KOREA;
		Calendar rightNow = Calendar.getInstance(country);
		int weekofyear = rightNow.get(Calendar.WEEK_OF_YEAR);
		return weekofyear;
	}

	/**
	 * <p>
	 * 현재주가 현재월에 몇째주에 해당되는지 계산한다.
	 * 
	 * @param
	 * @return 요일
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * int day = DateUtil.getWeekOfMonth()
	 * </pre>
	 */
	public static int getWeekOfMonth() {
		Locale country = Locale.KOREA;
		Calendar rightNow = Calendar.getInstance(country);
		int weekofyear = rightNow.get(Calendar.WEEK_OF_MONTH);
		return weekofyear;
	}

	/**
	 * <p>
	 * 해당 p_date날짜에 Calendar 객체를 반환함.
	 * 
	 * @param p_date
	 * @return Calendar
	 * @see java.util.Calendar <p>
	 * 
	 *      <pre>
	 *  - 사용 예
	 * Calendar cal = DateUtil.getCalendarInstance(DateUtil.getCurrentYyyymmdd())
	 * </pre>
	 */
	public static Calendar getCalendarInstance(String pdate) {
		Locale country = Locale.KOREA;
		//Locale LOCALE_COUNTRY = Locale.FRANCE;
		Calendar retCal = Calendar.getInstance(country);

		if (pdate != null && pdate.length() == 8) {
			int year = Integer.parseInt(pdate.substring(0, 4));
			int month = Integer.parseInt(pdate.substring(4, 6)) - 1;
			int date = Integer.parseInt(pdate.substring(6));

			retCal.set(year, month, date);
		}
		return retCal;
	}

}