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
string Ns;
string Csj[int];
string Tdj[int];
string Taj[int];
int scan_index = 0;
reg [31:0] pointer;
string Ss;
string Se;
string Ah;
string Al;
int v;
int x_i [int]; //Component Size width
int y_i [int]; //Component Size height
string scan_symbols_table[int][int];
bit dht_tables[int][int];
longint dht_tables_dec[int][int];
longint temp_decimal;
int temp_decimal_flat;
reg [3:0] temp_binary;
bit img_data_binary_flattened [int];
int img_data_binary_flattened_index;
int temp_power;
bit [3:0] img_data_binary [int];
bit [3:0] number;
bit [15:0] dht_tables_bin_16[int][int];
int dht_tables_bin_16_index;
reg [15:0] temp_binary2;
int p;
int marker;
int code_values_count_sos;
int code_length_count_sos;
int dht_tables_dec_index;
int segment_sos;
int pointer_sos;
string code_lengths_sos[int];
string code_values_sos[int];
string scan_codes_sos;
int scan_codes_sos_d;
int dht_code_lengths_pointer;
string scan_symbol_sos;
int img_data_binary_index;
int img_data_binary_flattened_file;
bit dht_tables_dynamic [];
bit dht_tables_bin [int][int];
int dht_code_values_pointer;
int dht_tables_bin_index;
int dht_tables_bin_index_code;
int code_start_pointer;

markers mrk4(.img_data(img_data),.dqt_data(dqt_data),.dqt_marker_lengths(dqt_marker_lengths),.sof_data(sof_data), .sof_marker_lengths(sof_marker_lengths),.dht_data(dht_data), .dht_marker_lengths(dht_marker_lengths), .sos_header(sos_header));
dht_decoding dht1(.decoded_dht(decoded_dht),.dht_bit_lengths(dht_bit_lengths),.table_out(table_out));
dqt_decoding dqt1(.dqt_table(dqt_table),.destination_out_dqt(destination_out_dqt));
sof_decoding sof1(.sof_precision(sof_precision),.img_height(img_height),.img_width(img_width),.sof_components(sof_components),.sof_IDs(sof_IDs),.sof_sampling_resolution(sof_sampling_resolution),.sof_quantization_tables(sof_quantization_tables));

always_latch
begin
int i;
int j;
int k;
int m;
int n;
int w;
int match_sos;
string Ns;
string Csj[int];
string Tdj[int];
string Taj[int];
int scan_index = 0;
int pointer = 0;
int pointer_sos;
string Ss;
string Se;
string Ah;
string Al;
int counter = 0;

string dht_decoded_string;
int dht_tables_index = 0;
int cut_start = 0;
int cut_finish = 0;
int quotient = 0;
img_data_flattened_index = 0;
img_data_binary_flattened_index = 0;
pointer = 0;
dht_tables_dec_index = 0;
temp_decimal = 0;
img_data_binary_index = 0;
dht_tables_bin_16_index = 0;
dht_code_values_pointer = 0;
dht_tables_bin_index = 0;
//img_data_binary_flattened_file = $fopen("./img_data_binary.txt","w");


//Flattening image data
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

//Converting flattened image data to binary
for(i=0;i<img_data_flattened.size();i++)
begin
temp_decimal_flat = img_data_flattened[i].atohex();
/* verilator lint_off WIDTH */
temp_binary[0]=temp_decimal_flat % 2;
quotient = temp_decimal_flat/2;
temp_binary[1]=quotient % 2;
quotient = quotient/2;
temp_binary[2]=quotient % 2;
quotient = quotient/2;
temp_binary[3]=quotient % 2;
/* verilator lint_on WIDTH */

img_data_binary[img_data_binary_index]=temp_binary;

