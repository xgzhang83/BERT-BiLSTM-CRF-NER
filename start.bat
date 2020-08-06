set BERT_BASE_DIR="D:\albert\chinese_L-12_H-768_A-12"
set DATA_DIR="D:\BOTs\nlu_chatbot\pabot_tf2\data\bert_data"
set ALBERT_MODEL_DIR="D:\albert\albert_base_zh"

echo %1,%2

if "%1"=="train" goto train
if "%1"=="run" goto run
exit

:train
if "%2"=="ner" goto train_ner
if "%2"=="class" goto train_class
if "%2"=="albert_ner" goto train_albert_ner
if "%2"=="albert_class" goto train_albert_class
exit

:run
if "%2"=="ner" goto run_ner
if "%2"=="class" goto run_class
if "%2"=="albert_ner" goto run_albert_ner
if "%2"=="albert_class" goto run_albert_class
exit

:run_class
python run.py ^
RUN ^
-bert_model_dir %BERT_BASE_DIR% ^
-model_dir .\bert_class_output\ ^
-model_pb_dir .\bert_class_output\ ^
-port 5555 ^
-port_out 5556 ^
-num_worker 1 ^
-mode CLASS
exit

:run_ner
python run.py ^
RUN ^
-bert_model_dir %BERT_BASE_DIR% ^
-model_dir .\ner_output\ ^
-model_pb_dir .\ner_output\ ^
-port 5455 ^
-port_out 5456 ^
-num_worker 1 ^
-mode NER
exit

:train_ner
python run.py ^
TRAIN ^
-batch_size 8 ^
-data_dir %DATA_DIR%\ner_data ^
-output_dir .\ner_output\ ^
-init_checkpoint %BERT_BASE_DIR%\bert_model.ckpt ^
-bert_config_file %BERT_BASE_DIR%\bert_config.json ^
-vocab_file %BERT_BASE_DIR%\vocab.txt 
exit

:train_class
python run.py ^
TRAIN_CLASS ^
-batch_size 16 ^
-data_dir %DATA_DIR%\classifier_data ^
-output_dir .\bert_class_output\ ^
-init_checkpoint %BERT_BASE_DIR%\bert_model.ckpt ^
-bert_config_file %BERT_BASE_DIR%\bert_config.json ^
-vocab_file %BERT_BASE_DIR%\vocab.txt ^
-max_seq_length 128 ^
-ner RASA ^
-save_checkpoints_steps 500
exit

:run_albert_class
python run.py ^
RUN ^
-bert_model_dir %ALBERT_MODEL_DIR% ^
-ckpt_name %ALBERT_MODEL_DIR%\model.ckpt-best ^
-config_name %ALBERT_MODEL_DIR%\albert_config.json ^
-model_dir .\albert_class_output\ ^
-model_pb_dir .\albert_class_output\ ^
-port 5555 ^
-port_out 5556 ^
-num_worker 0 ^
-mode ALBERT_CLASS
exit