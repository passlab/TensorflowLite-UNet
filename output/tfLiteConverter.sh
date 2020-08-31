toco --graph_def_file=saved_model.pb --output_file=model.tflite --input_format=TENSORFLOW_GRAPHDEF --output_format=TFLITE --input_shape=1,256,256,3 --input_array=input --output_array=output/BiasAdd --inference_type=FLOAT --input_type=FLOAT

