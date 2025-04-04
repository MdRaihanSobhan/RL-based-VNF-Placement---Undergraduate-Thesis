#!/bin/bash
set -x
packet_count=1000
run_test() {
    python kill_iperf.py --force

    docker-compose down
    docker-compose up -d
    sleep 5
    bash net_setup.sh
    echo "rate is $1"
    SERVICE_NAME=secondary
    for id in $(docker-compose ps -q $SERVICE_NAME); do
        docker start "$id"
        docker exec -itd "$id" python -u secondary_test.py
    done;

    iperf -c 127.0.0.1 -p 8080 -u -b "$1"pps -l 100 -t 1200 -x CDMSV -P "$2" &

    python kill_iperf.py
    
}

# clear the previous results 
rm -rf results/*
mkdir -p results

batches=(80)
stamper_counts=(2)

flow_counts=(500)
effective_packet_rate=(10000)


docker-compose build
echo "Tracking Time" > time_output.txt

for stamper_count in "${stamper_counts[@]}"; do
    for flow_count in "${flow_counts[@]}"; do
        for bs in "${batches[@]}"; do
            for (( bfs=10 ; bfs<=10 ; bfs++ )); do
                for (( pr=20 ; pr<=20 ; pr+=500 )); do
                    echo "Batch size = $batch_size, Buffer size = $buffer_size, Packet rate = $packet_rate, Flow Count = $flow_count"
                    
                    # replace env values in .env file
                    nf_cnt=$stamper_count
                    sed -i~ "/^BATCH_SIZE=/s/=.*/=$bs/" .env
                    sed -i~ "/^BUFFER_SIZE=/s/=.*/=$bfs/" .env
                    sed -i~ "/^PACKET_RATE=/s/=.*/=$pr/" .env
                    sed -i~ "/^STAMPER_CNT=/s/=.*/=$stamper_count/" .env
                    sed -i~ "/^FLOW_CNT=/s/=.*/=$flow_count/" .env
                    sed -i~ "/^HZ_CLIENT_CNT=/s/=.*/=$nf_cnt/" .env
                     
                    # filename=results/batch_"${bs}"-buf_"${bfs}"-pktrate_"${pr}"-flow_cnt_"${flow_count}"-stamper_cnt_"${stamper_count}".csv
                    filename=results/DEFT.csv
                    echo "Latency(ms), Throughput(byte/s), Throughput(pps), Packets Processed, Packets Dropped, Input Buffer Max Length, Output Buffer Max Length, Time in Input Buffer(ms), Time in Output Buffer(ms), Time in pkt processing(ms), Path Latency(ms)" >> "$filename"

                    for trial in {1..3}; do
                        echo "Trial number $trial"
                        sed -i~ "/^TRIAL=/s/=.*/=$trial/" .env

                        echo "NF Count: " $nf_cnt >> time_output.txt

                        start=$(date +%s.%N)
                        run_test "$pr" "$flow_count"
                        end=$(date +%s.%N)
                        echo "Elapsed time: $(echo "$end - $start" | bc) seconds" >> time_output.txt

                        python summarize_result.py $filename
                    done
                done
            done
        done
    done
done

