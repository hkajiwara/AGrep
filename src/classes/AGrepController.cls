/**
 * AGrepController
 */
public class AGrepController {
	private List<String> inputKeyList;
	private Integer maxRecord;
	
	public transient List<ResultSet> resultSetList{get; set;}
	public String inputStr;
	public Integer matchedCount;
	public String inputComponent {get; set;}
	public String inputOptionIgnoreCase {get; set;}
	public String inputOptionOnlyFiles {get; set;}
	public Boolean isSearched {get; set;}
	public String instanceURL {
		get {
			return URL.getSalesforceBaseUrl().toExternalForm();
		} set;
	}
	
	/**
	 * Constructor.
	 */
	public AGrepController() {
		this.inputComponent = AGrepConfig.APEX_CLASS;
		this.inputOptionIgnoreCase = '';
		this.inputOptionOnlyFiles = 'l';
		this.matchedCount = 0;
		this.maxRecord = AGrepConfig.MAX_RECORD;
		this.isSearched = false;
	}
	
	/**
	 * Execute grep search.
	 */
	public PageReference doGrep() {
		init();
		List<SObject> targetComponentList = getTargetComponentList();
		// for earch target component
		for (Integer i = 0 ; i < targetComponentList.size(); i++) {
			String targetStr = eliminateLineBreak(targetComponentList.get(i));
			Boolean isAllMatch = false;
			// for earch input search key
			for (String inputKey : inputKeyList) {
				if (isMatched(inputKey, targetStr)) {
					isAllMatch = true;
				} else {
					isAllMatch = false;
					break;
				}
			}
			
			if (isAllMatch) {
				matchedCount++;
				if (inputOptionOnlyFiles != NULL) {
					putResultSet(targetComponentList.get(i));
				} else {
					try {
						putAllResultSet(targetComponentList.get(i));
					} catch(AGrepException a) {
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AGrepConfig.MSG01_SUMMARY, AGrepConfig.MSG01_DETAIL));
						return NULL;
					}
				}
			}
			// Clear component
			targetComponentList.set(i, NULL);
		}
		return null;
	}
	
	/**
	 * Initialize.
	 */
	private void init() {
		this.matchedCount = 0;
		this.isSearched = true;
		this.resultSetList = new List<resultSet>();
	}
	
	/**
	 * Get records of earch component.
	 */
	private List<SObject> getTargetComponentList() {
		List<SObject> targetComponentList = new List<SObject>();
		try {
			if (inputComponent == AGrepConfig.APEX_CLASS || inputComponent == AGrepConfig.APEX_TRIGGER) {
				targetComponentList = Database.query(AGrepConfig.QUERY_APEX + String.escapeSingleQuotes(inputComponent));
			} else if (inputComponent == AGrepConfig.APEX_PAGE || inputComponent == AGrepConfig.APEX_COMPONENT) {
				targetComponentList = Database.query(AGrepConfig.QUERY_PAGE + String.escapeSingleQuotes(inputComponent));
			} else {
				// ToDo
			}
		} catch (QueryException e) {
			System.debug(e);
		}
		return targetComponentList;
	}
	
	/**
	 * Eliminate line break.
	 */
	private String eliminateLineBreak(SObject targetObject) {
		String eliminatedStr = '';
		
		if (inputComponent == AGrepConfig.APEX_CLASS) {
			eliminatedStr = ((ApexClass)targetObject).Body.replaceAll(AGrepConfig.LINEBREAK,'');
		} else if (inputComponent == AGrepConfig.APEX_TRIGGER) {
			eliminatedStr = ((ApexTrigger)targetObject).Body.replaceAll(AGrepConfig.LINEBREAK,'');
		} else if (inputComponent == AGrepConfig.APEX_PAGE) {
			eliminatedStr = ((ApexPage)targetObject).Markup.replaceAll(AGrepConfig.LINEBREAK,'');
		} else if (inputComponent == AGrepConfig.APEX_COMPONENT) {
			eliminatedStr = ((ApexComponent)targetObject).Markup.replaceAll(AGrepConfig.LINEBREAK,'');
		} else {
			// ToDo
		}
		return eliminatedStr;
	}
	
	/**
	 * Search 
	 */
	private Boolean isMatched(String key, String target) {
		if (inputOptionIgnoreCase == NULL) {
			inputOptionIgnoreCase = '';
		}		
		if (Pattern.matches('.*(?' + inputOptionIgnoreCase + ')' + key + '.*', target)) {
			return true;
		} else {
			return false;
		}
	}
	
	
	/**
	 * Put only the matched id and name to the map
	 */
	private void putResultSet(SObject targetObject) {
		String targetId = '';
		String targetName = '';

		if (inputComponent == AGrepConfig.APEX_CLASS) {
			targetId = ((ApexClass)targetObject).Id;
			targetName = ((ApexClass)targetObject).Name;
		} else if (inputComponent == AGrepConfig.APEX_TRIGGER) {
			targetId = ((ApexTrigger)targetObject).Id;
			targetName = ((ApexTrigger)targetObject).Name;
		} else if (inputComponent == AGrepConfig.APEX_PAGE) {
			targetId = ((ApexPage)targetObject).Id;
			targetName = ((ApexPage)targetObject).Name;			
		} else if (inputComponent == AGrepConfig.APEX_COMPONENT) {
			targetId = ((ApexComponent)targetObject).Id;
			targetName = ((ApexComponent)targetObject).Name;	
		} else {
			// ToDo
		}
		
		ResultSet rds = new ResultSet();
		rds.targetComponentId = targetId;
		rds.targetComponentName = targetName;
		rds.lineMap.put(NULL, '');
		resultSetList.add(rds);
	}
	
	/**
	 * Put the matched line to the map
	 */
	private void putAllResultSet(SObject targetObject) {
		Integer lineNumber = 1;
		String targetLine = '';
		String targetId = '';
		String targetName = '';

		if (inputComponent == AGrepConfig.APEX_CLASS) {
			targetLine = ((ApexClass)targetObject).Body;
			targetId = ((ApexClass)targetObject).Id;
			targetName = ((ApexClass)targetObject).Name;
		} else if (inputComponent == AGrepConfig.APEX_TRIGGER) {
			targetLine = ((ApexTrigger)targetObject).Body;
			targetId = ((ApexTrigger)targetObject).Id;
			targetName = ((ApexTrigger)targetObject).Name;
		} else if (inputComponent == AGrepConfig.APEX_PAGE) {
			targetLine = ((ApexPage)targetObject).Markup;
			targetId = ((ApexPage)targetObject).Id;
			targetName = ((ApexPage)targetObject).Name;			
		} else if (inputComponent == AGrepConfig.APEX_COMPONENT) {
			targetLine = ((ApexComponent)targetObject).Markup;
			targetId = ((ApexComponent)targetObject).Id;
			targetName = ((ApexComponent)targetObject).Name;	
		} else {
			// ToDo
		}

		// for earch line
		for (String line : targetLine.split(AGrepConfig.LINEBREAK) ) {
			for (String inputKey : inputKeyList) {
				if (isMatched(inputKey, line)) {
					ResultSet rds = new ResultSet();	
					rds.targetComponentId = targetId;
					rds.targetComponentName = targetName;
					rds.lineMap.put(lineNumber, line);
					resultSetList.add(rds);
					
					if (resultSetList.size() > maxRecord) {
						throw new AGrepException(AGrepConfig.MSG01_EXP);
					}
				}
			}
			lineNumber++;
		}
	}
	
	/**
	 * Getter for inputStr
	 */
	public String getInputStr() {
		return this.inputStr;
	}
	
	/**
	 * Setter for inputStr
	 */
	public void setInputStr(String str) {
		inputKeyList = new List<String>();
		
		// Parse input string
		String tmpStr = '';
		for (String word : str.split(AGrepConfig.WHITESPACE)) {
			if (word.indexOf('"') == 0 && word.lastIndexOf('"') == word.length()-1) {
				inputKeyList.add(escapteString(word.replace('"', '')));
			} else if (word.indexOf('"') == 0) {
				tmpStr += word.replace('"', '') + AGrepConfig.WHITESPACE;
			} else if (word.lastIndexOf('"') == word.length()-1) {
				tmpStr += word.replace('"', '');
				inputKeyList.add(escapteString(tmpStr));
				tmpStr = '';
			} else {
				if (tmpStr != '') {
					tmpStr += word + AGrepConfig.WHITESPACE;
				} else {
					inputKeyList.add(escapteString(word));
				}
			}
		}
	}
	
	/**
	 * Escapape input string
	 */
	private String escapteString(String str) {
		String escaptedStr = str;
		for (String escapeStr : (AGrepConfig.ESCAPESTRING).split(',')) {
			escaptedStr = escaptedStr.replace(escapeStr, '\\' + escapeStr);
		}		
		return escaptedStr;
	}
	
	/**
	 * Getter for matchedCount
	 */
	public Integer getMatchedCount() {
		return this.matchedCount;
	}
	
	/**
	 * Setter for maxRecord
	 */
	public void setMaxRecord(Integer mr) {
		this.maxRecord = mr;
	}
	
	/**
	 * Result set class
	 */
	public class ResultSet {
		public Id targetComponentId{get; set;}
		public String targetComponentName{get; set;}
		public Map<Integer, String> lineMap{get; set;}
		
		public ResultSet() {
			lineMap = new Map<Integer, String>();
		}
	}
}