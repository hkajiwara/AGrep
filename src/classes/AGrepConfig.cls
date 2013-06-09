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
	public static final String AGPEXP_SUMMARY	= 'Too many matched lines.';
	public static final String AGPEXP_DETAIL	= 'The result has not been completed. Please search again with the key to lower the selectivity or use \"Case sensitive\" and \"Print name\" option.';
	public static final Integer MAX_RECORD	= 1950;
}