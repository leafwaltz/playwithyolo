#pragma once

#include "box.h"
#include "network.h"

typedef struct
{
	list *options;
	char **names;
	network net;
	char* config_files_absolute_path;
}detector;

typedef struct
{
	detection* results;
	int result_num;
}detect_result;

#ifdef __cplusplus 
extern "C" {
#endif

	extern void detector_loaded_test();

	extern void detector_set_config_files_absolute_path(detector* det, char* path);

	extern void detector_load_data(detector* det, char *datacfg);

	extern void detector_load_model(detector* det, char *cfgfile, char *weightfile, void(*progress)(float));

	extern detect_result detector_detect(detector* det, char *filename, float thresh, float hier_thresh);

	extern void detector_free(detector* det);

	extern void detect_result_free(detect_result* result);

#ifdef __cplusplus 
}
#endif