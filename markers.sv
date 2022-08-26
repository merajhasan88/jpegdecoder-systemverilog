package img_markers;
typedef enum {			
  M_SOF0  = "ffc0",
  M_SOF1  = "ffc1",
  M_SOF2  = "ffc2",
  M_SOF3  = "ffc3",

  M_SOF5  = "ffc5",
  M_SOF6  = "ffc6",
  M_SOF7  = "ffc7",

  M_JPG   = "ffc8",
  M_SOF9  = "ffc9",
  M_SOF10 = "ffca",
  M_SOF11 = "ffcb",

  M_SOF13 = "ffcd",
  M_SOF14 = "ffce",
  M_SOF15 = "ffcf",

  M_DHT   = "ffc4",

  M_DAC   = "ffcc",

  M_RST0  = "ffd0",
  M_RST1  = "ffd1",
  M_RST2  = "ffd2",
  M_RST3  = "ffd3",
  M_RST4  = "ffd4",
  M_RST5  = "ffd5",
  M_RST6  = "ffd6",
  M_RST7  = "ffd7",

  M_SOI   = "ffd8",
  M_EOI   = "ffd9",
  M_SOS   = "ffda",
  M_DQT   = "ffdb",
  M_DNL   = "ffdc",
  M_DRI   = "ffdd",
  M_DHP   = "ffde",
  M_EXP   = "ffdf",

  M_APP0  = "ffe0",
  M_APP1  = "ffe1",
  M_APP2  = "ffe2",
  M_APP3  = "ffe3",
  M_APP4  = "ffe4",
  M_APP5  = "ffe5",
  M_APP6  = "ffe6",
  M_APP7  = "ffe7",
  M_APP8  = "ffe8",
  M_APP9  = "ffe9",
  M_APP10 = "ffea",
  M_APP11 = "ffeb",
  M_APP12 = "ffec",
  M_APP13 = "ffed",
  M_APP14 = "ffee",
  M_APP15 = "ffef",

  M_JPG0  = "fff0",
  M_JPG8  = "fff8",
  M_JPG13 = "fffd",
  M_COM   = "fffe",

  M_TEM   = "ff01"

  //M_ERROR = "ff100"
} JPEG_MARKER;

endpackage

import img_markers::*;

module markers(img_data,dqt_data,dqt_marker_lengths,sof_data, sof_marker_lengths,dht_data, dht_marker_lengths, sos_header);


string arr[$];
image_tests img1(.arr(arr));
output string img_data[int];
output string dqt_data[int];
output int dqt_marker_lengths[int];
output string sof_data[int]; 
output int sof_marker_lengths[int];
int app0_marker_lengths[int];
string app0_data[int]; 
int app1_marker_lengths[int];
string app1_data[int];
output string dht_data[int];
output int dht_marker_lengths[int];
output string sos_header[int];


// int f_out;
// int f_img_data;
// int f_dht_data;
// int f_dqt_data;
// int f_dqt_marker;
// int f_dht_marker;
// int f_sof_data;
// int f_sof_marker;
// int f_app0_data;
// int f_app0_marker;
// int f_app1_data;
// int f_app1_marker;

JPEG_MARKER current_marker;
string buffer[$];
string str_arr;
string len_marker_h;
string next_block;
string temp;



int i  = 0;
int j = 0;
int k = 0;
int l = 0;
int index = 0;
int len_marker_d;
int scan = 0;
int forward =  0;
int count = 0;
// int assoc_array_count = 0;

always_latch
begin

int imgdata_array_count = 0;
int dqtdata_array_count = 0;
int dqtmarker_array_count = 0;
int sofmarker_array_count = 0;
int sofdata_array_count = 0;
int app0data_array_count = 0;
int app0marker_array_count = 0;
int app1data_array_count = 0;
int app1marker_array_count = 0;
int dhtdata_array_count = 0;
int dhtmarker_array_count = 0;
int sos_header_index = 0;