img_data_binary_flattened[img_data_binary_flattened_index]=temp_binary[3];
//$fwrite(img_data_binary_flattened_file,"%b",img_data_binary_flattened[img_data_binary_flattened_index]);
img_data_binary_flattened_index += 1;
img_data_binary_flattened[img_data_binary_flattened_index]=temp_binary[2];
//$fwrite(img_data_binary_flattened_file,"%b",img_data_binary_flattened[img_data_binary_flattened_index]);
img_data_binary_flattened_index += 1;
img_data_binary_flattened[img_data_binary_flattened_index]=temp_binary[1];
//$fwrite(img_data_binary_flattened_file,"%b",img_data_binary_flattened[img_data_binary_flattened_index]);
img_data_binary_flattened_index += 1;
img_data_binary_flattened[img_data_binary_flattened_index]=temp_binary[0];
//$fwrite(img_data_binary_flattened_file,"%b",img_data_binary_flattened[img_data_binary_flattened_index]);
img_data_binary_flattened_index += 1;

img_data_binary_index += 1;
end


//Unpacking the SOS header
Ns = {sos_header[0], sos_header[1]};
for(i=2;i<sos_header.size()-6;i+=4)
begin
Csj[scan_index] = {sos_header[i], sos_header[i+1]};
Tdj[scan_index] = sos_header[i+2];
Taj[scan_index] = sos_header[i+3];
scan_index += 1;
pointer += 4;
end
Ss = {sos_header[pointer+2], sos_header[pointer+3]};
Se = {sos_header[pointer+4], sos_header[pointer+5]};
Ah = sos_header[pointer+6];
Al = sos_header[pointer+7];


//Dividing the DHT decoded bits into separate tables
counter = 0;
for(j=0;j<dht_bit_lengths.size();j++) //the issue is here
begin
cut_finish = cut_start + dht_bit_lengths[j];
v = 0;
while(cut_start<cut_finish)
begin
dht_tables[dht_tables_index][v]=decoded_dht[counter];
//$display("decoded_dht is: %p at table %d & index %d", dht_tables[dht_tables_index][v],dht_tables_index,v);
//$display("decoded_dht original is: %p at index %d", decoded_dht[counter],counter);
//$display("Cut start is %d", cut_start);
cut_start += 1;
v += 1;
counter += 1;
end
cut_start = dht_bit_lengths[j];
dht_tables_index += 1;
end


//Converting DHT table to decimal
// temp_decimal = 0;
// pointer_sos = 0;
// dht_code_lengths_pointer = 0;
// for(marker=0;marker<dht_marker_lengths.size();marker++)
// begin
// dht_code_values_pointer = 0;
// code_values_count_sos = 0; // Initialize the code lengths and values to zero
// code_length_count_sos = 0;
// segment_sos = (dht_marker_lengths[marker]*2)-4;

// for(i=2+pointer_sos;i<=pointer_sos+((16*2)+2)-1;i++)
// begin
// code_lengths_sos[code_length_count_sos]=dht_data[i]; //Traverse the code lengths for that marker
// code_length_count_sos += 1;
// end

// for(j=34;j<=segment_sos-1;j++)
// begin
// code_values_sos[code_values_count_sos]=dht_data[j+pointer_sos]; //Traverse the code values for that marker
// code_values_count_sos += 1;
// end

// pointer_sos += segment_sos;

// match_sos = 0; // This is to traverse the matching code values for the code length just found
// for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
// begin
// scan_codes_sos={code_lengths_sos[2*j],code_lengths_sos[(2*j)+1]}; //Group two code lengths together
// scan_codes_sos_d=scan_codes_sos.atohex();

