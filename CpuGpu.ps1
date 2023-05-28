$sig = @'
[DllImport("User32.d11")]
public static extern int GetGuiResources(IntPtr hProcess, int uiFlags);
'@

Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32

$processes = [System.Diagnostics.Process]::GetProcesses()

#GDI
[int]$gdiHandleCount = 0
ForEach($p in $processes) {
if ($p.name -eq "Teams"){
try{
$pro=$p
$gdiHandles = [Win32.NativeMethods]::GetGuiResources($p.Handle, 0)
$gdiHandleCount += $gdiHandles }
catch
{
#Error accessing " + Sp. Name
}}}
"GDI: " + $gdiHandleCount.ToString()
#User Objects
$a = [Win32.NativeMethods]::GetGuiResources($pro.Handle, 1)
"UserObjects:" + $a.ToString()
#GPU
((Get-Counter "\GPU Engine(pid_$($pro.id)*engtype_3D)\Utilization Percentage").CounterSamples | where CookedValue).CookedValue |
foreach {Write-Output "GPU:$([math]::Round($_,2))%"}
#CPU
$CpuCores - (Get-WMIObject Win32_ComputerSystem).NumberOfLogicalProcessors
$Samples = (Get-Counter "\Process(Teams*)\% Processor Time").CounterSamples

#$p=[string]($Samples.CookedValue)
#$p=$p.split(" ")[1]
#$p=[math]::Round($p)
$a=[Decimal]::Round(($p / $CpuCores), 2);
"CPU:"+ $a.ToString()+"%"