// f_out = $fopen("./string_image.txt","w");
// f_img_data = $fopen("./image_data.txt","w");
// f_dht_data = $fopen("./dht_data.txt","w");
// f_dqt_data = $fopen("./dqt_data.txt","w");
// f_dht_marker = $fopen("./dht_marker.txt","w");
// f_dqt_marker = $fopen("./dqt_marker.txt","w");
// f_sof_data = $fopen("./sof_data.txt","w");
// f_sof_marker = $fopen("./sof_marker.txt","w");
// f_app0_marker = $fopen("./app0_marker.txt","w");
// f_app0_data = $fopen("./app0_data.txt","w");
// f_app1_marker = $fopen("./app1_marker.txt","w");
// f_app1_data = $fopen("./app1_data.txt","w");

// for(i=0;i<arr.size;i+=1)
// begin
//   buffer.push_back(arr[i]);
// end
// $display("Lengths of arr is %d and of buffer is %d", arr.size,buffer.size);

// foreach(arr[index])
// begin
// i=2*index;
// j=i+1;
// // k=j+1;
// // l=k+1;
// str_arr={arr[i],arr[j]};
// if(str_arr == "ff")
// begin
// next_block={arr[i+2],arr[j+2]};
// if(next_block == "db")
// $display("ffdb found at index %d", i);
// end
// end

//for(index = 0; index < (arr.size - 4); index += 1)
//while(l < arr.size)
foreach(arr[index])
begin

i=2*index;
j=i+1;
// k=j+1;
// l=k+1;


str_arr={arr[i],arr[j]};
//$fwrite(f_out,"%s",str_arr);


if (str_arr == "ff")
begin
next_block={arr[i+2],arr[j+2]};

//Searching for ffd8
if(next_block == "d8")
//$display("Start of Image is found at index %d to %d", i,j+2);

//ffe0
if(next_block == "e0")
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
scan = i + 8; //start scanning data
count = 0;
while(count < (len_marker_d*2) - 4)
begin
app0_data[app0data_array_count]=(arr[scan]);
//$fwrite(f_app0_data,"%s",arr[scan]);
scan+=1;
count+=1;
app0data_array_count += 1;
end
app0_marker_lengths[app0marker_array_count]=(len_marker_d);
app0marker_array_count += 1;
//$fwrite(f_app0_marker,"%d",len_marker_d);
//$display("APP0 marker found at index %d to %d with length %d",i,i+3,len_marker_d);
//$display("APP0 marked fround");
end

//ffe1
if(next_block == "e1")
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
scan = i + 8; //start scanning data
count = 0;
while(count < (len_marker_d*2) - 4)
begin
app1_data[app1data_array_count]=(arr[scan]);
//$fwrite(f_app1_data,"%s",arr[scan]);
scan+=1;
count+=1;
app1data_array_count += 1;
end
app1_marker_lengths[app1marker_array_count]=(len_marker_d);
app1marker_array_count += 1;
//$fwrite(f_app1_marker,"%d",len_marker_d);
//$display("APP1 marker found at index %d to %d with length %d",i,i+3,len_marker_d);
//$display("APP1 marker found");
end

//ffda
if(next_block == "da") // next block is i+2, j+2
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
//$display("Start of Scan marker found with length = %d, image data being pushed", len_marker_d);
scan = i + 8; // Start extracting SOS header
count = 0;
while (count < (len_marker_d*2) - 4)
begin
sos_header[sos_header_index] = (arr[scan]);
scan+=1;
count+=1;
sos_header_index += 1;
end

scan = (i+8) + (len_marker_d*2) - 4; //scan is at start of image data
while (scan<arr.size) // Start extracting image data
begin
temp = {arr[scan],arr[scan+1],arr[scan+2],arr[scan+3]};
if(temp !== M_EOI)
begin
img_data[imgdata_array_count]=temp;
//$fwrite(f_img_data,"%s",temp);
scan = scan + 4;
imgdata_array_count += 1;
end
else
break;
end
//$display("SOS found");
//$display("We have reached FFD9");
end