// if(scan_codes_sos_d>0)
// begin
// for(k=0;k<scan_codes_sos_d;k++)
// begin
// scan_symbol_sos={code_values_sos[2*match_sos],code_values_sos[(2*match_sos)+1]};
// dht_tables_bin_index_code = 0;
// code_start_pointer = 0;
// for(i=j+dht_code_lengths_pointer;i>=dht_code_lengths_pointer;i--) 
// begin
// //$display("Code lengths pointer here at j=%d is %d",j,dht_code_lengths_pointer);
// $display("Current code at j =%d of Huffman Table %d is %b",j,marker,dht_tables[marker][dht_code_lengths_pointer + code_start_pointer]);
// //dht_tables_bin[marker][dht_tables_bin_index][dht_tables_bin_index_code]=dht_tables[marker][dht_code_values_pointer];
// if(dht_tables[marker][i] == 1)
// begin
// temp_power = (j+dht_code_lengths_pointer)-i;
// temp_decimal += 2**temp_power;  
// end
// code_start_pointer += 1;
// dht_code_values_pointer += 1;
// //$display("DHT Code in binary for j =%d is %b",j,dht_tables_bin[marker][dht_tables_bin_index][dht_tables_bin_index_code]);
// dht_tables_bin_index_code += 1;
// end
// //$display("DHT Code in binary for j =%d is %b",j,dht_tables_bin[marker][dht_tables_bin_index][dht_tables_bin_index_code]);
// dht_tables_bin_index += 1;
// //dht_code_values_pointer += (j+1);
// dht_code_lengths_pointer += (j+1);
// //$display("Temp decimal is: %d", temp_decimal);
// dht_tables_dec[marker][dht_tables_dec_index]=temp_decimal;

// //Converting temp_decimal to binary
// //temp_binary2 is 16-bit
// /* verilator lint_off WIDTH */
// temp_binary2 = 16'b0;
// temp_binary2[0]=temp_decimal % 2;
// quotient = temp_decimal/2;
// p = 1;
// while(p<16)
// begin
// temp_binary2[p]=quotient % 2;
// quotient = quotient/2;
// p+=1;
// if(quotient == 0)
// begin
// break;
// end
// end
// /* verilator lint_on WIDTH */
// dht_tables_bin_16[marker][dht_tables_bin_16_index]=temp_binary2;
// dht_tables_bin_16_index += 1;

// //Trying above with dynamic array
// // dht_tables_dynamic = new[j];
// // dht_tables_dynamic = temp_binary2; //check from dht_decoding and VA how they did it

// //This single line below is how to link symbols with huffman code (in decimal)
// // $display("For symbol %s the decimal value is %p",scan_symbol_sos,dht_tables_dec[marker][dht_tables_dec_index]);
// //This line below fills a separate table for symbols that matches the above index
// scan_symbols_table[marker][dht_tables_dec_index]=scan_symbol_sos;
// //$display("For symbol %s the decimal value is %p",scan_symbols_table[marker][dht_tables_dec_index],dht_tables_dec[marker][dht_tables_dec_index]);
// dht_tables_dec_index += 1;
// temp_decimal = 0;
// match_sos += 1;
// end

// end

// end
// dht_code_lengths_pointer = 0;
// dht_tables_dec_index = 0;
// code_lengths_sos.delete();
// code_values_sos.delete();
//end




//end
// for(i=38;i>=0;i--)
// begin
// if(dht_tables[0][i] == 1)
// begin
// $display("i is found at %d when number is %b",i, dht_tables[0][i]);
// temp_power = 38-i;
// temp_decimal += 2**temp_power;    
// end
// end
// $display("Temp decimal is: %d", temp_decimal);
// temp_decimal = 0;
// number = 4'b1100;
//Converting DHT table to decimal
// for(i=0;i<=3;i++)
// begin
// if(number[i] == 1'b1)
// begin
// $display("i is found at %d when number is %b",i, number[i]);
// temp_decimal += 2**i;    
// end
// $display("Temp decimal is: %d", temp_decimal);
// end

//Doing component wise decoding of flattened image data
pointer_sos = 0;
dht_code_lengths_pointer = 0;

