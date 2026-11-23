$logsVPN = @"
  ID:45 ; USER:Carlos.Gomez@miempresa.local ; IP:192.168.1.50:443 ; MB:1250 ; STATE:CONNECTED  
  ID:7 ; USER:ana_martinez@miempresa.local ; IP:10.0.5.12:1194 ; MB:512 ; STATE:TIMEOUT  
  ID:108 ; USER:ADMIN_SISTEMAS@miempresa.local ; IP:172.16.0.88:443 ; MB:0 ; STATE:TEST  
  ID:19 ; USER:luis.perez@miempresa.local ; IP:192.168.10.200:8443 ; MB:3400 ; STATE:DISCONNECTED  
"@

$lineas = $logsVPN -split "`n"

$reportes = foreach ($linea in $lineas) {
    $partes = $linea.Split(";").Trim()
    $id = $partes[0].Split(":").Trim()
    $user = $partes[1].Split("@").Trim().ToLower().Replace("-", ".")
    $user2 = $user.Split(":")
    $userFinal = $user2[1]
    $idLimpia = $id[1]
    $ip = $partes[2].Trim().Split(":")
    $ipFinal = $ip[1]
    $MB = $partes[3].Trim().Split(":")
    $MBdivision = $MB[1] / 1024
    $MBFinal = [Math]::Round($MBdivision, 2)
    $estado = $partes[4].Split(":").Trim()
    $estadoLimpio = $estado[1]
    if ($idLimpia.Length -eq 4) {
        $idLimpia = $idLimpia       
    }
    else {
        while ($idLimpia.Length -lt 4) {
            $idLimpia = "0" + $idLimpia
        }
    }
    if ($estadoLimpio -eq "TEST") {
        continue
    }
    [PSCustomObject]@{
        SessionID = $idLimpia
        Username  = $userFinal
        ClientIP  = $ipFinal
        TrafficGB = $MBFinal
        Status    = $estadoLimpio
    }    
}
$reportes | Export-Csv "reporte_vpn1.csv" -NoTypeInformation -Encoding UTF8