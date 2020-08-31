
1. Run the main.py file: ```python3 main.py --gpu``` 
2. Performance infer: ```python3 main_infer.py``` 
3. Freeze Graph: \ ```python freeze_graph.py \``` \ 
```--input_graph=model/cell/semanticsegmentation_cell.pbtxt \``` \ 
```--input_checkpoint=model/cell/deployfinal.ckpt \```\ 
```--output_graph=model/cell/semanticsegmentation_frozen_cell.pb \```\ 
```--output_node_names=output/BiasAdd \```\ 
```--input_binary=False```\ 
4. Perform Testing: ```python tf_test.py``` 
5. To converter generated .pb to .tflite, copy the generated .pb file from /model/cell to /output and name if saved_model.pb\ 
Run the converter.py ```python converter.py``` to get the name of input, and output nodes\ 
Use the input and output node names in tfLiteConverter.sh Run ```./tfLiteConverter.sh```
