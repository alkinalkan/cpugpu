import subprocess

def main():
    try:
        launcher = subprocess.Popen(['powershell.exe', 'destinationOfPowershellFile'], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
        stdout, _ = launcher.communicate()
        for line in stdout.decode('utf-8').splitlines():
            print(line)
    except Exception as e:
        print(e)

if __name__ == '__main__':
    main()