for(m=0;m<Csj.size();m++)
begin
if(Tdj[m]=="0") //Find DC Huffman Table with selector value 0
begin
for(n=0;n<table_out.size();n++) //Search through all Huffman tables
begin
temp = table_out[n]; //Checking the DHT Table selector
if(temp.substr(0,0) == "0" && temp.substr(1,1) == "0")
begin
$display("Huffman Table %d for component %d is selected", n,m);
marker = n;
pointer_sos = 0;
dht_code_values_pointer = 0;
code_values_count_sos = 0; // Initialize the code lengths and values to zero
code_length_count_sos = 0;
segment_sos = (dht_marker_lengths[marker]*2)-4;
if(n == 0)
begin
pointer_sos = 0;
end
else
begin
for(w=n;w>0;w--)
begin
pointer_sos += (dht_marker_lengths[w-1]*2)-4;
end
end
//$display("Pointer is: %d for Huffman Table %d for component %d",pointer_sos,n,m);
for(i=2+pointer_sos;i<=pointer_sos+((16*2)+2)-1;i++)
begin
code_lengths_sos[code_length_count_sos]=dht_data[i]; //Traverse the code lengths for that marker
code_length_count_sos += 1;
end

for(j=34;j<=segment_sos-1;j++)
begin
code_values_sos[code_values_count_sos]=dht_data[j+pointer_sos]; //Traverse the code values for that marker
code_values_count_sos += 1;
end



match_sos = 0; // This is to traverse the matching code values for the code length just found
for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
begin
scan_codes_sos={code_lengths_sos[2*j],code_lengths_sos[(2*j)+1]}; //Group two code lengths together
scan_codes_sos_d=scan_codes_sos.atohex();

if(scan_codes_sos_d>0)
begin
for(k=0;k<scan_codes_sos_d;k++)
begin
scan_symbol_sos={code_values_sos[2*match_sos],code_values_sos[(2*match_sos)+1]};
dht_tables_bin_index_code = 0;
code_start_pointer = 0;
for(i=j+dht_code_lengths_pointer;i>=dht_code_lengths_pointer;i--) 
begin
$display("Current code at symbol %s, j =%d of Huffman Table %d is %b",scan_symbol_sos,j,marker,dht_tables[marker][dht_code_lengths_pointer + code_start_pointer]);
code_start_pointer += 1;
end
dht_code_lengths_pointer += (j+1);

match_sos += 1;
end

end

end
dht_code_lengths_pointer = 0;
dht_tables_dec_index = 0;
code_lengths_sos.delete();
code_values_sos.delete();
end
end
end
else if(Tdj[m]=="1")//Find DC Huffman Table with selector value 1
begin
for(n=0;n<table_out.size();n++) //Search through all Huffman tables
begin
temp = table_out[n]; //Checking the DHT Table selector
if(temp.substr(0,0) == "0" && temp.substr(1,1) == "1")
begin
$display("Huffman Table %d for component %d is selected",n,m);
marker = n;
pointer_sos = 0;
dht_code_values_pointer = 0;
code_values_count_sos = 0; // Initialize the code lengths and values to zero
code_length_count_sos = 0;
segment_sos = (dht_marker_lengths[marker]*2)-4;
if(n == 0)
begin
pointer_sos = 0;
end
else
begin
for(w=n;w>0;w--)
begin
pointer_sos += (dht_marker_lengths[w-1]*2)-4;
end
end
//$display("Pointer is: %d for Huffman Table %d for component %d",pointer_sos,n,m);
for(i=2+pointer_sos;i<=pointer_sos+((16*2)+2)-1;i++)
begin
code_lengths_sos[code_length_count_sos]=dht_data[i]; //Traverse the code lengths for that marker
code_length_count_sos += 1;
end

for(j=34;j<=segment_sos-1;j++)
begin
code_values_sos[code_values_count_sos]=dht_data[j+pointer_sos]; //Traverse the code values for that marker
code_values_count_sos += 1;
end



match_sos = 0; // This is to traverse the matching code values for the code length just found
for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
begin
scan_codes_sos={code_lengths_sos[2*j],code_lengths_sos[(2*j)+1]}; //Group two code lengths together
scan_codes_sos_d=scan_codes_sos.atohex();

if(scan_codes_sos_d>0)
begin
for(k=0;k<scan_codes_sos_d;k++)
begin
scan_symbol_sos={code_values_sos[2*match_sos],code_values_sos[(2*match_sos)+1]};
dht_tables_bin_index_code = 0;
code_start_pointer = 0;
for(i=j+dht_code_lengths_pointer;i>=dht_code_lengths_pointer;i--) 
begin
$display("Current code at symbol %s, j =%d of Huffman Table %d is %b",scan_symbol_sos,j,marker,dht_tables[marker][dht_code_lengths_pointer + code_start_pointer]);
code_start_pointer += 1;
end
dht_code_lengths_pointer += (j+1);

