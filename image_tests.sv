//package img_array;
module image_tests(arr);
//output string arr[int];
output string arr[$];

// input clk;
// output logic signed [31:0] out1;
//int file, f_out;
string status;
string char;
//logic [63:0] arr [];
//byte arr [];
//string arr[$];
//int i = 0;
//int j;
//function automatic image_collection();
int file, f_out;
always_comb
begin
    int i = 0;
    file = $fopen("./donald.txt","r");
    f_out = $fopen("./donald_out.txt","w");
    
    while(!$feof(file))
    begin
        
        char = $fgetc(file);
        arr.push_back(char);
        $fwrite(f_out,"%s",char);
        i+=1;
        
        // char = $fgetc(file);
        // arr[i]=char;
        // //$fwrite(f_out,"%s",char);
        // i+=1;
    end
   
    foreach (arr[i])
        begin
        if(arr[i] == "\n")
        begin
            arr.delete(i);
        end
        //$display("Array value = %s at index %d",arr[i],i);
        end
    // for(j = 0; j<arr.size(); j++)
    //     begin
    //     if(arr[j] == "\n")
    //     begin
    //         arr.delete("j");
    //         $display("Deleted");
    //     end
    //     //$display("Array value = %s at index %d",arr[i],i);
    //     end
    // for(j = 0; j<arr.size(); j++)
    //     begin
    //      $display("Array value = %s at index %d",arr[j],j);
    //     end
    //$readmemh(file,arr[i]);
    //$fwrite(f_out,"%h",arr[i]);
    //$fgets(line,file);
    //$display("Array value = %h at index %d",arr[i],i);
    //$display("Line number %d = %s",i,line);
    //i+=1;
  
    // for(i=0;i<2;i+=1)
    // begin
    //     $display("Array value = %h at index %d",arr[i],i);
    // end
    // //$readmemh("./donald.txt", arr);
    //$display("file is = %b",fd);
    //$display("Array is = %h", arr);
    // while(!$feof(fd))
    // begin
    // $fgets(line,fd);
    //i+=1;
    // $display("Line number %d = %s",i,line);
    // end
    $fclose(file);
    $fclose(f_out);
end  

//endfunction 
endmodule
//endpackage