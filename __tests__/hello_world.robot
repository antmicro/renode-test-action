*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${LOG_TIMEOUT}                1

*** Test Cases ***
Should Log Hello World
    Create Log Tester         ${LOG_TIMEOUT}
    Execute Command           log "Hello World"
    Wait For Log Entry        Hello World