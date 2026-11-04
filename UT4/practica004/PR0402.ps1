$recurso=8080
$recurso.GetType().Name
$recurso="Puerto HTTP"
$recurso.GetType().Name

[int]$maxConexiones=100
[bool]$firewallActivo=$true
$maxConexiones = "Cien"

[long]$tamanoBackup=2199023255552
$costeLicencia = 149.95d
$iva = 31.49d
$totalSuma = $costeLicencia + $iva
Write-Host $totalSuma

$fechaActual= Get-Date
Write-Host "Estamos en el año "  $fechaActual.Year
Write-Host "La contraseña caducará en "  $fechaActual.AddDays(45)

$inicio = Get-Date
Start-Sleep -Seconds 3
$fin = Get-Date
[timespan]$tiempoTotal = $fin - $inicio
Write-Host $tiempoTotal

$sys = "Windows Server"
Write-Host $sys.ToUpper()

$user = "ADMINISTRATOR"
Write-Host $user.ToLower()

$ip = " 192.168.1.10 "
write-Host $ip.Trim()

$mac = "00 AA 11 BB 22 CC"
Write-Host $mac.Replace(" ","")