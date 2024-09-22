/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	uint32_t col, row;
	FILE *file = fopen(filename, "r");
	if (file == NULL) {
		return NULL;
	}
	char tmp[4];
	fscanf(file, "%s", tmp);
	fscanf(file, "%u %u", &col, &row);
	fscanf(file, "%s", tmp);

	Image *img = malloc(sizeof(Image));
	img->cols = col;
	img->rows = row;
	img->image = malloc(sizeof(Color *) * col * row);

	Color **colorPointer = img->image;

	uint8_t r, g, b;
	while (fscanf(file, "%hhu %hhu %hhu", &r, &g, &b) == 3) {
		*colorPointer = malloc(sizeof(Color));
		(*colorPointer)->R = r;
		(*colorPointer)->G = g;
		(*colorPointer)->B = b;
		colorPointer++;
	}

	fclose(file);

	return img;
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	printf("P3\n");
	printf("%d %d\n", image->cols, image->rows);
	printf("255\n");

	Color **colorPointer = image->image;

	for (int i = 0; i < image->rows; i++) {
		for (int j = 0 ; j < image->cols; j++) {
			if (j != 0) {
				printf("   ");
			}

			printf("%3d %3d %3d", (*colorPointer)->R, (*colorPointer)->G, (*colorPointer)->B);
			colorPointer++;
		}
		printf("\n");
	}
}

//Frees an image
void freeImage(Image *image)
{
	Color **color = image->image;
	for (int i = 0; i < image->cols * image->rows; i++) {
		free(*color);
		color++;
	}
	free(image->image);
	free(image);
}