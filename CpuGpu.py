import subprocess

def main():
    try:
        # Start a new subprocess to run a PowerShell command or script.
        # 'powershell.exe' is the command to launch PowerShell.
        # 'destinationOfPowershellFile' should be replaced with the actual path to your PowerShell script or command.
        launcher = subprocess.Popen(['powershell.exe', 'destinationOfPowershellFile'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
        
        # Capture the output (stdout) of the PowerShell command.
        stdout, _ = launcher.communicate()
        
        # Split and print each line of the captured output.
        for line in stdout.decode('utf-8').splitlines():
            print(line)
    
    except Exception as e:
        # Handle any exceptions that may occur during the subprocess execution.
        print(e)

if __name__ == '__main__':
    # This block of code will be executed when the script is run directly (not imported as a module).
    main()
