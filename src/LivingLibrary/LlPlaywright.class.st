Class {
	#name : #LlPlaywright,
	#superclass : #Object,
	#classVars : [
		'PythonInstance'
	],
	#category : #'LivingLibrary-Core'
}

{ #category : #initialization }
LlPlaywright class >> initialize [
	SessionManager default registerSystemClassNamed: self name
]

{ #category : #initialization }
LlPlaywright class >> shutDown: quitting [
	quitting ifFalse: [ ^ self ].

	[ PythonInstance stop ] on: Error do: [].
]

{ #category : #accessing }
LlPlaywright class >> start [
	| template |
	
	PythonInstance ifNotNil: [ ^ PythonInstance ].
	
	template := 'from playwright.sync_api import sync_playwright'.

	PythonInstance := PBApplication uniqueInstance newCommandStringFactory
    	script: template;
	    resultExpression: 'sync_playwright().start()';
	    sendAndWait.
]

{ #category : #accessing }
LlPlaywright class >> stop [
	PythonInstance ifNil: [ ^ self ].
	
	PythonInstance send: #stop.  
	PythonInstance := nil
]

{ #category : #accessing }
LlPlaywright class >> uniqueInstance [
	^ self new
]

{ #category : #accessing }
LlPlaywright >> gtDirFor: aView [
	<gtView>
	
	PythonInstance ifNil: [ ^ aView empty ].
	^ aView forward
		object: [ self pythonInstance ];
		view: #gtDirFor:
]

{ #category : #convenience }
LlPlaywright >> launch: browser isHeadless: aBoolean [
	"browser - e.g. firefox, chromium, webkit"
	| proxy |
	proxy:= self pythonInstance newCommandFactory
		<< (P3GCall target: self pythonInstance => browser => #launch  positionalArguments: nil keywordArguments: { #headless -> aBoolean } asDictionary);
		sendAndWait.
	^ LlPlaywrightBrowser on: proxy
]

{ #category : #actions }
LlPlaywright >> play: video [

	| template |
	template := 'from playwright.sync_api import sync_playwright

playwright = sync_playwright().start()
browser = playwright.{browser}.launch(headless=False)
page = browser.new_page()
page.goto("url")
frame = page.frame(url=r''*https://newrochelle.granicus.com/videos/*'') #this does give us a frame
locator = frame.locator(''video'')
locator.evaluate("node => node.play()")'.

	^ PBApplication uniqueInstance newCommandStringFactory
    addAllBindings: { 
        #url -> video url asString } asDictionary;
    script: template;
    resultExpression: '[ playwright, browser ]';
    sendAndWait.
]

{ #category : #convenience }
LlPlaywright >> pythonInstance [
	PythonInstance ifNil: [ self class start ].
	^ PythonInstance
]