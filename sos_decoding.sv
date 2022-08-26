module sos_decoding;
//From markers
string img_data[int];
string dqt_data[int];
int dqt_marker_lengths[int];
string sof_data[int]; 
int sof_marker_lengths[int];
string dht_data[int];
int dht_marker_lengths[int];
string sos_header[int];

//From DHT
bit decoded_dht[int];
int dht_bit_lengths[int];
string table_out[int];

//From DQT
string dqt_table[int];
string destination_out_dqt[int];

//From SOF
int sof_precision;
int img_height;
int img_width;
int sof_components;
string sof_IDs[int];
string sof_sampling_resolution[int];
string sof_quantization_tables[int];

//Variables used in this module
string img_data_flattened[int];
int img_data_flattened_index;
string temp;

markers mrk4(.img_data(img_data),.dqt_data(dqt_data),.dqt_marker_lengths(dqt_marker_lengths),.sof_data(sof_data), .sof_marker_lengths(sof_marker_lengths),.dht_data(dht_data), .dht_marker_lengths(dht_marker_lengths), .sos_header(sos_header));
dht_decoding dht1(.decoded_dht(decoded_dht),.dht_bit_lengths(dht_bit_lengths),.table_out(table_out));
dqt_decoding dqt1(.dqt_table(dqt_table),.destination_out_dqt(destination_out_dqt));
sof_decoding sof1(.sof_precision(sof_precision),.img_height(img_height),.img_width(img_width),.sof_components(sof_components),.sof_IDs(sof_IDs),.sof_sampling_resolution(sof_sampling_resolution),.sof_quantization_tables(sof_quantization_tables));

always_comb
begin
int i;
int j;
img_data_flattened_index = 0;

for(i=0;i<img_data.size();i++)
begin
temp = img_data[i];
img_data_flattened[img_data_flattened_index]=temp.substr(0,0);
img_data_flattened_index += 1;
img_data_flattened[img_data_flattened_index]=temp.substr(1,1);
img_data_flattened_index += 1;
img_data_flattened[img_data_flattened_index]=temp.substr(2,2);
img_data_flattened_index += 1;
img_data_flattened[img_data_flattened_index]=temp.substr(3,3);
img_data_flattened_index += 1;
end




end


endmodule