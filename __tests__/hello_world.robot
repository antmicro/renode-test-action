*** Variables ***
${LOG_TIMEOUT}                1

*** Test Cases ***
Should Log Hello World
    Create Log Tester         ${LOG_TIMEOUT}
    Execute Command           log "Hello World"
    Wait For Log Entry        Hello World