//ffc4
if(next_block == "c4")
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
scan = i + 8; //start scanning data
count = 0;
while(count < (len_marker_d*2) - 4)
begin
dht_data[dhtdata_array_count]=arr[scan];
//$fwrite(f_dht_data,"%s",arr[scan]);
scan+=1;
count+=1;
dhtdata_array_count += 1;
end
dht_marker_lengths[dhtmarker_array_count]=(len_marker_d);
dhtmarker_array_count += 1;
//$fwrite(f_dht_marker,"%d",len_marker_d);
//$display("DHT marker found at index %d to %d with length %d",i,i+3,len_marker_d);
//$display("DHT markers found");
end


//ffdb
if(next_block == "db")
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
scan = i + 8; //start scanning DQT data
count = 0;
while(count < (len_marker_d*2) - 4)
begin
dqt_data[dqtdata_array_count]=(arr[scan]);
//$fwrite(f_dqt_data,"%s",arr[scan]);
scan+=1;
count+=1;
dqtdata_array_count += 1;
end
dqt_marker_lengths[dqtmarker_array_count]=(len_marker_d);
dqtmarker_array_count += 1;
//$fwrite(f_dqt_marker,"%d",len_marker_d);
//$display("DQT marker found at index %d to %d with length %d",i,i+3,len_marker_d);
//$display("DQT markers found");
end

//ffc0
if(next_block == "c0")
begin
len_marker_h ={arr[i+4],arr[j+4],arr[i+6],arr[j+6]}; 
len_marker_d = len_marker_h.atohex();
scan = i + 8; //start scanning data
count = 0;
while(count < (len_marker_d*2) - 4)
begin
sof_data[sofdata_array_count]=(arr[scan]);
//$fwrite(f_sof_data,"%s",arr[scan]);
scan+=1;
count+=1;
sofdata_array_count += 1;
end
sof_marker_lengths[sofmarker_array_count]=(len_marker_d);
sofmarker_array_count += 1;
//$fwrite(f_sof_marker,"%d",len_marker_d);
//$display("SOF marker found at index %d to %d with length %d",i,i+3,len_marker_d);
//$display("SOF markers found");
end


// if(str_arr == M_SOS)
// begin
// len_marker_h ={arr[i+4],arr[j+4],arr[k+4],arr[l+4]}; 
// len_marker_d = len_marker_h.atohex();
// $display("Start of Scan marker found with length = %d, image data being pushed", len_marker_d);

// scan = l + (len_marker_d*2) + 1; //scan is at start of image data
// while (scan<arr.size)
// begin
// temp = {arr[scan],arr[scan+1],arr[scan+2],arr[scan+3]};
// if(temp !== M_EOI)
// begin
// img_data.push_back(temp);
// $fwrite(f_img_data,"%s",temp);
// scan = scan + 4;
// end
// else
// break;
// end

// // scan = l + (len_marker_d*2) + 1; //scan is at start of image data
// // while (temp !== M_EOI)
// // begin
// // temp = {arr[scan],arr[scan+1],arr[scan+2],arr[scan+3]};
// // img_data.push_back(temp);
// // scan = scan + 4;
// // end
// $display("We have reached FFD9");
// end

// if(str_arr == M_DHT)
// begin
// len_marker_h ={arr[i+4],arr[j+4],arr[k+4],arr[l+4]}; 
// len_marker_d = len_marker_h.atohex();
// scan = i + 8; //start scanning DHT data
// count = 0;
// while(count < (len_marker_d*2) - 4)
// begin
// //dht_data.push_back(arr[scan]);
// $fwrite(f_dht_data,"%s",arr[scan]);
// scan+=1;
// count+=1;
// end
// dht_marker_lengths.push_back(len_marker_d);
// $fwrite(f_dht_marker,"%d",len_marker_d);
// $display("DHT marker found at index %d to %d with length %d",i,l,len_marker_d);
// $display("DHT data transferred to its string queue");
// end




