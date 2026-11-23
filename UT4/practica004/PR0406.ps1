$inventarioCrudo = @"
DEV-01 | MAC:00-1A-2B-3C-4D-5E | RAM:512MB | SN:a1b2 | STATUS:ACTIVE
switch_core_02 | MAC:001a.2b3c.4d5f | RAM:2GB | SN:X9Y8Z | STATUS:MAINTENANCE
router-edge-03 | MAC:00-1A-2B-3C-4D-60 | RAM:1024MB | SN:f4e3d2 | STATUS:ACTIVE
core_switch_04 | MAC:00:1a:2b:3c:4d:61 | RAM:4GB | SN:7m8n | STATUS:RETIRED
"@

$lineas = $inventarioCrudo -split "`n"

$reportes = foreach ($linea in $lineas) {
    $partes = $linea.Split("|")
    $device = $partes[0].ToLower().Replace("_", "-").Trim()
    $macCompleta = $partes[1].Trim()
    $macCompleta = $macCompleta -Split "`MAC:"
    $macNumero = $macCompleta[1]
    $macLimpia = ($macNumero -replace '[^a-fA-F0-9]', '').ToUpper()
    $macFinal = ($macLimpia -replace '..', '$0:').TrimEnd(':')
    $numerosSerie = $partes[3].split(":")
    $numeroSN = $numerosSerie[1].ToUpper().Trim()
    if ($numeroSN.Length -eq 6) {
        $numeroSN = $numeroSN        
    }
    else {
        while ($numeroSN.Length -lt 6) {
            $numeroSN = "0" + $numeroSN
        }
    }
    $ram = $partes[2].Trim()
    $ram = $ram -split "`RAM:"
    $ramLimpia = $ram[1]
    $estado = $partes[4].Trim()
    $estado = $estado -split "`STATUS:" 
    $estadoLimpio = $estado[1]
    if ($estadoLimpio -eq "RETIRED") {
        continue
    }
    [PSCustomObject]@{
        Device       = $device
        MAC          = $macFinal
        RAM          = $ramLimpia
        SerialNumber = $numeroSN
        Status       = $estadoLimpio
    }    
    $reportes | Export-Csv "inventario_red.csv" -NoTypeInformation -Encoding UTF8
}