TRUNK=..
TARGET=$(TRUNK)/maven-targets/rngdoc2
SANDBOX=$(TRUNK)/rngdoc2-sandbox

all: $(TARGET)/rngdoc2-1.0-SNAPSHOT-jar-with-dependencies.jar

install: $(SANDBOX)/bin $(SANDBOX)/bin/rngdoc2 $(SANDBOX)/bin/rngdoc2-1.0-SNAPSHOT-jar-with-dependencies.jar

$(TARGET)/rngdoc2-1.0-SNAPSHOT-jar-with-dependencies.jar: 
	mvn package

$(SANDBOX)/bin:
	mkdir -p $@

$(SANDBOX)/bin/rngdoc2: rngdoc2
	cp $< $@
	chmod a+rx $@

$(SANDBOX)/bin/rngdoc2-1.0-SNAPSHOT-jar-with-dependencies.jar: $(TARGET)/rngdoc2-1.0-SNAPSHOT-jar-with-dependencies.jar
	cp $< $@
	chmod a+r $@

