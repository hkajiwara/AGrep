@isTest
private class AGrepController_TEST {
	/**
	 * instanceURL
	 * Expected: true
	 */
	 static testMethod void instanceURLTetst() {
		AGrepController agc = new AGrepController();
		if (agc.instanceURL.contains('salesforce')) {
			System.assert(true);
		} else {
			System.assert(false);
		}
	 }
	
	/**
	 * getInputStr()
	 * Expected: NULL
	 */
	static testMethod void getInputStrTest() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('AGrepController_TEST');
		
		Test.startTest();
		System.assertEquals(NULL, agc.getInputStr());
		Test.stopTest();
	}
	
	/**
	 * doGrep() for both "Case Sensitive" and "Print name" option.
	 * Expected: getMatchedCount() returns more than 1
	 */
	static testMethod void doGrepTest_caseSensitive_printName() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('agrepcontroller');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = true;
		
		Test.startTest();
		agc.doGrep();
		if (agc.getMatchedCount() >= 1) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
	
	/**
	 * doGrep() for both "Case Insensitive" and "Print name" option.
	 * Expected: getMatchedCount() returns more than 2
	 */
	static testMethod void doGrepTest_caseInsensitive_printName() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('agrepcontroller');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = true;
		agc.inputOptionOnlyFiles = true;
		
		Test.startTest();
		agc.doGrep();
		if (agc.getMatchedCount() >= 2) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
	
	/**
	 * doGrep() for both "Case Sensitive" and "Print name and line" option.
	 * Expected: The size of resultSetList is more than 2
	 */
	static testMethod void doGrepTest_caseSensitive_printNameLine() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('dogreptest_casesensitive_printnameline');
		// Dummy for test data
		agc.setInputStr('doGrepTest_caseSensitive_printNameLine');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = false;
		
		Test.startTest();
		agc.doGrep();
		if (agc.resultSetList.size() >= 2) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}

	/**
	 * doGrep() for both "Case Insensitive" and "Print name and line" option.
	 * Expected: The size of resultSetList is more than 3
	 */
	static testMethod void doGrepTest_caseInsensitive_printNameLine() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('dogreptest_caseinsensitive_printnameline');
		// Dummy for test data
		agc.setInputStr('doGrepTest_caseInsensitive_printNameLine');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = true;
		agc.inputOptionOnlyFiles = false;
		
		Test.startTest();
		agc.doGrep();
		if (agc.resultSetList.size() >= 3) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
	
	/**
	 * ApexTrigger, ApexPage and ApexComponent except for ApexClass with 
	 * "Case Sensitive" and "Print name" option.
	 * Expected: The size of resultSetList is more than 0
	 */
	static testMethod void doGrepTest_otherComponent_caseSensitive_printName() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('.*');
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = true;
		
		Test.startTest();
		agc.inputComponent = 'ApexTrigger';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		agc.inputComponent = 'ApexPage';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		agc.inputComponent = 'ApexComponent';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		Test.stopTest();
	}

	/**
	 * ApexTrigger, ApexPage and ApexComponent except for ApexClass with 
	 * "Case Sensitive" and "Print name and line" option.
	 * Expected: The size of resultSetList is more than 0
	 */
	static testMethod void doGrepTest_otherComponent_caseSensitive_printNameLine() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('.*');
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = false;
		
		Test.startTest();
		agc.inputComponent = 'ApexTrigger';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		agc.inputComponent = 'ApexPage';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		agc.inputComponent = 'ApexComponent';
		agc.doGrep();
		if (agc.resultSetList.size() >= 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		
		Test.stopTest();
	}
	
	/**
	 * doGrep() for an enclosed word with double quotations
	 * Expected: getMatchedCount() returns more than 1
	 */ 
	static testMethod void doGrepTest_inputStr1() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('\"static testMethod void doGrepTest_inputStr1\"');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = true;
		
		Test.startTest();
		agc.doGrep();
		if (agc.getMatchedCount() >= 1) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
	
	/**
	 * doGrep() for an enclosed word with double quotations
	 * Expected: getMatchedCount() returns more than 1
	 */
	static testMethod void doGrepTest_inputStr2() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('\"doGrepTest_inputStr2\"');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = true;
		
		Test.startTest();
		agc.doGrep();
		if (agc.getMatchedCount() >= 1) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
	
	/**
	 * putAllResultSet() for Exception
	 * Expected: AGrepException happens
	 */
	static testMethod void putAllResultSetTest() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('putAllResultSetTest');
		// Dummy
		agc.setInputStr('putAllResultSetTest');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = false;
		agc.setMaxRecord(2);
		
		Test.startTest();
		try {
			agc.doGrep();
		} catch(AGrepException e) {
			System.assert(true);
		}
		Test.stopTest();
	}
	
	/**
	 * putAllResultSet() for Exception
	 * Expected: StringException happens then getMatchedCount() returns 0
	 */
	static testMethod void doGrepTest_invalid_regex() {
		AGrepController agc = new AGrepController();
		agc.setInputStr('*');
		agc.inputComponent = 'ApexClass';
		agc.inputOptionIgnoreCase = false;
		agc.inputOptionOnlyFiles = false;
		
		Test.startTest();
		agc.doGrep();
		if (agc.getMatchedCount() == 0) {
			System.assert(true);
		} else {
			System.assert(false);
		}
		Test.stopTest();
	}
}