## Using Maps
Common use case: `Map<ID, SObject>`

#### Get a list of contacts
```apex
List<Contact> contacts = [SELECT ID, Name FROM Contact LIMIT 50];
```
#### Map constructor will automatically key each contact by its ID
```apex
Map<ID, Contact> contactMap = new Map<ID, Contact>(contacts);
```

#### Or combine two lines above into one line - this is a very common design pattern
```apex
Map<ID, Contact> contactMape = new Map<ID, Contact>([SELECT ID, Name FROM Contact limit  50]);
```
## Use a Map to obtain a set of IDs
#### 1. Initialize a set of contacts and insert them into the database, where other triggers and processes may modify them.  The insert operation populates the ID field.
```apex
List<Contact> contacts = new List<Contact>();
insert contacts;
```
#### 2. Build a Map to the Contacts the key will be the contact ID
```apex
Map<ID, Contact> contactMap = new Map<ID, Contact>(contacts);
```
#### 3. Retrieve the current values of those contacts filtering on the set (the IDs) of the previously inserted contacts
```apex 
List<Contact> currentContacts = [SELECT ID, Name FROM Contact WHERE ID in :contactMap.keyset()];
```
