export BERT_MODEL_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12

python run.py \
    -batch_size 8 \
    -data_dir ./rasa_data/ner_data \
    -output_dir ./chatbot_output/ \
    -init_checkpoint $BERT_MODEL_DIR/bert_model.ckpt \
    -bert_config_file $BERT_MODEL_DIR/bert_config.json \
    -vocab_file $BERT_MODEL_DIR/vocab.txt 