match_sos += 1;
end

end

end
dht_code_lengths_pointer = 0;
dht_tables_dec_index = 0;
code_lengths_sos.delete();
code_values_sos.delete();
end
end
end

if(Taj[m]=="0") //Find AC Huffman Table with selector value 0
begin
for(n=0;n<table_out.size();n++) //Search through all Huffman tables
begin
temp = table_out[n]; //Checking the DHT Table selector
if(temp.substr(0,0) == "1" && temp.substr(1,1) == "0")
begin
$display("Huffman Table %d for component %d is selected",n,m);
marker = n;
pointer_sos = 0;
dht_code_values_pointer = 0;
code_values_count_sos = 0; // Initialize the code lengths and values to zero
code_length_count_sos = 0;
segment_sos = (dht_marker_lengths[marker]*2)-4;
if(n == 0)
begin
pointer_sos = 0;
end
else
begin
for(w=n;w>0;w--)
begin
pointer_sos += (dht_marker_lengths[w-1]*2)-4;
end
end
//$display("Pointer is: %d for Huffman Table %d for component %d",pointer_sos,n,m);

for(i=2+pointer_sos;i<=pointer_sos+((16*2)+2)-1;i++)
begin
code_lengths_sos[code_length_count_sos]=dht_data[i]; //Traverse the code lengths for that marker
code_length_count_sos += 1;
end

for(j=34;j<=segment_sos-1;j++)
begin
code_values_sos[code_values_count_sos]=dht_data[j+pointer_sos]; //Traverse the code values for that marker
code_values_count_sos += 1;
end



match_sos = 0; // This is to traverse the matching code values for the code length just found
for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
begin
scan_codes_sos={code_lengths_sos[2*j],code_lengths_sos[(2*j)+1]}; //Group two code lengths together
scan_codes_sos_d=scan_codes_sos.atohex();

if(scan_codes_sos_d>0)
begin
for(k=0;k<scan_codes_sos_d;k++)
begin
scan_symbol_sos={code_values_sos[2*match_sos],code_values_sos[(2*match_sos)+1]};
dht_tables_bin_index_code = 0;
code_start_pointer = 0;
for(i=j+dht_code_lengths_pointer;i>=dht_code_lengths_pointer;i--) 
begin
$display("Current code at symbol %s, j =%d of Huffman Table %d is %b",scan_symbol_sos,j,marker,dht_tables[marker][dht_code_lengths_pointer + code_start_pointer]);
code_start_pointer += 1;
end
dht_code_lengths_pointer += (j+1);

match_sos += 1;
end

end

end
dht_code_lengths_pointer = 0;
dht_tables_dec_index = 0;
code_lengths_sos.delete();
code_values_sos.delete();
end
end
end
else if(Taj[m]=="1")//Find AC Huffman Table with selector value 1
begin
for(n=0;n<table_out.size();n++) //Search through all Huffman tables
begin
temp = table_out[n]; //Checking the DHT Table selector
if(temp.substr(0,0) == "1" && temp.substr(1,1) == "1")
begin
$display("Huffman Table %d for component %d is selected",n,m);
marker = n;
pointer_sos = 0;
dht_code_values_pointer = 0;
code_values_count_sos = 0; // Initialize the code lengths and values to zero
code_length_count_sos = 0;
segment_sos = (dht_marker_lengths[marker]*2)-4;
if(n == 0)
begin
pointer_sos = 0;
end
else
begin
for(w=n;w>0;w--)
begin
pointer_sos += (dht_marker_lengths[w-1]*2)-4;
end
end
//$display("Pointer is: %d for Huffman Table %d for component %d",pointer_sos,n,m);

