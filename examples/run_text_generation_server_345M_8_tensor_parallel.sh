#!/bin/bash
# This example will start serving the 345M model that is partitioned 8 way tensor parallel
DISTRIBUTED_ARGS="--nproc_per_node 8 \
                  --nnodes 1 \
                  --node_rank 0 \
                  --master_addr localhost \
                  --master_port 6000"

CHECKPOINT=<Path to checkpoint (e.g /345m)>
VOCAB_FILE=<Path to vocab.json (e.g. /gpt2-vocab.json)>
MERGE_FILE=<Path to merges.txt (e.g. /gpt2-merges.txt)>

pip install flask-restful

python -m torch.distributed.launch $DISTRIBUTED_ARGS tools/run_text_generation_server.py   \
       --tensor_model_parallel_size 8  \
       --pipeline_model_parallel_size 1  \
       --num_layers 24  \
       --hidden_size 1024  \
       --load ${CHECKPOINT}  \
       --num_attention_heads 16  \
       --max_position_embeddings 1024  \
       --tokenizer_type GPT2BPETokenizer  \
       --fp16  \
       --micro_batch_size 1  \
       --seq_length 1024  \
       --out_seq_length 1024  \
       --temperature 1.0  \
       --vocab_file $VOCAB_FILE  \
       --merge_file $MERGE_FILE  \
       --top_p 0.9  \
       --seed 42
