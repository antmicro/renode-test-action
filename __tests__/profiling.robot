*** Variables ***
${UART}                       sysbus.usart2
${RTC_32KHZ}=  SEPARATOR=
...  """                                      ${\n}
...  using "platforms/cpus/stm32f4.repl"      ${\n}
...                                           ${\n}
...  rtc:                                     ${\n}
...  ${SPACE*4}wakeupTimerFrequency: 32000    ${\n}
...  """

*** Test Cases ***
Run Zephyr Hello World
    Execute Command           set bin @https://dl.antmicro.com/projects/renode/stm32f4_discovery--zephyr-hello_world.elf-s_515008-2180a4018e82fcbc8821ef4330c9b5f3caf2dcdb
    Execute Command           include @scripts/single-node/stm32f4_discovery.resc

    Create Terminal Tester    ${UART}

    Wait For Line On Uart     Booting Zephyr OS
    Wait For Line On Uart     Hello World! stm32f4_disco
