# This PowerShell script gathers information about a process named "Teams," including GDI, User Objects, GPU, and CPU usage.

# Define a C# signature for the GetGuiResources function in User32.dll using a here-string.
$sig = @'
[DllImport("User32.dll")]
public static extern int GetGuiResources(IntPtr hProcess, int uiFlags);
'@

# Add the C# signature as a type named NativeMethods in the Win32 namespace.
Add-Type -MemberDefinition $sig -Name NativeMethods -Namespace Win32

# Get a list of all running processes.
$processes = [System.Diagnostics.Process]::GetProcesses()

# Initialize variables to track resource usage.
[int]$gdiHandleCount = 0
$pro = $null

# Iterate through each process to find the one named "Teams."
ForEach ($p in $processes) {
    if ($p.Name -eq "Teams") {
        try {
            # Store the Teams process and retrieve its GDI resources.
            $pro = $p
            $gdiHandles = [Win32.NativeMethods]::GetGuiResources($p.Handle, 0)
            $gdiHandleCount += $gdiHandles
        } catch {
            # Handle errors accessing resources for the Teams process.
            # You can add more specific error messages here if needed.
            # For example: Write-Host "Error accessing GDI resources for $($p.Name)"
        }
    }
}

# Print the total GDI handle count.
"GDI: " + $gdiHandleCount.ToString()

# Retrieve and print the number of User Objects for the Teams process.
$a = [Win32.NativeMethods]::GetGuiResources($pro.Handle, 1)
"UserObjects:" + $a.ToString()

# Retrieve and print GPU utilization for the Teams process.
((Get-Counter "\GPU Engine(pid_$($pro.Id)*engtype_3D)\Utilization Percentage").CounterSamples | Where-Object CookedValue).CookedValue |
    ForEach-Object { Write-Output "GPU:$([math]::Round($_, 2))%" }

# Retrieve the number of CPU cores.
$CpuCores = (Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors

# Retrieve and calculate CPU usage for the Teams process.
$Samples = (Get-Counter "\Process(Teams*)\% Processor Time").CounterSamples
$a = [Decimal]::Round(($Samples.CookedValue / $CpuCores), 2)
"CPU:" + $a.ToString() + "%"
