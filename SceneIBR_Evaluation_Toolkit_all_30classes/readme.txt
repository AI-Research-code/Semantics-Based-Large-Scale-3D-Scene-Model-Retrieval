1. Classification files
   Target 2D scene image dataset                         --- Sketch.cla 
   Query Testing 2D scene image dataset for evaluation   --- SketchTesting.cla 
   Target 3D scene model dataset                          --- Model.cla 
   Query Testing 3D scene model dataset for evaluation    --- ModelTesting.cla
			
2. Code
   evaluate_rank_lists_shrec18_scene_ibr.m       --- main file to evaluate on the complete benchmark
   evaluate_rank_lists_shrec18_scene_ibr_test.m  --- main file to evaluate on the testing dataset
   read_classification_file_shrec18.m      --- read a sketch/model classification file (models' name and class, class information)
   read_rank_list_shrec18.m                --- read a retrieval list for a query sketch (model names, distances)
   calcAvgPerf.m                           --- calculate average precision-recall based on averaging on all the models
   interpolatePerf.m                       --- compute the precision value by bilinearly interpolation on the neighboring precision values 
      
