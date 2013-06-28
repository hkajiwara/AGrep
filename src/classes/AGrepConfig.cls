/**
 * AGrepConfig
 * @author Hiroki Kajiwara
 */
public with sharing class AGrepConfig {
	public static final String WHITESPACE 	= ' ';
	public static final String LINEBREAK		= '\n';
	public static final String APEX_CLASS 	= 'ApexClass';
	public static final String APEX_TRIGGER 	= 'ApexTrigger';
	public static final String APEX_PAGE 		= 'ApexPage';
	public static final String APEX_COMPONENT = 'ApexComponent';
	public static final String QUERY_APEX 	= 'SELECT Id, Name, Body FROM ';
	public static final String QUERY_PAGE 	= 'SELECT Id, Name, Markup FROM ';
	public static final String STREXP_SUMMARY	= 'Invalid regex.';
	public static final String STREXP_DETAIL	= 'The input string contains invalid regex.';
	public static final String AGPEXP_SUMMARY	= 'AGrepException occurred.';
	public static final String AGPEXP_CAUSE01	= 'The result has not been completed due to too many mached results. Please GREP again with the key to lower the selectivity or use \"Case sensitive\" and \"Print name\" option.';
	public static final String AGPEXP_CAUSE02	= 'The result has not been completed due to too many mached records. Please GREP again with the key to lower the selectivity or use \"Case sensitive\" and \"Print name\" option.';
	public static final Integer MAX_RECORD	= 1900;
	public static final Double MAX_SCRIPT_RATIO	= 0.9995;
}