#define _POSIX_C_SOURCE 199309L

#include <unistd.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <limits.h>

#define SLEEP_MICROSECONDS 250
#define ITERATIONS 1000

int main(void) {
	struct timespec t_start, t_end;
	struct timespec ts_sleep = {
		.tv_sec = 0,
		.tv_nsec = SLEEP_MICROSECONDS * 1000  // 250us = 250_000 ns
	};

	uint64_t min_time = UINT64_MAX;
	uint64_t max_time = 0;
	uint64_t total_time = 0;

	for (int i = 1; i <= ITERATIONS; i++) {
		clock_gettime(CLOCK_MONOTONIC, &t_start);
		nanosleep(&ts_sleep, NULL);
		clock_gettime(CLOCK_MONOTONIC, &t_end);

		uint64_t elapsed = (t_end.tv_sec - t_start.tv_sec) * 1000000 + (t_end.tv_nsec - t_start.tv_nsec) / 1000;
		if (elapsed < min_time) min_time = elapsed;
		if (elapsed > max_time) max_time = elapsed;
		total_time += elapsed;
	}

	printf("usleep(250)  # 250 us\n");

	printf("\nran 1_000 times\n");

	printf("\nStats in us\n");
	printf("min: %lu\n", min_time);
	printf("mean: %lu\n", total_time / ITERATIONS);
	printf("max: %lu\n", max_time);

	return 0;
}
