#pragma once

#ifdef YOLODLL_EXPORTS
#if defined(_MSC_VER)
#define YOLODLL_API __declspec(dllexport) 
#else
#define YOLODLL_API __attribute__((visibility("default")))
#endif
#else
#if defined(_MSC_VER)
#define YOLODLL_API
#else
#define YOLODLL_API
#endif
#endif

#include <string>
#include <list>
#include <vector>
#include <tuple>

extern "C" YOLODLL_API void detectorSetConfigFilesAbsolutePath(std::string path);
extern "C" YOLODLL_API void detectorLoadData(std::string dataConfig);
extern "C" YOLODLL_API void detectorLoadModel(std::string cfgfile, std::string weightfile, void(*progress)(float));
extern "C" YOLODLL_API void detectorFree();

extern "C" YOLODLL_API void getDetectorClassNames(std::vector<std::string>& nameList);

extern "C" YOLODLL_API void getDetectResult(std::vector<std::tuple<int, float, float, float, float, float>>& result,
											std::string imagePath, float thresh, float hier_thresh);