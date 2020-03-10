export BERT_MODEL_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12

python run_server.py \
    -bert_model_dir $BERT_MODEL_DIR \
    -model_dir ./try_output/ \
    -model_pb_dir ./try_output/ \
    -port 5555 \
    -port_out 5556 \
    -num_worker 1 \
    -cpu \
    -mode CLASS

# python run_server.py \
#     -bert_model_dir $BERT_MODEL_DIR \
#     -model_dir ./chatbot_output/ \
#     -model_pb_dir ./chatbot_output/ \
#     -port 5455 \
#     -port_out 5456 \
#     -cpu \
#     -mode NER
