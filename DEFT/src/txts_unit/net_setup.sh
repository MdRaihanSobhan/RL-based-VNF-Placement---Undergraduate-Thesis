# !/bin/bash
# sudo ovs-vsctl --if-exists del-br ovs-br1
# sudo ovs-vsctl add-br ovs-br1

# # reads configuration from .env
# HZ_CLIENT_CNT=$(grep HZ_CLIENT_CNT .env | cut -d '=' -f2)
# HZ_CLIENT_IP_PATTERN=$(grep HZ_CLIENT_IP_PATTERN .env | cut -d '=' -f2)
# STAMPER_IP_LAST_OCTET=$(grep STAMPER_IP_LAST_OCTET .env | cut -d '=' -f2)


# # sudo ifconfig ovs-br1 173.16.1.1 netmask 255.255.255.0 up
# sudo ifconfig ovs-br1 "${HZ_CLIENT_IP_PATTERN/$/1}" netmask 255.255.255.0 up


# # adds stamper module with last octet = 230
# stamper_ip=${HZ_CLIENT_IP_PATTERN/$/230}/24
# command="sudo ovs-docker add-port ovs-br1 eth1 txts_unit-stamper-1 --ipaddress=$stamper_ip"
# echo "$command"
# $command


# for ((i=1;i<=HZ_CLIENT_CNT;i++)); 
# do
#     echo "hz_client123"
#     echo "$HZ_CLIENT_CNT"
#     echo "$i"
#     # adds primary nf to the switch
#     primary_ip=${HZ_CLIENT_IP_PATTERN/$/$((i + 1))}
#     primary_ip_with_mask=$primary_ip/24
#     client_name=txts_unit-hz_client-$i
#     primary_nf_command="sudo ovs-docker add-port ovs-br1 eth1 $client_name --ipaddress=$primary_ip_with_mask" 
    
#     echo "$primary_nf_command"
#     $primary_nf_command


#     # adds corresponding secondary nf to the switch
#     secondary_ip=${HZ_CLIENT_IP_PATTERN/$/$((i + 1 + 100))}
#     seondary_ip_with_mask=$secondary_ip/24
#     secondary_name=txts_unit-secondary-$i
#     secondary_nf_command="sudo ovs-docker add-port ovs-br1 eth1 $secondary_name --ipaddress=$seondary_ip_with_mask"
    
#     echo "$secondary_nf_command"
#     $secondary_nf_command


#     # adds flow rule to duplicate packet to secondary
#     packet_dup_command="sudo ovs-ofctl add-flow ovs-br1 dl_type=0x0800,nw_proto=17,nw_dst=$primary_ip,actions=normal,mod_nw_dst:$secondary_ip,normal"
#     echo "$packet_dup_command"
#     $packet_dup_command

# done



# primary -> sudo ovs-docker add-port ovs-br1 eth1 txts_unit_hz_client_1 --ipaddress=173.16.1.2/24 
# secondary -> sudo ovs-docker add-port ovs-br1 eth1 txts_unit_hz_client_2 --ipaddress=173.16.1.102/24
# stamper -> sudo ovs-docker add-port ovs-br1 eth1 txts_unit_stamper_1 --ipaddress=173.16.1.230/24
# flow-rule -> sudo ovs-ofctl add-flow ovs-br1 in_port=3,dl_type=0x0800,nw_proto=17,actions=normal,mod_nw_dst:173.16.1.3,normal






# !/bin/bash
sudo ovs-vsctl --if-exists del-br ovs-br1
sudo ovs-vsctl add-br ovs-br1

# reads configuration from .env
HZ_CLIENT_CNT=$(grep HZ_CLIENT_CNT .env | cut -d '=' -f2)
HZ_CLIENT_IP_PATTERN=$(grep HZ_CLIENT_IP_PATTERN .env | cut -d '=' -f2)
STAMPER_IP_LAST_OCTET=$(grep STAMPER_IP_LAST_OCTET .env | cut -d '=' -f2)


# sudo ifconfig ovs-br1 173.16.1.1 netmask 255.255.255.0 up
sudo ifconfig ovs-br1 "${HZ_CLIENT_IP_PATTERN/$/1}" netmask 255.255.255.0 up


# adds stamper module with last octet = 230
stamper_ip=${HZ_CLIENT_IP_PATTERN/$/230}/24
command="sudo ovs-docker add-port ovs-br1 eth1 txts_unit-stamper-1 --ipaddress=$stamper_ip"
echo "$command"
$command


# Mapping of primary nodes to secondary nodes
declare -A primary_to_secondary=(
    ["h1"]="h4"
    ["h2"]="h1"
    ["h3"]="h6"
    ["h5"]="h4"
    ["h7"]="h4"
)

# Associative arrays for IPs
declare -A nf_ip_map
declare -A secondary_ip_map

# Generate primary IPs for h1 to h7
for ((i=1; i<=7; i++)); do
    key="h$i"
    nf_ip_map["$key"]="${HZ_CLIENT_IP_PATTERN/$/$((i + 1))}"
done

# Generate secondary IPs based on the primary_to_secondary mapping
for primary_key in "${!primary_to_secondary[@]}"; do
    secondary_key="${primary_to_secondary["$primary_key"]}"
    secondary_ip_map["$primary_key"]="${nf_ip_map["$secondary_key"]}"
done

# Display the results
echo "Primary IPs:"
for key in "${!nf_ip_map[@]}"; do
    echo "$key: ${nf_ip_map["$key"]}"
done

echo ""
echo "Secondary IPs (based on mapping):"
for key in "${!secondary_ip_map[@]}"; do
    echo "$key -> ${secondary_ip_map["$key"]}"
done



for ((i=1;i<=HZ_CLIENT_CNT;i++)); 
do
    echo "hz_client123"
    echo "$HZ_CLIENT_CNT"
    echo "$i"
    # adds primary nf to the switch
    primary_key="h$i"
    # primary_ip="${nf_ip_map["$primary_key"]}"
    primary_ip=${HZ_CLIENT_IP_PATTERN/$/$((i + 1))}
    primary_ip_with_mask=$primary_ip/24

    client_name=txts_unit-hz_client-$i
    primary_nf_command="sudo ovs-docker add-port ovs-br1 eth1 $client_name --ipaddress=$primary_ip_with_mask" 
    
    echo "$primary_nf_command"
    $primary_nf_command


    # adds corresponding secondary nf to the switch
    secondary_ip=${HZ_CLIENT_IP_PATTERN/$/$((i + 1 + 100))}
    # secondary_ip="${secondary_ip_map["$primary_key"]}"
    seondary_ip_with_mask=$secondary_ip/24

    secondary_name=txts_unit-secondary-$i
    secondary_nf_command="sudo ovs-docker add-port ovs-br1 eth1 $secondary_name --ipaddress=$seondary_ip_with_mask"
    
    echo "$secondary_nf_command"
    $secondary_nf_command


    # adds flow rule to duplicate packet to secondary
    packet_dup_command="sudo ovs-ofctl add-flow ovs-br1 dl_type=0x0800,nw_proto=17,nw_dst=$primary_ip,actions=normal,mod_nw_dst:$secondary_ip,normal"
    echo "$packet_dup_command"
    $packet_dup_command

done