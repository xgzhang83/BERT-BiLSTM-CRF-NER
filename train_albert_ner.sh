export ALBERT_MODEL_DIR=/home/wrd/albert/albert_base_zh

python run.py \
    -batch_size 16 \
    -data_dir ./rasa_data/ner_data \
    -output_dir ./albert_ner_output/ \
    -init_checkpoint $ALBERT_MODEL_DIR/model.ckpt-best \
    -bert_config_file $ALBERT_MODEL_DIR/albert_config.json \
    -vocab_file $ALBERT_MODEL_DIR/vocab_chinese.txt 
