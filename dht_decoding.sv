module dht_decoding(decoded_dht,dht_bit_lengths,table_out);
string img_data[int];
string dqt_data[int];
int dqt_marker_lengths[int];
string sof_data[int]; 
int sof_marker_lengths[int];
string dht_data[int];
int dht_marker_lengths[int];
string sos_header[int];


int dht_out[string];
string code_lengths[int];
string code_values[int];
string symbols[int][int];
int segment = 0;
reg [31:0] pointer;
logic [31:0] dht_code;
int dht_bit_accumulator;
output bit decoded_dht[int];
output int dht_bit_lengths[int];
int dht_bit_lengths_index;
int first_hit;
output string table_out[int];


markers mrk1(.img_data(img_data),.dqt_data(dqt_data),.dqt_marker_lengths(dqt_marker_lengths),.sof_data(sof_data), .sof_marker_lengths(sof_marker_lengths),.dht_data(dht_data), .dht_marker_lengths(dht_marker_lengths), .sos_header(sos_header));

always_latch
begin
int marker;
int i = 0;
int j;
int k;
int l;
int m;
int match = 1;
int scan_codes_d;
int v = 0;
int w;



string table_type;
string scan_codes;
string scan_table;
string scan_symbol;
int table_index = 0;
int code_length_count = 0;
int code_values_count = 0;
pointer = 0;
dht_bit_lengths_index = 0;

// Decode bits for each marker
for(marker=0;marker<dht_marker_lengths.size();marker++)
begin
code_values_count = 0; // Initialize the code lengths and values to zero
code_length_count = 0;
dht_bit_accumulator = 0;//Sums the total decoded bits for each table of DHT
//v = 0;

table_type = {dht_data[pointer], dht_data[pointer + 1]}; //AC or DC
table_out[table_index]=table_type; //Store it in an array
table_index += 1;
segment = (dht_marker_lengths[marker]*2)-4; //Subtract the marker length data


for(i=2+pointer;i<=pointer+((16*2)+2)-1;i++)
begin
code_lengths[code_length_count]=dht_data[i]; //Traverse the code lengths for that marker
code_length_count += 1;
end
for(j=34;j<=segment-1;j++)
begin
code_values[code_values_count]=dht_data[j+pointer]; //Traverse the code values for that marker
code_values_count += 1;
end

pointer += segment; //Update pointer so it can point to next marker data

first_hit = 0; //This is to check when the first non-zero code length is reached
match = 1; // This is to traverse the matching code values for the code length just found
for(j=0;j<16;j++) //Traverse the code lengths all of which are 16 for each marker
begin

scan_codes={code_lengths[2*j],code_lengths[(2*j)+1]}; //Group two code lengths together
scan_codes_d=scan_codes.atohex(); //Convert to decimal

if(scan_codes_d>0)
begin

dht_bit_accumulator += (j+1)*scan_codes_d; //Calculate the bits for each code

if(first_hit == 0) //Check the very first code length found that was non-zero
begin
dht_code = 0; //Initialize the first code to zero
scan_symbol={code_values[0],code_values[1]}; //Get the symbols for the given length
dht_out[scan_symbol] = dht_code; 
for (w = j; w>=0; w--)
begin
    decoded_dht[v] = dht_code[w]; //Get the bits left to right
    v+=1; //run a marker continuously through the entire DHT data 
end
end // second if end
else
begin
if(scan_codes_d == 1) //Separate decoding for those code lengths whose value was one
begin
scan_symbol={code_values[2*match],code_values[(2*match)+1]};
dht_code = dht_code << 1; //Shift right

for (w = j; w>=0; w--)
begin
    decoded_dht[v] = dht_code[w];
    v+=1;  
end
dht_out[scan_symbol] = dht_code; 
match += 1;
dht_code = (dht_code + 1); //Add 1 to the code

end //third if's end
else
begin
dht_code = (1+dht_code) << 1; //Shift right
for(k=0;k<scan_codes_d;k++)
begin
scan_symbol={code_values[2*match],code_values[(2*match)+1]};
dht_out[scan_symbol] = dht_code; 
for (w = j; w>=0; w--)
begin
    decoded_dht[v] = dht_code[w];
    v+=1;  
end
match += 1;
dht_code += 1;
end //2nd for end
end //third if's else end
end //second if's else end
first_hit += 1;
end //First if end
dht_bit_lengths[dht_bit_lengths_index]= dht_bit_accumulator; //Puts the total bits for each code into an array
end //for end

//Clear the code lengths and values arrays for next marker
code_lengths.delete();
code_values.delete();

dht_bit_lengths_index += 1; //Update index of array containing lengths of bits for each dht table
end

//This is how to show the bits
// for (w = 0; w<decoded_dht.size(); w++)
// begin
//     $display("Decoded bits are %p",decoded_dht[w]);
      
// end

//This is to show bit lengths in the decoded data for each table
// for (w = 0; w<dht_bit_lengths.size(); w++)
// begin
//     $display("Bit lengths are %d",dht_bit_lengths[w]);
// end


/* verilator lint_off UNOPTFLAT */
// foreach(decoded_dht[l,m])
// begin
// $display("Decoded bits are %p",decoded_dht[l][m]);
// end
/* verilator lint_on UNOPTFLAT */


//This is to show the table data
// for (w = 0; w<table_out.size(); w++)
// begin
//     $display("Tables are %s",table_out[w]);
      
// end


end

endmodule