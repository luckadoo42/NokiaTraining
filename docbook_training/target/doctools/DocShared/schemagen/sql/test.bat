rem Test script: use this to run the sql script and log how long it takes for a run, to log.txt

echo starting schema script run >>log.txt
time /t  >>log.txt
sqlplus motive/motive@system @schema2datamodelraw.sql test.xml
echo ending schema script run >>log.txt
time /t >>log.txt

pause