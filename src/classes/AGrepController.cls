/**
 * AGrepController
 * @author Hiroki Kajiwara
 */
public class AGrepController {
	private List<String> inputKeyList;
	private Integer maxRecord;
	private Integer maxScript;
	private Double maxScriptRatio;
	
	public transient List<ResultSet> resultSetList{get; set;}
	public String inputStr;
	public Integer matchedCount;
	public String inputComponent {get; set;}
	public Boolean inputOptionIgnoreCase {get; set;}
	public Boolean inputOptionOnlyFiles {get; set;}
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
		this.inputOptionIgnoreCase = false;
		this.inputOptionOnlyFiles = true;
		this.matchedCount = 0;
		this.maxRecord = AGrepConfig.MAX_RECORD;
		this.maxScript = (Integer)(Limits.getLimitScriptStatements() * AGrepConfig.MAX_SCRIPT_RATIO);
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
			String targetStr = getComponentBody(targetComponentList.get(i));
			Boolean isAllMatch = false;
			
			try {
				// for earch input search key
				for (String inputKey : inputKeyList) {
					if (isMatched(inputKey, targetStr)) {
						isAllMatch = true;
					} else {
						isAllMatch = false;
						break;
					}
				}
				
				System.debug('zzz :' + Limits.getScriptStatements());
				
				if (isAllMatch) {
					matchedCount++;
					if (inputOptionOnlyFiles) {
						putResultSet(targetComponentList.get(i));
					} else {
						putAllResultSet(targetComponentList.get(i));
					}
				}
			} catch (StringException e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getTypeName(), e.getMessage()));
				return NULL;
			} catch(AGrepException e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, AGrepConfig.AGPEXP_SUMMARY, e.getMessage()));
				return NULL;
			}
			// Clear component
			targetComponentList.set(i, NULL);
		}
		return NULL;
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
	 * Get Body or Markup of component.
	 */
	private String getComponentBody(SObject targetObject) {
		String componentBody = '';
		
		if (inputComponent == AGrepConfig.APEX_CLASS) {
			componentBody = ((ApexClass)targetObject).Body;
		} else if (inputComponent == AGrepConfig.APEX_TRIGGER) {
			componentBody = ((ApexTrigger)targetObject).Body;
		} else if (inputComponent == AGrepConfig.APEX_PAGE) {
			componentBody = ((ApexPage)targetObject).Markup;
		} else if (inputComponent == AGrepConfig.APEX_COMPONENT) {
			componentBody = ((ApexComponent)targetObject).Markup;
		} else {
			// ToDo
		}
		return componentBody;
	}

	/**
	 * Judge whether the input key is matched to the target string.
	 */
	private Boolean isMatched(String key, String target) {
		Boolean matched = false;		
		Pattern ptn;
		if (inputOptionIgnoreCase) {
			ptn = Pattern.compile('(?im)' + key);
		} else {
			ptn = Pattern.compile('(?m)' + key);
		}
		Matcher mtch = ptn.matcher(target);
		
		while (mtch.find()) {
			matched = true;
			if (Limits.getScriptStatements() > maxScript) {
				// throw Exception due too many matched results
				throw new AGrepException(AGrepConfig.AGPEXP_CAUSE01);
			}
		}
		return matched;
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
		
		if (resultSetList.size() > maxRecord) {
			// throw Exception due too many matched records
			throw new AGrepException(AGrepConfig.AGPEXP_CAUSE02);
		}
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
						// throw Exception due too many matched records
						throw new AGrepException(AGrepConfig.AGPEXP_CAUSE02);
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
		/* Obsolute
		String tmpStr = '';
		for (String word : str.split(AGrepConfig.WHITESPACE)) {
			if (word.indexOf('"') == 0 && word.lastIndexOf('"') == word.length()-1) {
				inputKeyList.add(word.replace('"', ''));
			} else if (word.indexOf('"') == 0) {
				tmpStr += word.replace('"', '') + AGrepConfig.WHITESPACE;
			} else if (word.lastIndexOf('"') == word.length()-1) {
				tmpStr += word.replace('"', '');
				inputKeyList.add(tmpStr);
				tmpStr = '';
			} else {
				if (tmpStr != '') {
					tmpStr += word + AGrepConfig.WHITESPACE;
				} else {
					inputKeyList.add(word);
				}
			}
		}
		*/
		
		inputKeyList.add(str);
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
	 * Setter for maxScriptRatio
	 */
	public void setMaxScriptRatio(Double msr) {
		this.maxScriptRatio = msr;
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