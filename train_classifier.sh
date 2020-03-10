#export BERT_BASE_DIR=/home/wrd/bert/bert/uncased_L-12_H-768_A-12
export BERT_BASE_DIR=/home/wrd/bert/bert/chinese_L-12_H-768_A-12
export DATA_DIR=/home/wrd/bert/bert/bert_data

python run_classifier.py \
  --task_name=try \
  --do_train=true \
  --do_eval=true \
  --do_predict=true \
  --data_dir=$DATA_DIR/classifier_data \
  --vocab_file=$BERT_BASE_DIR/vocab.txt \
  --bert_config_file=$BERT_BASE_DIR/bert_config.json \
  --init_checkpoint=$BERT_BASE_DIR/bert_model.ckpt \
  --max_seq_length=128 \
  --train_batch_size=16 \
  --learning_rate=2e-5 \
  --num_train_epochs=3.0 \
  --output_dir=./try_output/
