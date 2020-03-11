export BERT_MODEL_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12
export ALBERT_MODEL_DIR=/home/wrd/albert/albert_base_zh

if [ $# -eq 2 ]; then
    if [ $1 == "train" ]; then
        if [ $2 == "ner" ]; then
            python run.py \
                TRAIN \
                -batch_size 8 \
                -data_dir ./rasa_data/ner_data \
                -output_dir ./ner_output/ \
                -init_checkpoint $BERT_MODEL_DIR/bert_model.ckpt \
                -bert_config_file $BERT_MODEL_DIR/bert_config.json \
                -vocab_file $BERT_MODEL_DIR/vocab.txt 
        fi

        if [ $2 == "albert_ner" ]; then
            python run.py \
                TRAIN_ALBERT \
                -batch_size 16 \
                -data_dir ./rasa_data/ner_data \
                -output_dir ./albert_ner_output/ \
                -init_checkpoint $ALBERT_MODEL_DIR/model.ckpt-best \
                -bert_config_file $ALBERT_MODEL_DIR/albert_config.json \
                -vocab_file $ALBERT_MODEL_DIR/vocab.txt 
        fi

        if [ $2 == "albert_class" ]; then
            python3 -m bert_base.albert.run_classifier \
                --output_dir="./albert_class_output" \
                --data_dir="./rasa_data/classifier_data" \
                --init_checkpoint="" \
                --albert_config_file="$ALBERT_MODEL_DIR/albert_config.json" \
                --vocab_file="$ALBERT_MODEL_DIR/vocab.txt" \
                --do_lower_case \
                --max_seq_length=128 \
                --optimizer=adamw \
                --task_name=RASA \
                --warmup_step=200 \
                --train_step=1000 \
                --learning_rate=2e-5 \
                --save_checkpoints_steps=500 \
                --train_batch_size=32 \
                --do_train \
                --nodo_eval \
                --nodo_predict
        fi
    fi

    if [ $1 == "run" ]; then
        if [ $2 == "ner" ]; then
            python run.py \
                RUN \
                -bert_model_dir $BERT_MODEL_DIR \
                -model_dir ./ner_output/ \
                -model_pb_dir ./ner_output/ \
                -port 5455 \
                -port_out 5456 \
                -num_worker 1 \
                -mode NER
        fi
        
        if [ $2 == "class" ]; then
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
    
        if [ $2 == "albert_ner" ]; then
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
    
        if [ $2 == "albert_class" ]; then
            python run.py \
                RUN \
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
    fi
else
    echo "usage: ./start.sh <task> <mode>"
    echo "task: train, run"
    echo "mode: ner, albert_ner, class, albert_class"
fi

