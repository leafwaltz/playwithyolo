#include "detector_class.hpp"
#include "detector.h"
#include "box.h"

// compare to sort detection** by bbox.x
int compare_by_lefts(const void *a_ptr, const void *b_ptr) 
{
	const detection_with_class* a = (detection_with_class*)a_ptr;
	const detection_with_class* b = (detection_with_class*)b_ptr;
	const float delta = (a->det.bbox.x - a->det.bbox.w / 2) - (b->det.bbox.x - b->det.bbox.w / 2);
	return delta < 0 ? -1 : delta > 0 ? 1 : 0;
}

// compare to sort detection** by best_class probability 
int compare_by_probs(const void *a_ptr, const void *b_ptr) 
{
	const detection_with_class* a = (detection_with_class*)a_ptr;
	const detection_with_class* b = (detection_with_class*)b_ptr;
	float delta = a->det.prob[a->best_class] - b->det.prob[b->best_class];
	return delta < 0 ? -1 : delta > 0 ? 1 : 0;
}

class YoloDetector
{
public:

	~YoloDetector() 
	{
	}

	static YoloDetector& globalInstance()
	{
		static YoloDetector instance;
		return instance;
	}

	std::vector<std::string> getClassNames() const
	{
		return classNameList_;
	}
	
	void setConfigFilesAbsolutePath(std::string path)
	{
		if(path.empty())
			detector_set_config_files_absolute_path(&detector_, NULL);
		else
		{
			char* pathTemp = new char[path.size() + 1];
			memcpy(pathTemp, path.c_str(), sizeof(char)*path.size());
			pathTemp[path.size()] = '\0';
			detector_set_config_files_absolute_path(&detector_, pathTemp);
			delete[] pathTemp;
		}
	}

	void loadData(std::string dataConfig)
	{
		char* pathTemp = new char[dataConfig.size() + 1];
		memcpy(pathTemp, dataConfig.c_str(), sizeof(char)*dataConfig.size());
		pathTemp[dataConfig.size()] = '\0';
		detector_load_data(&detector_, pathTemp);
		delete[] pathTemp;

		char** p = detector_.names;

		while (*p != NULL)
		{
			classNameList_.push_back(std::string(*p));
			p++;
		}
	}

	void loadModel(std::string configFilePath, std::string weightFilePath, void(*progress)(float))
	{
		char* cfgfile = new char[configFilePath.size() + 1];
		memcpy(cfgfile, configFilePath.c_str(), sizeof(char)*configFilePath.size());
		cfgfile[configFilePath.size()] = '\0';

		char* weightfile = new char[weightFilePath.size() + 1];
		memcpy(weightfile, weightFilePath.c_str(), sizeof(char)*weightFilePath.size());
		weightfile[weightFilePath.size()] = '\0';

		detector_load_model(&detector_, cfgfile, weightfile, progress);

		delete[] cfgfile;
		delete[] weightfile;
	}

	void freeDetector()
	{
		detector_free(&detector_);
	}

	std::vector<std::tuple<int, float, float, float, float, float>> detect(std::string imagePath, float thresh, float hier_thresh)
	{
		char* imagePathTemp = new char[imagePath.size() + 1];
		memcpy(imagePathTemp, imagePath.c_str(), sizeof(char)*imagePath.size());
		imagePathTemp[imagePath.size()] = '\0';

		detect_result r = detector_detect(&detector_, imagePathTemp, thresh, hier_thresh);

		int selected_detections_num;
		detection_with_class* selected_detections = get_actual_detections(r.results, r.result_num, thresh, &selected_detections_num);
		qsort(selected_detections, selected_detections_num, sizeof(*selected_detections), compare_by_probs);

		std::vector<std::tuple<int, float, float, float, float, float>> result;

		for (int i = 0; i < selected_detections_num; i++)
		{
			box b = selected_detections[i].det.bbox;
			result.push_back({ selected_detections[i].best_class, b.x, b.y, b.w, b.h, selected_detections[i].det.prob[selected_detections[i].best_class] });
		}

		delete[] imagePathTemp;
		delete[] selected_detections;

		return result;
	}

private:

	YoloDetector() 
	{
	}

	detector detector_;
	std::vector<std::string> classNameList_;
};

void detectorSetConfigFilesAbsolutePath(std::string path)
{
	YoloDetector::globalInstance().setConfigFilesAbsolutePath(path);
}

void detectorLoadData(std::string dataConfig)
{
	YoloDetector::globalInstance().loadData(dataConfig);
}

void detectorLoadModel(std::string cfgfile, std::string weightfile, void(*progress)(float))
{
	YoloDetector::globalInstance().loadModel(cfgfile, weightfile, progress);
}

void detectorFree()
{
	YoloDetector::globalInstance().freeDetector();
}

void getDetectorClassNames(std::vector<std::string>& nameList)
{
	nameList = YoloDetector::globalInstance().getClassNames();
}

void getDetectResult(std::vector<std::tuple<int, float, float, float, float, float>>& result,
					 std::string imagePath, float thresh, float hier_thresh)
{
	result = YoloDetector::globalInstance().detect(imagePath, thresh, hier_thresh);
}
