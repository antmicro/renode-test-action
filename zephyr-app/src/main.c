#include <zephyr/version.h>
#include <stdio.h>

int main(void)
{
	printf("Hello World from Zephyr %s\n", KERNEL_VERSION_STRING);

	return 0;
}
