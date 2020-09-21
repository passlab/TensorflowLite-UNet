
1. Run the main.py file: ```python3 main.py --gpu``` \
   In main.py you specify the path to the data you want to perform the training on. \
   ```loader = ld.Loader(dir_original="data_set/ISBI/JPEGImagesOUT", dir_segmented="data_set/ISBI/SegmentationClassOUT")``` \
   Here, JPEGImagesOUT contains the original data and SegmentationClassOUT contains the label.
   You can specify parameters like: number of epochs, gpu (to enable gpu), train rate, augmentation, batch size, 12 reg while running main.py \
   On running the main.py file, training checkpoint will be created under folder: /model/cell with the name model.ckpt.
   
2. Performance infer: ```python3 main_infer.py``` \
   Running main_infer.py will save the protobuffer in the text format under /model/cell/ folder with semanticsegmentation_cell.pbtxt
   
3. Freeze Graph: \ ```python freeze_graph.py \``` \ ```--input_graph=model/cell/semanticsegmentation_cell.pbtxt \``` \ 
```--input_checkpoint=model/cell/deployfinal.ckpt \```\ ```--output_graph=model/cell/semanticsegmentation_frozen_cell.pb \```\ 
```--output_node_names=output/BiasAdd \```\ ```--input_binary=False```\
  Use the above command to freeze the graph and save it with the following name semanticsegmentation_frozen_cell.pb 4. Perform Testing: ```python tf_test.py``` 
\
  Once you have saved the model you cn peform testing on your model by running tf_test.py, this file takes a an input image and a label, the image is use to 
predict the output,
  and the output is compared with the original label. 5. Next step is to convert the model to Tensorflow Lite format to be able to use it on TFLite supported 
devices.\
  To converter generated .pb to .tflite, copy the generated .pb file from /model/cell folder to /output folder and name it as: ```saved_model.pb``` \
  Run the converter.py ```python converter.py``` to get the name of input, and output nodes \
  The output will look like:
  
  
  **Tensor("prefix/input:0", shape=(?, 256, 256, 3), dtype=float32)** \
  Tensor("prefix/conv2d/kernel:0", shape=(3, 3, 3, 32), dtype=float32) \
  Tensor("prefix/conv2d/kernel/read:0", shape=(3, 3, 3, 32), dtype=float32) \
  Tensor("prefix/conv2d/bias:0", shape=(32,), dtype=float32) \
  Tensor("prefix/conv2d/bias/read:0", shape=(32,), dtype=float32) \
  Tensor("prefix/conv2d/Conv2D:0", shape=(?, 256, 256, 32), dtype=float32) \
  Tensor("prefix/conv2d/BiasAdd:0", shape=(?, 256, 256, 32), dtype=float32) \
  Tensor("prefix/conv2d/Relu:0", shape=(?, 256, 256, 32), dtype=float32) \
  Tensor("prefix/batch_normalization/gamma:0", shape=(32,), dtype=float32) \
  Tensor("prefix/batch_normalization/gamma/read:0", shape=(32,), dtype=float32) \
  Tensor("prefix/batch_normalization/beta:0", shape=(32,), dtype=float32) \
  Tensor("prefix/batch_normalization/beta/read:0", shape=(32,), dtype=float32) \
  Tensor("prefix/batch_normalization/moving_mean:0", shape=(32,), dtype=float32) \
  Tensor("prefix/batch_normalization/moving_mean/read:0", shape=(32,), dtype=float \
  ... \
  Tensor("prefix/output/bias/read:0", shape=(2,), dtype=float32) \
  Tensor("prefix/output/Conv2D:0", shape=(?, 256, 256, 2), dtype=float32) \
  **Tensor("prefix/output/BiasAdd:0", shape=(?, 256, 256, 2), dtype=float32)** \
  Use the input (**input**) and output (**BiasAdd**) node names followed by word prefix from the output in tfLiteConverter.sh \
  ```toco --graph_def_file=saved_model.pb --output_file=model.tflite --input_format=TENSORFLOW_GRAPHDEF --output_format=TFLITE --input_shape=1,256,256,3 
--input_array=input -- output_array=output/BiasAdd --inference_type=FLOAT --input_type=FLOAT ```
  
  6. Now Run ```./tfLiteConverter.sh``` \
    This will convert the model to tensorflow lite format, since our model has a variable dimension and toco does not yet support specifying variable dimension 
    in the input shape, we specify a hardcode value 1 in the input shape for instead of a ? (question mark). Now we also need to reshape out input while providing 
    it to the model while running it on the TFLite framework.
    
  7. Testing TFLite format model: Run the tflite_test.py using the following command : ```python tflite_test.py```
 
  If you face any error converting the model to tf lite format which says ```module 'tensorflow.contrib' has no attribute 'lite'``` you should remove your 
  tensorflow library and install it completely again, this occurs because the ```lite``` module which was initially in the ```tensorflow.contrib``` folder has 
  been moved to ```tensorflow.lite```
