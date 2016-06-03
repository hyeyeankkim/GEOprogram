import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;
import java.lang.Object;

public class text {
	
	@SuppressWarnings("unused")
	public static void main(String args[]){
	
		String sumFilePath = "C:\\Users\\김혜연\\Downloads\\GSE1112_series_matrix.txt\\GSE1112_series_matrix.txt";
		File file = new File(sumFilePath);
		String dummy = "";
		try {
			BufferedReader br = new BufferedReader(new FileReader(sumFilePath));
			//BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file)));
			StringBuffer sb = new StringBuffer("!series_matrix_table_begin");
		    int position = sb.indexOf("!series_matrix_table_begin");
		
			//1. 삭제하고자 하는 position 이전까지는 이동하며 dummy에 저장
			String line;
			for(int i=0; i<position ; i++) {
			    line = br.readLine(); //읽으며 이동
			    dummy += (line + "\r\n" ); 
			}
			
			//2. 삭제하고자 하는 데이터는 건너뛰기
			String delData = br.readLine();
			System.out.printf("삭제되는 데이터 = "+delData);
			
			//3. 삭제하고자 하는 position 이후부터 dummy에 저장
			while((line = br.readLine())!=null) {
				dummy += (line + "\r\n" ); 
			}
			
			//4. FileWriter를 이용해서 덮어쓰기
			FileWriter fw = new FileWriter(sumFilePath);
			fw.write(dummy);			
			
			//bw.close();
			fw.close();
			br.close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
