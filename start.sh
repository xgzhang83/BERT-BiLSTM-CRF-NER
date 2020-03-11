export BERT_MODEL_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12
export ALBERT_MODEL_DIR=/home/wrd/albert/albert_base_zh

if [ $# -eq 1 ]; then
    if [ $1 == "ner" ]; then
        python run.py \
            RUN \
            -bert_model_dir $BERT_MODEL_DIR \
            -model_dir ./chatbot_output/ \
            -model_pb_dir ./chatbot_output/ \
            -port 5455 \
            -port_out 5456 \
            -num_worker 1 \
            -mode NER
    fi
    
    if [ $1 == "class" ]; then
        python run.py \
            RUN \
            -bert_model_dir $BERT_MODEL_DIR \
            -model_dir ./try_output/ \
            -model_pb_dir ./try_output/ \
            -port 5555 \
            -port_out 5556 \
            -num_worker 1 \
            -cpu \
            -mode CLASS
    fi

    if [ $1 == "albert_ner" ]; then
        python run.py \
             RUN \
            -bert_model_dir $ALBERT_MODEL_DIR \
            -ckpt_name $ALBERT_MODEL_DIR/model.ckpt-best \
            -config_name $ALBERT_MODEL_DIR/albert_config.json \
            -model_dir ./albert_ner_output/ \
            -model_pb_dir ./albert_ner_output/ \
            -port 5455 \
            -port_out 5456 \
            -mode ALBERT_NER
    fi

    if [ $1 == "albert_class" ]; then
        python run.py \
            RUN
            -bert_model_dir $ALBERT_MODEL_DIR \
            -ckpt_name $ALBERT_MODEL_DIR/model.ckpt-best \
            -config_name $ALBERT_MODEL_DIR/albert_config.json \
            -model_dir ./albert_class_output/ \
            -model_pb_dir ./albert_class_output/ \
            -port 5555 \
            -port_out 5556 \
            -num_worker 1 \
            -mode ALBERT_CLASS
    fi
else
    echo "usage: ./start.sh <mode>"
    echo "mode: ner, albert_ner"
fi

