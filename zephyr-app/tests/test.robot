*** Variables ***
${UART}                         sysbus.uart0

*** Test Cases ***
Should Run Zephyr App
    Execute Command             set bin @${CURDIR}/../build/zephyr/zephyr.elf
	Execute Script              scripts/single-node/hifive_unmatched.resc
	Create Terminal Tester      ${UART}

	Wait For Line On Uart       Hello World from Zephyr 3.7.0
