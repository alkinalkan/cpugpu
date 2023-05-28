$sig = @'
[DllImport("User32.d11")]
public static extern int GetGuiResources(IntPtr hProcess, int uiFlags);
'@

# Define a function signature for the external method GetGuiResources from User32.dll.

Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32

# Add the defined function signature to the NativeMethods class in the Win32 namespace.

$processes = [System.Diagnostics.Process]::GetProcesses()

# Get all running processes.

#GDI
[int]$gdiHandleCount = 0
ForEach($p in $processes) {
    if ($p.name -eq "Teams") {
        try {
            $pro = $p
            $gdiHandles = [Win32.NativeMethods]::GetGuiResources($p.Handle, 0)
            $gdiHandleCount += $gdiHandles
        } catch {
            #Error accessing " + Sp. Name
        }
    }
}

# Count the number of GDI handles for the "Teams" process.

"GDI: " + $gdiHandleCount.ToString()

# Output the total number of GDI handles.

#User Objects
$a = [Win32.NativeMethods]::GetGuiResources($pro.Handle, 1)
"UserObjects:" + $a.ToString()

# Get the number of user objects for the "Teams" process and output it.

#GPU
((Get-Counter "\GPU Engine(pid_$($pro.id)*engtype_3D)\Utilization Percentage").CounterSamples | where CookedValue).CookedValue |
    foreach {
        Write-Output "GPU:$([math]::Round($_,2))%"
    }

# Get the GPU utilization percentage for the "Teams" process and output it.

#CPU
$CpuCores - (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
$Samples = (Get-Counter "\Process(Teams*)\% Processor Time").CounterSamples

#$p=[string]($Samples.CookedValue)
#$p=$p.split(" ")[1]
#$p=[math]::Round($p)

$a = [Decimal]::Round(($p / $CpuCores), 2);
"CPU:" + $a.ToString() + "%"

# Calculate the CPU usage percentage for the "Teams" process and output it.
