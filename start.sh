#!/bin/bash
export BERT_MODEL_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12
export ALBERT_MODEL_DIR=/home/wrd/albert/albert_base_zh
export ZEROMQ_SOCK_TMP_DIR=/tmp

check_new_model() {
    if [ -d "bert_class_output" ]
    then
        if [ -f "bert_class_output/ready_for_deploy" ]
        then
            echo "bert classifier is ready for deploy"
            mv bert_class_output.run bert_class_output.old
            mv bert_class_output bert_class_output.run
        else
            echo "bert classifier model is not ready yet"
        fi
    else
        echo "no new bert classifier model"
    fi
     
    if [ -d "ner_output" ]
    then
        if [ -f "ner_output/ready_for_deploy" ]
        then
            echo "ner is ready for deploy"
            mv ner_output.run ner_output.old
            mv ner_output ner_output.run
        else
            echo "ner model is not ready yet"
        fi
    else
        echo "no new ner model"
    fi
}

train_ner() {
    python run.py \
        TRAIN \
        -batch_size 8 \
        -data_dir ./rasa_data/ner_data \
        -output_dir ./ner_output/ \
        -init_checkpoint $BERT_MODEL_DIR/bert_model.ckpt \
        -bert_config_file $BERT_MODEL_DIR/bert_config.json \
        -vocab_file $BERT_MODEL_DIR/vocab.txt 
}

train_class() {
    python run.py \
        TRAIN_CLASS \
        -output_dir "./bert_class_output" \
        -data_dir "./rasa_data/classifier_data" \
        -init_checkpoint "$BERT_MODEL_DIR/bert_model.ckpt" \
        -bert_config_file "$BERT_MODEL_DIR/bert_config.json" \
        -vocab_file "$BERT_MODEL_DIR/vocab.txt" \
        -max_seq_length 128 \
        -ner RASA \
        -save_checkpoints_steps 500 \
        -batch_size 16
}

train_albert_ner() {
            python run.py \
                TRAIN_ALBERT \
                -batch_size 32 \
                -data_dir ./rasa_data/ner_data \
                -output_dir ./albert_ner_output/ \
                -init_checkpoint $ALBERT_MODEL_DIR/model.ckpt-best \
                -bert_config_file $ALBERT_MODEL_DIR/albert_config.json \
                -vocab_file $ALBERT_MODEL_DIR/vocab.txt 
}

train_albert_class() {
    python3 -m bert_base.albert.run_classifier \
        --output_dir="./albert_class_output" \
        --data_dir="./rasa_data/classifier_data" \
        --init_checkpoint="$ALBERT_MODEL_DIR/model.ckpt-best" \
        --albert_config_file="$ALBERT_MODEL_DIR/albert_config.json" \
        --vocab_file="$ALBERT_MODEL_DIR/vocab.txt" \
        --do_lower_case \
        --max_seq_length=128 \
        --optimizer=adamw \
        --task_name=RASA \
        --train_step=1000 \
        --save_checkpoints_steps=500 \
        --train_batch_size=32 \
        --do_train \
        --nodo_eval \
        --nodo_predict

#                --warmup_step=200 \
#                --learning_rate=2e-5 \
}

run_ner() {
    python run.py \
        RUN \
        -bert_model_dir $BERT_MODEL_DIR \
        -model_dir ./ner_output.run/ \
        -model_pb_dir ./ner_output.run/ \
        -port 5455 \
        -port_out 5456 \
        -num_worker 1 \
        -mode NER
}

run_class() {
    python run.py \
        RUN \
        -bert_model_dir $BERT_MODEL_DIR \
        -model_dir ./bert_class_output.run/ \
        -model_pb_dir ./bert_class_output.run/ \
        -port 5555 \
        -port_out 5556 \
        -num_worker 1 \
        -cpu \
        -mode CLASS
}

run_albert_ner() {
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
}

run_albert_class() {
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
}

if [ $# -eq 2 ]; then
    if [ $1 == "train" ]; then
        if [ $2 == "ner" ]; then
            train_ner
        fi

        if [ $2 == "class" ]; then
            train_class
        fi

        if [ $2 == "albert_ner" ]; then
            train_albert_ner
        fi

        if [ $2 == "albert_class" ]; then
            train_albert_class
        fi
    fi

    if [ $1 == "run" ]; then
        if [ $2 == "ner" ]; then
            run_ner
        fi
        
        if [ $2 == "class" ]; then
            run_class
        fi
    
        if [ $2 == "albert_ner" ]; then
            run_albert_ner
        fi
    
        if [ $2 == "albert_class" ]; then
            run_albert_class
        fi
    fi
elif [ $# -eq 1 ]; then
    if [ $1 == "train" ]; then
        train_class
        train_ner
    elif [ $1 == "run" ]; then
        run_class&
        run_ner
    elif [ $1 == "check" ]; then
        check_new_model
    fi
else
    echo "usage: ./start.sh <task> <mode>"
    echo "task: train, run"
    echo "mode: ner, albert_ner, class, albert_class"
fi