for(i=2+pointer_sos;i<=pointer_sos+((16*2)+2)-1;i++)
begin
code_lengths_sos[code_length_count_sos]=dht_data[i]; //Traverse the code lengths for that marker
code_length_count_sos += 1;
end

for(j=34;j<=segment_sos-1;j++)
begin
code_values_sos[code_values_count_sos]=dht_data[j+pointer_sos]; //Traverse the code values for that marker
code_values_count_sos += 1;
end



match_sos = 0; // This is to traverse the matching code values for the code length just found
for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
begin
scan_codes_sos={code_lengths_sos[2*j],code_lengths_sos[(2*j)+1]}; //Group two code lengths together
scan_codes_sos_d=scan_codes_sos.atohex();

if(scan_codes_sos_d>0)
begin
for(k=0;k<scan_codes_sos_d;k++)
begin
scan_symbol_sos={code_values_sos[2*match_sos],code_values_sos[(2*match_sos)+1]};
dht_tables_bin_index_code = 0;
code_start_pointer = 0;
for(i=j+dht_code_lengths_pointer;i>=dht_code_lengths_pointer;i--) 
begin
$display("Current code at symbol %s, j =%d of Huffman Table %d is %b",scan_symbol_sos,j,marker,dht_tables[marker][dht_code_lengths_pointer + code_start_pointer]);
code_start_pointer += 1;
end
dht_code_lengths_pointer += (j+1);

match_sos += 1;
end

end

end
dht_code_lengths_pointer = 0;
dht_tables_dec_index = 0;
code_lengths_sos.delete();
code_values_sos.delete();
end
end
end


end






//Display
// $display("Ns is %s", Ns);
// for(j=0;j<Csj.size();j++)
// begin
// $display("Csj are %s", Csj[j]);
// end
// for(j=0;j<Tdj.size();j++)
// begin
// $display("Tdj are %s", Tdj[j]);
// end
// for(j=0;j<Taj.size();j++)
// begin
// $display("Taj are %s", Taj[j]);
// end
// $display("SS is %s", Ss);
// $display("Se is %s", Se);
// $display("Ah is %s", Ah);
// $display("Al is %s", Al);
// for(j=0;j<dht_tables.size();j++)
// begin
// $display("DHT tables are %p", dht_tables[j]);
// end //Tomorrow try this again by converting decoded_dht into a string

//This below works perfectly
// for(j=0;j<5;j++)
// begin
// $display("Flattened image data is %s", img_data_flattened[j]);
// end 
// for(j=0;j<5;j++)
// begin
// $display("Binary image data is %b", img_data_binary[j]);
// end 
// for(j=0;j<30;j++)
// begin
// $display("Flattened binary image data is %b", img_data_binary_flattened[j]);
// end 

//The following displays the entire table in binary
// for(j=0;j<41;j++)
// begin
// $display("DHT table is %p",dht_tables[2][j]); //Use DHT tables this way for each component
// end 

//$display("DHT table is %p",dht_tables[0]); //Use DHT tables this way for each component
//or
//$display("DHT table 0 in decimal is %p",dht_tables_dec[0]); //This correctly gives whole table but in hex
//$display("DHT table 0 at j = 7 in decimal is %p",dht_tables_dec[0][7]); //This gives 30 correctly. You can convert 
//it back into bits for easy usage.
// $display("DHT table 0 in binary at j = 7 is %b",dht_tables_bin_16[0][7]); This gives binary of 30 very correctly
// $display("DHT table 0 in binary at j = 6 is %b",dht_tables_bin_16[0][6]);
// $display("DHT table 0 in binary at j = 8 is %b",dht_tables_bin_16[0][8]);

//Deprecated:
// $display("DHT table in decimal is %d",dht_tables_dec["06"][0]);
// $display("DHT table in decimal is %d",dht_tables_dec["06"][1]);
// $display("DHT table in decimal is %d",dht_tables_dec["06"][2]);
// $display("DHT table in decimal is %d",dht_tables_dec["06"][3]);
//or
//$display("DHT table in decimal is %p",dht_tables_dec[0]);


//$fclose(img_data_binary_flattened_file);
end

endmodule
