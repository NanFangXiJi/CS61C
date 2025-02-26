#include <time.h>
#include <stdio.h>
#include <x86intrin.h>
#include "simd.h"

long long int sum(int vals[NUM_ELEMS]) {
	clock_t start = clock();

	long long int sum = 0;
	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS; i++) {
			if(vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	long long int sum = 0;

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		for(unsigned int i = 0; i < NUM_ELEMS / 4 * 4; i += 4) {
			if(vals[i] >= 128) sum += vals[i];
			if(vals[i + 1] >= 128) sum += vals[i + 1];
			if(vals[i + 2] >= 128) sum += vals[i + 2];
			if(vals[i + 3] >= 128) sum += vals[i + 3];
		}

		//This is what we call the TAIL CASE
		//For when NUM_ELEMS isn't a multiple of 4
		//NONTRIVIAL FACT: NUM_ELEMS / 4 * 4 is the largest multiple of 4 less than NUM_ELEMS
		for(unsigned int i = NUM_ELEMS / 4 * 4; i < NUM_ELEMS; i++) {
			if (vals[i] >= 128) {
				sum += vals[i];
			}
		}
	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return sum;
}

long long int sum_simd(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);		// This is a vector with 127s in it... Why might you need this?
	long long int result = 0;				   // This is where you should put your final result!
	/* DO NOT DO NOT DO NOT DO NOT WRITE ANYTHING ABOVE THIS LINE. */
	
	int* _marray __attribute__ ((aligned (16))) = calloc(4, sizeof(int));

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		__m128i inner_sum = _mm_setzero_si128();

		size_t i = 0;
		for (; i + 4 <= NUM_ELEMS; i += 4) {
			__m128i next4 = _mm_loadu_si128((__m128i_u*)(vals + i));
			next4 = _mm_and_si128(next4, _mm_cmpgt_epi32(next4, _127));
			inner_sum = _mm_add_epi32(inner_sum, next4);
		}

		_mm_store_si128((__m128i*)_marray, inner_sum);

		result += _marray[0];
		result += _marray[1];
		result += _marray[2];
		result += _marray[3];

		while (i < NUM_ELEMS) {
			result += vals[i] > 127 ? vals[i] : 0;
			i++;
		}

	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}

long long int sum_simd_unrolled(int vals[NUM_ELEMS]) {
	clock_t start = clock();
	__m128i _127 = _mm_set1_epi32(127);
	long long int result = 0;
	int* _marray __attribute__ ((aligned (16))) = calloc(4, sizeof(int));

	for(unsigned int w = 0; w < OUTER_ITERATIONS; w++) {
		__m128i inner_sum = _mm_setzero_si128();

		size_t i = 0;
		for (; i + 16 <= NUM_ELEMS; i += 16) {
			__m128i next4 = _mm_loadu_si128((__m128i_u*)(vals + i));
			next4 = _mm_and_si128(next4, _mm_cmpgt_epi32(next4, _127));
			inner_sum = _mm_add_epi32(inner_sum, next4);
			next4 = _mm_loadu_si128((__m128i_u*)(vals + i + 4));
			next4 = _mm_and_si128(next4, _mm_cmpgt_epi32(next4, _127));
			inner_sum = _mm_add_epi32(inner_sum, next4);
			next4 = _mm_loadu_si128((__m128i_u*)(vals + i + 8));
			next4 = _mm_and_si128(next4, _mm_cmpgt_epi32(next4, _127));
			inner_sum = _mm_add_epi32(inner_sum, next4);
			next4 = _mm_loadu_si128((__m128i_u*)(vals + i + 12));
			next4 = _mm_and_si128(next4, _mm_cmpgt_epi32(next4, _127));
			inner_sum = _mm_add_epi32(inner_sum, next4);
		}

		_mm_store_si128((__m128i*)_marray, inner_sum);

		result += _marray[0];
		result += _marray[1];
		result += _marray[2];
		result += _marray[3];

		while (i < NUM_ELEMS) {
			result += vals[i] > 127 ? vals[i] : 0;
			i++;
		}

	}
	clock_t end = clock();
	printf("Time taken: %Lf s\n", (long double)(end - start) / CLOCKS_PER_SEC);
	return result;
}