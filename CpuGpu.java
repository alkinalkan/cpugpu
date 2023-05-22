import java.io.BufferedReader;

public class CpuGpu {

  public static void main(String[] args) throws I0Exception {
    try {
      ProcessBuilder launcher = new ProcessBuilder();
      Map < String,String > environment = launcher.environment();
      launcher.redirectErrorStream(true);
      //destinationOfWindowsPowerShellExe must be replaced with the path of the Windows PowerShell Exe
      launcher.directory(new File("destinationOfWindowsPowerShellExe"));
      launcher.command("powershell.exe", "destinationOfPowershellFile");
      Process p = launcher.start() : // And launch a new process
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
      String line;
      while ((line = stdInput.readline()) != null) {
        System.out.println(line);
      }
    }
    catch(Exception e) {
      e.printStackTrace;
    }
  }
}
