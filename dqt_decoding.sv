module dqt_decoding(dqt_table,destination_out_dqt);
string img_data[int];
string dqt_data[int];
int dqt_marker_lengths[int];
string sof_data[int]; 
int sof_marker_lengths[int];
string dht_data[int];
int dht_marker_lengths[int];
string sos_header[int];


string destination;
int pointer;
output string dqt_table[int];
int dqt_table_index;
int segment = 0;
output string destination_out_dqt[int];
int destination_out_index;

markers mrk2(.img_data(img_data),.dqt_data(dqt_data),.dqt_marker_lengths(dqt_marker_lengths),.sof_data(sof_data), .sof_marker_lengths(sof_marker_lengths),.dht_data(dht_data), .dht_marker_lengths(dht_marker_lengths), .sos_header(sos_header));

always_comb
begin
int i;
int j;
int k;
int marker;
pointer = 0;
destination_out_index = 0;
dqt_table_index = 0;


for(marker=0;marker<dqt_marker_lengths.size();marker++)
begin    
destination = {dqt_data[pointer],dqt_data[pointer+1]};
destination_out_dqt[destination_out_index]=destination;
destination_out_index+=1;
segment = (dqt_marker_lengths[marker]*2)-4;

for(i=2+pointer;i<=pointer+segment-1;i++)
begin
dqt_table[dqt_table_index]=dqt_data[i];
dqt_table_index += 1;
end
pointer += segment;

end

// for(j=0;j<destination_out_dqt.size();j++)
// begin
// $display("DQT destination is %s",destination_out_dqt[j]);
// end

// for(j=0;j<dqt_table.size();j++)
// begin
// $display("DQT table data is %s",dqt_table[j]);
// end

end


endmodule