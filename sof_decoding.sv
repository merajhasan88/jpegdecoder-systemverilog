module sof_decoding(sof_precision,img_height,img_width,sof_components,sof_IDs,sof_sampling_resolution,sof_quantization_tables);
string img_data[int];
string dqt_data[int];
int dqt_marker_lengths[int];
string sof_data[int]; 
int sof_marker_lengths[int];
string dht_data[int];
int dht_marker_lengths[int];
string sos_header[int];


output int sof_precision;
output int img_height;
output int img_width;
output int sof_components;
output string sof_IDs[int];
int sof_IDs_index;
output string sof_sampling_resolution[int];
int sof_sampling_resolution_index;
output string sof_quantization_tables[int];
int sof_quantization_tables_index;
int segment = 0;
int pointer;
string temp;

markers mrk3(.img_data(img_data),.dqt_data(dqt_data),.dqt_marker_lengths(dqt_marker_lengths),.sof_data(sof_data), .sof_marker_lengths(sof_marker_lengths),.dht_data(dht_data), .dht_marker_lengths(dht_marker_lengths), .sos_header(sos_header));

always_comb
begin
int i;
int j;
int k;
int marker;
pointer = 0;
sof_IDs_index = 0;
sof_sampling_resolution_index = 0;
sof_quantization_tables_index = 0;


for(marker=0;marker<sof_marker_lengths.size();marker++)
begin
segment = (sof_marker_lengths[marker]*2)-4;    
temp = ({sof_data[pointer], sof_data[pointer + 1]});
sof_precision = temp.atohex();
temp = ({sof_data[pointer +2], sof_data[pointer +3], sof_data[pointer +4], sof_data[pointer +5]});
img_height = temp.atohex();
temp = ({sof_data[pointer +6], sof_data[pointer +7], sof_data[pointer +8], sof_data[pointer +9]});
img_width = temp.atohex();
temp = ({sof_data[pointer+10], sof_data[pointer + 11]});
sof_components = temp.atohex();

for(i=pointer+12;i<segment;i+=6)
begin
sof_IDs[sof_IDs_index]={sof_data[i],sof_data[i+1]};
sof_IDs_index += 1;
sof_sampling_resolution[sof_sampling_resolution_index]={sof_data[i+2],sof_data[i+3]};
sof_sampling_resolution_index += 1;
sof_quantization_tables[sof_quantization_tables_index] = {sof_data[i+4],sof_data[i+5]};
sof_quantization_tables_index += 1;
end


pointer += segment;

end
// $display("Precision is %d", sof_precision);
// $display("Image height is %d", img_height);
// $display("Image width is %d", img_width);
// $display("Number of components are %d", sof_components);

// for(j=0;j<sof_IDs.size();j++)
// begin
// $display("SOF IDs are %s",sof_IDs[j]);
// end

// for(j=0;j<sof_sampling_resolution.size();j++)
// begin
// $display("SOF sampling resolutions are %s",sof_sampling_resolution[j]);
// end

// for(j=0;j<sof_quantization_tables.size();j++)
// begin
// $display("SOF Quantization tables are %s",sof_quantization_tables[j]);
// end

end


endmodule