// if(str_arr == M_DQT)
// begin
// len_marker_h ={arr[i+4],arr[j+4],arr[k+4],arr[l+4]}; 
// len_marker_d = len_marker_h.atohex();
// scan = i + 8; //start scanning DQT data
// count = 0;
// while(count < (len_marker_d*2) - 4)
// begin
// //dqt_data.push_back(arr[scan]);
// $fwrite(f_dqt_data,"%s",arr[scan]);
// scan+=1;
// count+=1;
// end
// dqt_marker_lengths.push_back(len_marker_d);
// $fwrite(f_dqt_marker,"%d",len_marker_d);
// $display("DQT data transferred to its string queue");
// $display("DQT marker found at index %d to %d with length %d",i,l,len_marker_d);
// end







//index+=1;
end

// foreach(img_data[data])
// begin
// $fwrite(f_img_data,"%s",img_data[data]);
// end

// foreach(dht_marker_lengths[x])
// begin
// $fwrite(f_dht_data,"%d",dht_marker_lengths[x]);
// end

// foreach(dqt_marker_lengths[x])
// begin
// $fwrite(f_dqt_data,"%d",dqt_marker_lengths[x]);
// end
end

// $fclose(f_out);
// $fclose(f_img_data);
// $fclose(f_dht_data);
// $fclose(f_dqt_data);
// $fclose(f_dht_marker);
// $fclose(f_dqt_marker);
// $fclose(f_sof_data);
// $fclose(f_sof_marker);
// $fclose(f_app0_data);
// $fclose(f_app0_marker);
// $fclose(f_app1_data);
// $fclose(f_app1_marker);
//$fclose(f_in);

end
endmodule
// for(i=0;i<arr.size;i+=1)
// begin
//   //buffer = arr.getc(i);
//   //buffer = arr[i];
//   //buffer.push_back(arr.getc(i));
//   buffer.push_back(arr[i]);
//   //$display("Buffer = %s",buffer[i],i);
// end
//endpackage

//f_in = $fopen("./string_image.txt","r");
// while(!$feof(f_in))
// // i = 0;
// // while(i<arr.size)
// begin
// //code = $fscanf(f_in,"%s",line);
// //$display("Code is %d", code);
//$fgets(line,f_in);
// //i+=1;
// end
// //$fgets(line,f_in);
//$display("Output string is = %s", line);
//$display("Length of array is %d",arr.size);
//$display("Length of string is %d", line.len());
// $fwrite(f_out,"%s",str_arr);
// $display("Length of string is %d", str_arr.len());

//$display("String array is = %s",str_arr);


// for(i=0;i<(str_arr.len()-3);i+=1)
// begin
// j=i+3;  
// if(str_arr.substr(i,j) == "ffd8")
// $display("FFD8 found between indices %d and %d", i, j);
// end



//end
//// foreach(buffer[index])
// begin
// if(buffer[index] == "f")
// //$fwrite(f_out,"%d",index);
// //$display("Character 'f' found at %d", index);
// end
//foreach(buffer[i])
//$display("Buffer = %d",buffer);

// char = arr.getc(i);

// buffer.push_back(char); 
//buffer = arr.getc(i);
// if(i % 4 !== 0);
// begin
// current_marker = M_SOI;
// if(buffer == current_marker)
// $display("FFD8 marker found");
// buffer = 32'h0;
// break;
// end
// i+=1;
// end
// foreach(buffer[idx])
// begin
//   $display("Buffer is = %s",buffer);
// end
//buffer = arr[(i*16)+:16];
//buffer = arr.substr(i,i+3);




// current_marker = M_SOI;
// if(buffer == current_marker)
// $display("FFD8 marker found");
