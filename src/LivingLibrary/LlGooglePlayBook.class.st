Class {
	#name : #LlGooglePlayBook,
	#superclass : #LlWebResource,
	#instVars : [
		'id'
	],
	#category : #'LivingLibrary-Flickr'
}

{ #category : #examples }
LlGooglePlayBook class >> example [
	<gtExample>
	^ self 
		given: []
		when: [ 
			self new
				title: 'Antifragile';
				author: MpPerson exampleNassimTaleb;
				id: '5fqbz_qGi0AC';
				yourself ]
		then: [ :book | book url asString should equal: 'https://play.google.com/books/reader?id=5fqbz_qGi0AC' ]
]

{ #category : #examples }
LlGooglePlayBook class >> fromLinkString: aString [
	^ self new
		id: (aString asUrl queryAt: #id);
		yourself
]

{ #category : #accessing }
LlGooglePlayBook >> id [
	^ id
]

{ #category : #accessing }
LlGooglePlayBook >> id: anObject [
	id := anObject
]

{ #category : #accessing }
LlGooglePlayBook >> url [
	^ 'https://play.google.com/books/reader' asUrl ? (#id -> self id)
]